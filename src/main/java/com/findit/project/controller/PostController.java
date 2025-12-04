package com.findit.project.controller;

import com.findit.project.domain.Post;
import com.findit.project.domain.User;
import com.findit.project.domain.PostImage;
import com.findit.project.domain.Comment;
import com.findit.project.service.PostService;
import com.findit.project.service.CommentService;
import com.findit.project.repository.PostImageRepository;
import com.findit.project.repository.CommentRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.time.LocalDateTime;

@Controller
@RequiredArgsConstructor
@RequestMapping("/posts")
public class PostController {

    private final PostService postService;
    private final CommentService commentService;
    private final PostImageRepository postImageRepository;
    private final CommentRepository commentRepository;
    
    // [중요 수정 1] 여기에 있던 private RedirectAttributes ... 코드는 삭제했습니다! (여기 있으면 안 됨)

    // 1. 게시글 목록 조회 및 검색
	@GetMapping("/list")
    public String list(Model model, 
                       // [중요 수정 2] value="..." 로 이름을 명확하게 지정 (에러 방지)
                       @RequestParam(value = "keyword", defaultValue = "") String keyword,
                       @RequestParam(value = "type", defaultValue = "ALL") String type,
                       @RequestParam(value = "category", defaultValue = "ALL") String category) {
        
        List<Post> posts = postService.searchAndFilter(keyword, type, category);
        
        model.addAttribute("posts", posts);
        model.addAttribute("currentKeyword", keyword);
        model.addAttribute("currentType", type);
        model.addAttribute("currentCategory", category);
        
        return "posts/list";
    }

    // 2. 글쓰기 폼 이동
    @GetMapping("/insertForm")
    // [중요 수정 3] RedirectAttributes를 파라미터로 받음
    public String insertForm(HttpServletRequest request, RedirectAttributes redirectAttributes) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
        	redirectAttributes.addFlashAttribute("errorMessage", "로그인이 필요합니다.");
        	return "redirect:/users/loginForm";
        }
        return "posts/writeForm";
    }

    // 3. 글쓰기 처리
    @PostMapping("/insert")
    public String insert(Post post, 
                         @RequestParam(value = "imageFiles", required = false) List<MultipartFile> imageFiles,
                         HttpServletRequest request,
                         RedirectAttributes redirectAttributes) throws java.io.IOException { // [중요 수정 3] 파라미터 추가
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "로그인 세션이 만료되었습니다. 다시 로그인해주세요.");
            return "redirect:/users/loginForm";
       }
        User loginUser = (User) session.getAttribute("loginUser");

        post.setUser(loginUser);
        post.setLostDate(LocalDateTime.now());
        post.setStatus("PROCEEDING");

        postService.insert(post, imageFiles);

        return "redirect:/posts/list";
    }
    
    // 4. 상세 보기
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable("id") Long id, Model model, HttpServletRequest request) {
        Post post = postService.select(id);
        List<PostImage> images = postImageRepository.findByPost(post);
        List<Comment> comments = commentRepository.findByPostOrderByCreatedAtAsc(post);

        model.addAttribute("post", post);
        model.addAttribute("images", images);
        model.addAttribute("comments", comments);
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            model.addAttribute("loginUser", session.getAttribute("loginUser"));
        }

        return "posts/detail";
    }

    // 5. 댓글 작성
    @PostMapping("/{postId}/comments")
    public String writeComment(@PathVariable("postId") Long postId, 
                               @RequestParam("content") String content, 
                               HttpServletRequest request) {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("loginUser") == null) {
            return "redirect:/users/login";
        }

        User loginUser = (User) session.getAttribute("loginUser");
        
        commentService.insert(loginUser.getId(), postId, content);
        
        return "redirect:/posts/detail/" + postId;
    }
    
    // 6. 상태 변경 처리
    @PostMapping("/{postId}/status")
    public String updateStatus(@PathVariable("postId") Long postId, @RequestParam("status") String status, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            return "redirect:/users/login";
        }

        postService.updateStatus(postId, status);

        return "redirect:/posts/detail/" + postId;
    }
}
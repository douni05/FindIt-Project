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
	private RedirectAttributes redirectAttributes;

    // 1. 게시글 목록 조회
    @GetMapping("/list")
    public String list(Model model) {
        // PDF 스타일: selectAll() 호출
        List<Post> list = postService.selectAll();
        model.addAttribute("posts", list);
        return "posts/list";
    }

    // 2. 글쓰기 폼 이동
    @GetMapping("/insertForm")
    public String insertForm(HttpServletRequest request) {
        // 로그인 체크 로직
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
        	redirectAttributes.addFlashAttribute("errorMessage", "로그인이 필요합니다.");
        	return "redirect:/users/loginForm";
        }
        return "posts/writeForm";
    }

    // 3. 글쓰기 처리
    // DTO 없이 Post 엔티티를 직접 사용합니다.
    @PostMapping("/insert")
    public String insert(Post post, 
                         @RequestParam(value="imageFiles", required=false) List<MultipartFile> imageFiles,
                         HttpServletRequest request) throws java.io.IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "로그인 세션이 만료되었습니다. 다시 로그인해주세요.");
            return "redirect:/users/loginForm";
       }
        User loginUser = (User) session.getAttribute("loginUser");

        post.setUser(loginUser);               // 작성자 세팅
        post.setLostDate(LocalDateTime.now()); // 작성일 세팅
        post.setStatus("PROCEEDING");          // 상태 세팅

        // 서비스의 insert() 호출
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
        
        return "redirect:/posts/detail/" + postId; // 다시 상세 페이지로 돌아가기
    }
    
    // 6. 상태 변경 처리
    @PostMapping("/{postId}/status")
    public String updateStatus(@PathVariable("postId") Long postId, @RequestParam("status") String status, HttpServletRequest request) {
        // 로그인 체크
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            return "redirect:/users/login";
        }

        // 서비스 호출
        postService.updateStatus(postId, status);

        return "redirect:/posts/detail/" + postId; // 다시 상세 페이지로
    }
}
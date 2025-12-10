package com.findit.project.controller;

import com.findit.project.domain.*;
import com.findit.project.repository.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final UserRepository userRepository;
    private final PostRepository postRepository;
    private final NoticeRepository noticeRepository;
    private final CommentRepository commentRepository;

    // 관리자 체크 메서드
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("loginUser");
        return user != null && "ADMIN".equals(user.getRole());
    }

    // 1. 관리자 대시보드
    @GetMapping
    public String dashboard(Model model, HttpServletRequest request) {
        if (!isAdmin(request)) return "redirect:/";

        long userCount = userRepository.count();
        long postCount = postRepository.count();
        long solvedCount = postRepository.findAll().stream()
                .filter(p -> "COMPLETE".equals(p.getStatus())).count();

        LocalDateTime threeMonthsAgo = LocalDateTime.now().minusMonths(3);
        List<Post> longTermItems = postRepository.findAll().stream()
                .filter(p -> "PROCEEDING".equals(p.getStatus()) 
                        && p.getLostDate() != null 
                        && p.getLostDate().isBefore(threeMonthsAgo))
                .collect(Collectors.toList());

        model.addAttribute("users", userRepository.findAll());
        model.addAttribute("posts", postRepository.findAllByOrderByCreatedAtDesc());
        model.addAttribute("notices", noticeRepository.findAllByOrderByCreatedAtDesc());
        
        model.addAttribute("userCount", userCount);
        model.addAttribute("postCount", postCount);
        model.addAttribute("solvedCount", solvedCount);
        model.addAttribute("longTermItems", longTermItems);

        return "admin/dashboard";
    }

    // 2. 공지사항 등록
    @PostMapping("/notice/write")
    public String writeNotice(@RequestParam("title") String title, 
                              @RequestParam("content") String content, 
                              HttpServletRequest request) {
        
        if (!isAdmin(request)) return "redirect:/";
        
        Notice notice = new Notice();
        notice.setTitle(title);
        notice.setContent(content);
        noticeRepository.save(notice);
        
        return "redirect:/admin"; // 다시 관리자 페이지로
    }

    // 3. 게시글 강제 삭제
    @GetMapping("/post/delete/{id}")
    public String deletePost(@PathVariable("id") Long id, HttpServletRequest request) {
        if (!isAdmin(request)) return "redirect:/";
        postRepository.deleteById(id);
        return "redirect:/admin";
    }

    // 4. 회원 강제 탈퇴
    @GetMapping("/user/delete/{id}")
    public String deleteUser(@PathVariable("id") Long id, HttpServletRequest request) {
        if (!isAdmin(request)) return "redirect:/";
        userRepository.deleteById(id);
        return "redirect:/admin";
    }
}
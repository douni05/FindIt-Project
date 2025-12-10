package com.findit.project.controller;

import com.findit.project.domain.User;
import com.findit.project.domain.Notice;
import com.findit.project.repository.NoticeRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.findit.project.service.PostService; 
import com.findit.project.domain.Post;

@Controller
@RequiredArgsConstructor
public class HomeController {
	private final PostService postService;
	private final NoticeRepository noticeRepository;
	
    @GetMapping("/")
    public String home(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            User loginUser = (User) session.getAttribute("loginUser");
            if (loginUser != null) {
                model.addAttribute("user", loginUser); // 화면에 사용자 정보 전달
            }
        }
        
        List<Post> recentPosts = postService.selectAll(); // selectAll()은 최신순 정렬이 되어 있음
        
        if (recentPosts.size() > 5) {
            recentPosts = recentPosts.subList(0, 5);
        }
        model.addAttribute("recentPosts", recentPosts);
        
        List<Notice> notices = noticeRepository.findAllByOrderByCreatedAtDesc();
        if (notices.size() > 3) {
            notices = notices.subList(0, 3);
        }
        model.addAttribute("notices", notices);
        
        return "home";
    }
}
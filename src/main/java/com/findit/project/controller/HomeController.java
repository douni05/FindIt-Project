package com.findit.project.controller;

import com.findit.project.domain.User;
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
	
    @GetMapping("/")
    public String home(HttpServletRequest request, Model model) {
        // 세션에서 로그인한 사용자 정보 꺼내기
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            User loginUser = (User) session.getAttribute("loginUser");
            if (loginUser != null) {
                model.addAttribute("user", loginUser); // 화면에 사용자 정보 전달
            }
        }
        
        List<Post> recentPosts = postService.selectAll(); // selectAll()은 최신순 정렬이 되어 있음
        // 목록이 너무 길면 성능 이슈가 있으므로 5개만 자릅니다.
        if (recentPosts.size() > 5) {
            recentPosts = recentPosts.subList(0, 5);
        }
        model.addAttribute("recentPosts", recentPosts); // 화면에 데이터 전달
        
        return "home";
    }
}
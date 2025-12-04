package com.findit.project.controller;

import com.findit.project.domain.User;
import com.findit.project.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam; // @RequestParam 사용을 위해 추가

@Controller
@RequiredArgsConstructor
@RequestMapping("/users") 
public class UserController {

    private final UserService userService;

    // 1. 회원가입 페이지 보여주기
    @GetMapping("/insertForm")
    public String insertForm() {
        return "users/joinForm"; 
    }

    // 2. 회원가입 처리하기
    @PostMapping("/insert")
    public String insert(User user, Model model) { 
        try {
            userService.insert(user);
        } catch (IllegalStateException e) {
            //복 아이디 예외 발생 시 에러 메시지를 담아서 다시 가입 폼으로 보냄
            model.addAttribute("errorMessage", e.getMessage()); // "이미 존재하는 회원 아이디입니다."
            return "users/joinForm"; 
        }
        return "redirect:/";
    }

    // 3. 로그인 페이지 보여주기
    @GetMapping("/loginForm")
    public String loginForm() {
        return "users/loginForm";
    }

    // 4. 로그인 처리
    @PostMapping("/login")
    public String login(@RequestParam("loginId") String loginId, 
    					@RequestParam("password") String password, 
    					HttpServletRequest request) {
        User loginUser = userService.login(loginId, password); // 서비스의 login 호출

        if (loginUser == null) {
            return "redirect:/users/loginForm"; 
        }

        HttpSession session = request.getSession();
        session.setAttribute("loginUser", loginUser);

        return "redirect:/";
    }

    // 5. 로그아웃 처리
    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); 
        }
        return "redirect:/";
    }
}
package com.findit.project.controller;

import com.findit.project.domain.User;
import com.findit.project.repository.PostRepository;
import com.findit.project.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
@RequestMapping("/users") 
public class UserController {

    private final UserService userService;
    private final PostRepository postRepository;
    
    // 1. 회원가입 페이지 보여주기
    @GetMapping("/insertForm")
    public String insertForm() {
        return "users/joinForm"; 
    }

    // 2. 회원가입 처리하기 (중복 예외 처리 포함)
    @PostMapping("/insert")
    public String insert(User user, Model model) { 
        try {
            userService.insert(user);
        } catch (IllegalStateException e) {
            // "이미 존재하는 아이디입니다" 또는 "이미 가입된 전화번호입니다"
            model.addAttribute("errorMessage", e.getMessage()); 
            return "users/joinForm"; 
        }
        return "redirect:/";
    }

    // 3. 로그인 페이지 보여주기
    @GetMapping("/loginForm")
    public String loginForm() {
        return "users/loginForm";
    }

    // 4. 로그인 처리 (예외 처리 강화)
    @PostMapping("/login")
    public String login(@RequestParam("loginId") String loginId, 
                        @RequestParam("password") String password, 
                        HttpServletRequest request,
                        Model model) {
        
        try {
            User loginUser = userService.login(loginId, password);
            
            HttpSession session = request.getSession();
            session.setAttribute("loginUser", loginUser);
            
            return "redirect:/";
            
        } catch (IllegalArgumentException e) {
            // 아이디 없음 or 비밀번호 불일치 에러 메시지 전달
            model.addAttribute("errorMessage", e.getMessage());
            return "users/loginForm"; 
        }
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
    
    // 마이페이지 이동
    @GetMapping("/myPage")
    public String myPage(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            return "redirect:/users/loginForm";
        }
        User user = (User) session.getAttribute("loginUser");
        
        model.addAttribute("user", user);
        // 내가 쓴 글 목록 조회
        model.addAttribute("myPosts", postRepository.findByUserOrderByCreatedAtDesc(user));
        
        return "users/myPage";
    }

    // 내 정보 수정
    @PostMapping("/update")
    public String update(User formUser, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return "redirect:/users/loginForm";
        }

        // 서비스 호출
        userService.update(loginUser.getId(), formUser.getName(), formUser.getPhone());

        // 세션 정보 갱신
        loginUser.setName(formUser.getName());
        loginUser.setPhone(formUser.getPhone());
        session.setAttribute("loginUser", loginUser);

        return "redirect:/users/myPage";
    }
    
    // 비밀번호 변경 처리
    @PostMapping("/updatePassword")
    public String updatePassword(@RequestParam("currentPassword") String currentPassword,
                                 @RequestParam("newPassword") String newPassword,
                                 HttpServletRequest request,
                                 RedirectAttributes redirectAttributes) {
        
        HttpSession session = request.getSession(false);
        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            return "redirect:/users/loginForm";
        }

        try {
            // 서비스 호출 (비번 변경)
            userService.updatePassword(loginUser.getId(), currentPassword, newPassword);
            
            // 성공 시 세션 정보도 업데이트
            loginUser.setPassword(newPassword);
            session.setAttribute("loginUser", loginUser);
            
            redirectAttributes.addFlashAttribute("message", "비밀번호가 성공적으로 변경되었습니다.");
        
        } catch (IllegalArgumentException e) {
            // 실패 시 (현재 비번 틀림 등)
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/users/myPage";
    }
}
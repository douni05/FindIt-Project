package com.findit.project.service;

import com.findit.project.domain.User;
import com.findit.project.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserService {

    private final UserRepository userRepository;

    /**
     * 회원 가입 로직 (insert)
     */
    @Transactional 
    public Long insert(User user) {
        // 1. 중복 아이디 검증
        validateDuplicateUser(user.getLoginId());

        // 2. 역할(Role) 기본값 설정
        user.setRole("USER"); 

        // 3. 저장
        userRepository.save(user);
        return user.getId();
    }

    // 중복 회원 검증 메서드
    private void validateDuplicateUser(String loginId) {
        userRepository.findByLoginId(loginId)
                .ifPresent(m -> {
                    throw new IllegalStateException("이미 존재하는 회원 아이디입니다.");
                });
    }
    
    /**
     * 로그인 로직
     */
    public User login(String loginId, String password) {
        return userRepository.findByLoginId(loginId)
                .filter(u -> u.getPassword().equals(password))
                .orElse(null);
    }
}
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

        // 2. 중복 전화번호 검증
        validateDuplicatePhone(user.getPhone());
        
        // 3. 역할(Role) 기본값 설정
        user.setRole("USER"); 

        // 4. 저장
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
    
    // 전화번호 중복 검증
    private void validateDuplicatePhone(String phone) {
        userRepository.findByPhone(phone)
                .ifPresent(m -> {
                    throw new IllegalStateException("이미 가입된 전화번호입니다.");
                });
    }
    
    /**
     * 로그인 로직 (예외 처리 강화)
     */
    public User login(String loginId, String password) {
        // 1. 아이디 조회
        User user = userRepository.findByLoginId(loginId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 아이디입니다."));
        
        // 2. 비밀번호 검증
        if (!user.getPassword().equals(password)) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }
        
        return user;
    }
    
    /**
     * 회원 정보 수정 (Dirty Checking)
     */
    @Transactional
    public void update(Long id, String newName, String newPhone) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("회원이 존재하지 않습니다."));
        
        // 이름과 전화번호 변경 (JPA가 알아서 감지하고 DB 업데이트)
        user.setName(newName);
        user.setPhone(newPhone);
    }
    
    /**
     * 비밀번호 전용 변경 로직
     */
    @Transactional
    public void updatePassword(Long userId, String currentPassword, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("회원이 존재하지 않습니다."));

        // 1. 현재 비밀번호가 맞는지 확인
        if (!user.getPassword().equals(currentPassword)) {
            throw new IllegalArgumentException("현재 비밀번호가 일치하지 않습니다.");
        }

        // 2. 맞으면 새 비밀번호로 변경
        user.setPassword(newPassword);
    }
}
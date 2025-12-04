package com.findit.project.repository;

import com.findit.project.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    // 로그인 ID로 회원 정보 찾기 (로그인 기능용)
    Optional<User> findByLoginId(String loginId);
}
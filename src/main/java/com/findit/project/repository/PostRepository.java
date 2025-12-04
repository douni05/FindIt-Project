package com.findit.project.repository;

import com.findit.project.domain.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface PostRepository extends JpaRepository<Post, Long> {
    // 모든 게시글을 최신순(내림차순)으로 조회
    List<Post> findAllByOrderByCreatedAtDesc();
    
    // (선택) 건물명으로 검색하기
    List<Post> findByBuildingContaining(String building);
}
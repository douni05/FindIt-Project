package com.findit.project.repository;

import com.findit.project.domain.Post;
import com.findit.project.domain.User;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface PostRepository extends JpaRepository<Post, Long> {
    // 모든 게시글을 최신순(내림차순)으로 조회
    List<Post> findAllByOrderByCreatedAtDesc();    
    List<Post> findByBuildingContaining(String building);
    List<Post> findByUserOrderByCreatedAtDesc(User user);
    
    List<Post> findByTitleContainingOrContentContainingOrBuildingContainingAndTypeContainingAndCategoryContainingOrderByCreatedAtDesc(
		String titleKeyword, String contentKeyword, String buildingKeyword, String type, String category
    );
}
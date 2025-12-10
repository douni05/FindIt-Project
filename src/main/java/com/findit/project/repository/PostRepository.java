package com.findit.project.repository;

import com.findit.project.domain.Post;
import com.findit.project.domain.User;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PostRepository extends JpaRepository<Post, Long> {
    // 모든 게시글을 최신순(내림차순)으로 조회
    List<Post> findAllByOrderByCreatedAtDesc();    
    List<Post> findByBuildingContaining(String building);
    List<Post> findByUserOrderByCreatedAtDesc(User user);
    
    @Query("SELECT p FROM Post p WHERE " +
            // 키워드 검색 (제목 OR 내용 OR 건물) - 키워드가 빈 문자열이면 이 조건 전체를 무시
            "(:keyword = '' OR p.title LIKE %:keyword% OR p.content LIKE %:keyword% OR p.building LIKE %:keyword%) AND " +
            // 유형 필터 (type이 빈 문자열이면 조건 무시)
            "(:type = '' OR p.type = :type) AND " +
            // 카테고리 필터 (category가 빈 문자열이면 조건 무시)
            "(:category = '' OR p.category = :category) " +
            "ORDER BY p.createdAt DESC")
     List<Post> searchAndFilter(
         @Param("keyword") String keyword, 
         @Param("type") String type, 
         @Param("category") String category
     );
}
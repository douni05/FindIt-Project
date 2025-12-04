package com.findit.project.repository;

import com.findit.project.domain.Comment;
import com.findit.project.domain.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    // 특정 게시글의 댓글 목록 조회 (오래된 순)
    List<Comment> findByPostOrderByCreatedAtAsc(Post post);
}
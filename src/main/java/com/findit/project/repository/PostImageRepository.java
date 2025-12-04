package com.findit.project.repository;

import com.findit.project.domain.PostImage;
import com.findit.project.domain.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface PostImageRepository extends JpaRepository<PostImage, Long> {
    // 특정 게시글의 모든 사진 조회
    List<PostImage> findByPost(Post post);
}
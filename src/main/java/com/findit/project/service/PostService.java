package com.findit.project.service;

import com.findit.project.domain.Post;
import com.findit.project.domain.PostImage;
import com.findit.project.repository.PostRepository;
import com.findit.project.repository.PostImageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File; 
import java.io.IOException;
import java.util.List;
import java.util.UUID;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PostService {

    private final PostRepository postRepository;
    private final PostImageRepository postImageRepository;

    private final String uploadDir = "C:/findit-images/";
    
    /**
     * 게시글 저장 (insert)
     */
    @Transactional
    public void insert(Post post, List<MultipartFile> imageFiles) throws IOException {
        // 1. 게시글 저장 (Controller에서 데이터가 이미 채워져서 옴)
        postRepository.save(post);
        
        // 2. 이미지 저장 로직 (유지)
        if (imageFiles != null && !imageFiles.isEmpty()) {
            File directory = new File(uploadDir);
            if (!directory.exists()) {
                directory.mkdirs();
            }

            for (MultipartFile file : imageFiles) {
                if (file.isEmpty()) continue;

                String orgName = file.getOriginalFilename();
                String uuid = UUID.randomUUID().toString();
                String saveName = uuid + "_" + orgName;
                String filePath = uploadDir + saveName;

                file.transferTo(new File(filePath));

                PostImage postImage = new PostImage();
                postImage.setPost(post);
                postImage.setOrgName(orgName);
                postImage.setSaveName(saveName);
                postImage.setFilePath(filePath);

                postImageRepository.save(postImage);
            }
        }
    }

    /**
     * 전체 조회 (selectAll)
     */
    public List<Post> selectAll() {
        return postRepository.findAllByOrderByCreatedAtDesc();
    }
    
    /**
     * 상세 조회 (select)
     */
    public Post select(Long id) {
        Optional<Post> post = postRepository.findById(id);
        if (post.isPresent()) {
            return post.get();
        } else {
            return null;
        }
    }
    
    /**
     * 상태 변경 (PROCEEDING <-> COMPLETE)
     */
    @Transactional
    public void updateStatus(Long postId, String status) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("게시글이 없습니다."));
        post.setStatus(status); // JPA의 변경 감지(Dirty Checking)로 자동 저장됨
    }
}
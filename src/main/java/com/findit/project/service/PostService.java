package com.findit.project.service;

import com.findit.project.domain.Post;
import com.findit.project.domain.PostImage;
import com.findit.project.repository.PostRepository;
import com.findit.project.repository.PostImageRepository;
import lombok.RequiredArgsConstructor;

import org.springframework.beans.factory.annotation.Value;
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

    private final String uploadDir = System.getProperty("user.dir") + "/uploads/";
    
    /**
     * 게시글 저장 (insert)
     */
    @Transactional
    public void insert(Post post, List<MultipartFile> imageFiles) throws IOException {
        // 1. 게시글 저장
        postRepository.save(post);
        
        // 2. 이미지 저장 로직
        if (imageFiles != null && !imageFiles.isEmpty()) {
            
            // 폴더가 없으면 자동으로 생성
            File directory = new File(uploadDir);
            if (!directory.exists()) {
                boolean created = directory.mkdirs();
                if(created) System.out.println("✅ uploads 폴더 생성 완료: " + uploadDir);
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
        post.setStatus(status);
    }
    
    /**
     * 키워드 검색 및 필터링 기능
     * @param keyword 검색어 (제목, 내용, 장소에 모두 적용)
     * @param type 유형 필터 (LOST, FOUND, 또는 전체)
     * @param category 카테고리 필터 (전자기기, 지갑 등, 또는 전체)
     * @return 필터링된 게시글 목록
     */
    public List<Post> searchAndFilter(String keyword, String type, String category) {	
        // 검색어와 필터가 없는 경우 (전체 조회)
        if (keyword.isEmpty() && type.equals("ALL") && category.equals("ALL")) {
            return postRepository.findAllByOrderByCreatedAtDesc();
        }

        // 1. 키워드 처리 (키워드가 없으면 빈 문자열로 대체하여 검색에 영향 X)
        String finalKeyword = keyword.isEmpty() ? "" : keyword;

        // 2. 유형 처리 (ALL이면 빈 문자열로 대체하여 검색에 영향 X)
        String finalType = type.equals("ALL") ? "" : type;

        // 3. 카테고리 처리 (ALL이면 빈 문자열로 대체하여 검색에 영향 X)
        String finalCategory = category.equals("ALL") ? "" : category;

        // JPA Query Method 호출 (OR 조건으로 키워드를 검색하고, AND 조건으로 Type/Category 필터링)
        return postRepository.findByTitleContainingOrContentContainingOrBuildingContainingAndTypeContainingAndCategoryContainingOrderByCreatedAtDesc(
            finalKeyword,   // Title 검색
            finalKeyword,   // Content 검색
            finalKeyword,   // Building 검색
            finalType,      // Type 필터
            finalCategory   // Category 필터
        );
    }
}
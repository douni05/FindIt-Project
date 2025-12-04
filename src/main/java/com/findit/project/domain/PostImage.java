package com.findit.project.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "post_images")
@Getter
@Setter
public class PostImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "img_id")
    private Long id;

    // 어떤 게시글의 사진인지 연결 (Many Images to One Post)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "post_id", nullable = false)
    private Post post;

    @Column(name = "org_name", nullable = false)
    private String orgName; // 사용자가 올린 원래 파일명 (예: 내지갑.jpg)

    @Column(name = "save_name", nullable = false)
    private String saveName; // 서버에 저장된 유니크한 파일명 (예: uuid_내지갑.jpg)

    @Column(name = "file_path", nullable = false)
    private String filePath; // 저장 경로
}
package com.findit.project.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "posts")
@Getter
@Setter
public class Post {

    // 1. PK (Primary Key)
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "post_id")
    private Long postId;

    // 2. FK (Foreign Key) - User와의 관계 설정
    // 게시글은 반드시 1명의 User에 의해 작성됩니다. (Many Post to One User)
    @ManyToOne(fetch = FetchType.LAZY) // 지연 로딩 설정 (Post 정보만 필요할 때 User 정보는 로드하지 않음)
    @JoinColumn(name = "user_id", nullable = false) // posts 테이블의 user_id 컬럼에 FK를 설정
    private User user; 

    // 3. 주요 컬럼
    @Column(nullable = false, length = 100)
    private String title;

    @Column(columnDefinition = "TEXT") // 내용을 길게 저장할 수 있도록 TEXT 타입 지정
    private String content;

    @Column(nullable = false, length = 10)
    private String type; // LOST, FOUND

    @Column(nullable = false, length = 30)
    private String category; // 지갑, 전자기기 등

    @Column(name = "building", nullable = false, length = 50)
    private String building; // 건물명 (예: 제1공학관)

    @Column(name = "place_detail", length = 100)
    private String placeDetail; // 상세 위치 (예: 301호 책상)

    @Column(nullable = false, length = 20)
    private String status; // PROCEEDING, COMPLETE

    @Column(name = "lost_date")
    private LocalDateTime lostDate; // 분실/습득 일시

    // 4. 시간 자동 기록
    @CreationTimestamp // INSERT 시 자동으로 현재 시간을 기록
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
    
    @OneToMany(mappedBy = "post", fetch = FetchType.LAZY)
    private List<PostImage> images = new ArrayList<>();
}
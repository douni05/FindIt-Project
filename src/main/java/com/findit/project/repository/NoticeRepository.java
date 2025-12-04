package com.findit.project.repository;

import com.findit.project.domain.Notice;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface NoticeRepository extends JpaRepository<Notice, Long> {
    // 최신 공지사항 순으로 정렬해서 가져오기
    List<Notice> findAllByOrderByCreatedAtDesc();
}
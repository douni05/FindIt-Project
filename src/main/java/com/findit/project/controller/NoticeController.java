package com.findit.project.controller;

import com.findit.project.domain.Notice;
import com.findit.project.repository.NoticeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import java.util.List;

@Controller
@RequestMapping("/notices")
@RequiredArgsConstructor
public class NoticeController {

    private final NoticeRepository noticeRepository;

    // 공지사항 목록 페이지 표시
    @GetMapping("/list")
    public String list(Model model) {
        List<Notice> notices = noticeRepository.findAllByOrderByCreatedAtDesc();
        model.addAttribute("notices", notices);
        return "notices/list";
    }    
    
    
}
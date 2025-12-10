package com.findit.project;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import com.findit.project.domain.User;
import com.findit.project.domain.Notice;
import com.findit.project.domain.Post;
import com.findit.project.repository.UserRepository;
import com.findit.project.repository.NoticeRepository;
import com.findit.project.repository.PostRepository;
import java.time.LocalDateTime;
import java.time.Month;

@SpringBootApplication
public class FindItJspProjectApplication {

	public static void main(String[] args) {
		SpringApplication.run(FindItJspProjectApplication.class, args);
	}
	
	@Bean
	public CommandLineRunner initAdmin(UserRepository userRepository, PostRepository postRepository, NoticeRepository noticeRepository) {
		return args -> {
			// 1. 관리자 계정 생성
			User admin = null;
			if (userRepository.findByLoginId("admin").isEmpty()) {
				admin = new User();
				admin.setLoginId("admin");
				admin.setPassword("1234");
				admin.setName("관리자");
				admin.setPhone("010-0000-0000");
				admin.setRole("ADMIN"); //권한을 ADMIN으로 설정
				userRepository.save(admin);
				System.out.println("✅ 관리자 계정 생성 완료 (ID: admin / PW: 1234)");
			} else {
				// 이미 존재하면 가져오기 (Post 생성 시 User 객체 필요)
				admin = userRepository.findByLoginId("admin").get();
			}
			
			// 2. 테스트 일반 사용자 계정 생성 (홍길동)
			User testUser = null;
			if (userRepository.findByLoginId("test").isEmpty()) {
				testUser = new User();
				testUser.setLoginId("test");
				testUser.setPassword("1234");
				testUser.setName("홍길동");
				testUser.setPhone("010-1111-1111");
				testUser.setRole("USER"); 
				userRepository.save(testUser);
				System.out.println("✅ 테스트 사용자 계정 생성 완료 (ID: test / PW: 1234)");
			} else {
				testUser = userRepository.findByLoginId("test").get();
			}
			
			// 3. 테스트 게시글 생성 (홍길동 사용자가 작성)
			if (postRepository.count() < 3) {
				// 3-1. 장기 미수령 분실물 (Long-term, PROCEEDING, LostDate: 3개월 이전)
				Post longTermLost = new Post();
				longTermLost.setUser(testUser);
				longTermLost.setTitle("지갑찾아주세요.");
				longTermLost.setContent("작년 9월 초에 잃어버린 지갑입니다. 본관에서 분실했습니다. 검은색 가죽입니다.");
				longTermLost.setType("LOST");
				longTermLost.setCategory("지갑/카드");
				longTermLost.setBuilding("제1공학관");
				longTermLost.setPlaceDetail("101호 강의실");
				longTermLost.setStatus("PROCEEDING");
				longTermLost.setLostDate(LocalDateTime.of(2025, Month.SEPTEMBER, 1, 10, 0)); 
				postRepository.save(longTermLost);

				// 3-2. 해결 완료된 습득물 (COMPLETE, Found)
				Post foundComplete = new Post();
				foundComplete.setUser(testUser);
				foundComplete.setTitle("에어팟 프로");
				foundComplete.setContent("도서관에서 주운 에어팟 프로입니다. 주인을 찾습니다.");
				foundComplete.setType("FOUND");
				foundComplete.setCategory("전자기기");
				foundComplete.setBuilding("도서관");
				foundComplete.setPlaceDetail("열람실 책상");
				foundComplete.setStatus("COMPLETE");
				foundComplete.setLostDate(LocalDateTime.now().minusDays(10));
				postRepository.save(foundComplete);

				// 3-3. 일반 진행중 분실물 (PROCEEDING, Lost)
				Post recentLost = new Post();
				recentLost.setUser(testUser);
				recentLost.setTitle("잃어버린 전공책 찾아요.");
				recentLost.setContent("학생회관 휴게실에서 전공 서적을 잃어버렸습니다.");
				recentLost.setType("LOST");
				recentLost.setCategory("도서");
				recentLost.setBuilding("학생회관");
				recentLost.setPlaceDetail("2층 휴게실");
				recentLost.setStatus("PROCEEDING");
				recentLost.setLostDate(LocalDateTime.now().minusDays(1));
				postRepository.save(recentLost);
				
			}
			
			// 4. 테스트 공지사항 생성
            if (noticeRepository.count() < 2) {
                Notice notice1 = new Notice();
                notice1.setTitle("서비스 점검 안내 (12/15 00시)");
                notice1.setContent("보다 안정적인 서비스 제공을 위해 새벽 시간 점검이 예정되어 있습니다.");
                noticeRepository.save(notice1);

                Notice notice2 = new Notice();
                notice2.setTitle("2026년 1학기 분실물 보관 정책 변경");
                notice2.setContent("보관 기간이 3개월에서 4개월로 연장됩니다.");
                noticeRepository.save(notice2);
                
            }
		};
	}

}
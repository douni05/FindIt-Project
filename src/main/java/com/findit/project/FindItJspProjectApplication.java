package com.findit.project;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import com.findit.project.domain.User;
import com.findit.project.repository.UserRepository;

@SpringBootApplication
public class FindItJspProjectApplication {

	public static void main(String[] args) {
		SpringApplication.run(FindItJspProjectApplication.class, args);
	}
	
	@Bean
	public CommandLineRunner initAdmin(UserRepository userRepository) {
		return args -> {
			if (userRepository.findByLoginId("admin").isEmpty()) {
				User admin = new User();
				admin.setLoginId("admin");
				admin.setPassword("1234");
				admin.setName("관리자");
				admin.setPhone("010-0000-0000");
				admin.setRole("ADMIN"); //권한을 ADMIN으로 설정
				userRepository.save(admin);
				System.out.println("✅ 관리자 계정 생성 완료 (ID: admin / PW: 1234");
			}
		};
	}

}

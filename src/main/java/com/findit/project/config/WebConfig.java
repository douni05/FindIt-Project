package com.findit.project.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    // 사진을 저장할 실제 폴더 경로 (C드라이브 밑에 findit-images 폴더를 미리 만들어주세요!)
    private String resourcePath = "file:///C:/findit-images/";

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 브라우저에서 /images/로 시작하는 주소로 접속하면 -> 실제 컴퓨터 폴더로 연결
        registry.addResourceHandler("/images/**")
                .addResourceLocations(resourcePath);
    }
}
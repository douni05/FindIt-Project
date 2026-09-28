FindIT! — 교내 · 사내 분실물 통합 관리 웹 플랫폼
> 커뮤니티와 단톡방에 흩어져 금방 묻히는 분실물 정보를 한 곳에 모으고,
> 습득물의 보관 상태를 실시간으로 확인할 수 있는 웹 서비스입니다.
기간: 2025.11.20 ~ 2025.12.11 (JSP 교과목 기말 프로젝트)
인원: 1명 — 기획 · DB 설계 · 백엔드 · 화면 개발 전담 (김도윤)
주요 기능
사용자
회원가입 · 로그인 · 로그아웃, 마이페이지(정보 수정 · 비밀번호 변경 · 내가 쓴 글)
분실(LOST) · 습득(FOUND) 게시글 등록, 다중 이미지 업로드
탭 · 카테고리 필터와 키워드 검색, 진행중 ↔ 해결 완료 상태 표시
작성자와 게시글 주인만 볼 수 있는 비밀 댓글로 연락처 등 개인정보 보호
작성자에게만 수정 · 삭제 · 완료 변경 버튼 노출
관리자
대시보드: 총 회원 수 · 해결 완료 건수 · 장기 미수령 물품 통계
공지사항 등록 · 수정 · 삭제, 부적절한 게시글 삭제 · 회원 추방
기술 스택
구분	내용
Language	Java 21
Backend	Spring Boot 3.5.7, Spring Data JPA, Lombok
View	JSP, JSTL, Bootstrap 5.3
Database	H2 (in-memory)
Build / IDE	Gradle, Spring Tool Suite 4
프로젝트 구조
```
src/main/java/com/findit/project
├── controller   # Home, User, Post, Notice, Admin
├── domain       # User, Post, PostImage, Comment, Notice (JPA Entity)
├── repository   # Spring Data JPA Repository
├── service      # User, Post, Comment 비즈니스 로직
└── config       # WebConfig (업로드 이미지 경로 매핑)

src/main/webapp/WEB-INF/views
├── home.jsp
├── users/       # joinForm, loginForm, myPage
├── posts/       # list, detail, writeForm
├── notices/     # list
└── admin/       # dashboard
```
주요 URL
URL	설명
`/`	메인 (통합 검색, 최근 분실물, 공지사항)
`/posts/list`	분실물 게시판
`/posts/detail/{id}`	게시글 상세 · 비밀 댓글
`/users/myPage`	마이페이지
`/notices/list`	공지사항
`/admin`	관리자 대시보드
실행 방법
```bash
./gradlew bootRun      # Windows: gradlew.bat bootRun
```
접속: http://localhost:8080
H2 인메모리 DB를 사용하므로 서버를 재시작하면 데이터가 초기화되고, 실행 시 테스트용 관리자 계정과 샘플 게시글이 자동 생성됩니다.

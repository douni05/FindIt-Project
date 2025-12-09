<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>파인드잇 - FindIT</title>
    <link rel="icon" type="image/png" href="/images/FindIt_logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f8f9fa; }
        
        .navbar { background-color: white; box-shadow: 0 2px 10px rgba(0,0,0,0.05); padding: 10px 0 !important; }
        .navbar-brand { padding: 0 !important; }
        .navbar-logo { height: 30px; margin-right: 8px; }
        .nav-btn { border-radius: 20px; font-weight: 500; padding: 8px 20px; }

        .hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 100px 0 60px;
            border-radius: 0 0 40px 40px;
            margin-bottom: 50px;
        }
        .search-bar {
            background: white;
            padding: 10px;
            border-radius: 50px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .search-input { border: none; padding-left: 20px; font-size: 1.1rem; }
        .search-input:focus { outline: none; box-shadow: none; }
        .card-custom {
            border: none;
            border-radius: 15px;
            transition: transform 0.3s, box-shadow 0.3s;
            overflow: hidden;
        }
        .card-custom:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); }
        .badge-lost { background-color: #ff6b6b; }
        .badge-found { background-color: #1dd1a1; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg fixed-top">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="/">
                <img src="/images/FindIt_logo.png" alt="FindIt Logo" class="navbar-logo">
                <span class="fw-bold text-primary">FindIT</span>
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center gap-2">
                    <c:if test="${empty user}">
                        <li class="nav-item">
                            <a href="/users/loginForm" class="btn btn-outline-primary nav-btn">로그인</a>
                        </li>
                        <li class="nav-item">
                            <a href="/users/insertForm" class="btn btn-primary nav-btn text-white">회원가입</a>
                        </li>
                    </c:if>

                    <c:if test="${not empty user}">
                        <li class="nav-item me-3 text-muted">
                            반갑습니다, <strong>${user.name}</strong>님!
                        </li>
                        <c:if test="${user.role == 'ADMIN'}">
                            <li class="nav-item">
                                <a href="/admin" class="btn btn-danger nav-btn btn-sm">👑 관리자</a>
                            </li>
                        </c:if>
                        <li class="nav-item">
                            <a href="/users/myPage" class="btn btn-light nav-btn border">👤 마이페이지</a>
                        </li>
                        <li class="nav-item">
                            <a href="/users/logout" class="btn btn-outline-danger nav-btn">로그아웃</a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>
    </nav>

    <div class="hero text-center mt-5"> <div class="container pt-4">
            <h1 class="display-5 fw-bold mb-3 d-flex align-items-center justify-content-center">
                <img src="/images/FindIt_logo.png" alt="Logo" style="height: 60px; margin-right: 15px;">
                교내 분실물 센터 FindIT
            </h1>
            <p class="fs-5 mb-5 opacity-75">잃어버린 물건, 이제 헤매지 말고 학교 안에서 찾으세요.</p>
            
            <div class="row justify-content-center mb-5">
                <div class="col-md-8 col-lg-6">
                    <form action="/posts/list" method="get">
                        <div class="d-flex search-bar">
                            <input type="text" name="keyword" class="form-control search-input" placeholder="물품명, 장소, 날짜를 검색해보세요.">
                            <button type="submit" class="btn btn-warning rounded-circle" style="width: 50px; height: 50px;">🔍</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="d-flex justify-content-center">
                <a href="/posts/list" class="btn btn-light btn-lg px-5 fw-bold shadow text-primary rounded-pill">
                    🔍 분실물 게시판 바로가기
                </a>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="fw-bold">📦 최근 등록된 분실물</h4>
            <a href="/posts/list" class="text-decoration-none fw-bold">더보기 ></a>
        </div>
        
        <div class="row g-4">
            <c:choose>
                <c:when test="${not empty recentPosts}">
                    <c:forEach var="post" items="${recentPosts}">
                        <div class="col-md-3">
                            <div class="card card-custom h-100">
                                
                                <div style="height: 200px; overflow: hidden; background-color: #f8f9fa; display: flex; align-items: center; justify-content: center;">
                                    <c:choose>
                                        <c:when test="${not empty post.images}">
                                            <img src="/images/${post.images[0].saveName}" alt="물품 사진" style="width: 100%; height: 100%; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <span class="fs-1 text-muted">📸</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="card-body">
                                    <span class="badge ${post.type == 'LOST' ? 'badge-lost' : 'badge-found'} mb-2">
                                        ${post.type == 'LOST' ? '분실' : '습득'}
                                    </span>
                                    <h5 class="card-title text-truncate">${post.title}</h5>
                                    <p class="card-text small text-muted">📍 ${post.building}</p>
                                </div>
                                <div class="card-footer bg-white border-0 pb-3">
                                    <a href="/posts/detail/${post.postId}" class="btn btn-sm btn-outline-primary w-100">상세보기</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12 text-center py-5 text-muted bg-white rounded-3 shadow-sm">
                        <p class="mb-0">아직 최근 게시물이 없습니다.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="container pb-5">
        <div class="row g-4">
            <div class="col-md-6">
                <div class="p-4 bg-white rounded-4 shadow-sm h-100">
                    <h5 class="fw-bold mb-3">📢 공지사항</h5>
                    <ul class="list-unstyled text-muted small">
                        <li class="mb-2">• 습득물 보관 기간은 최대 3개월입니다.</li>
                        <li class="mb-2">• 고가의 물품은 학생지원팀에 직접 방문하여 수령하세요.</li>
                        <li>• 허위 신고 시 이용이 제한될 수 있습니다.</li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="p-4 bg-white rounded-4 shadow-sm h-100">
                    <h5 class="fw-bold mb-3">💡 분실물 처리 절차</h5>
                    <div class="d-flex justify-content-between text-center small text-muted">
                        <div>
                            <div class="fs-2 mb-1">📝</div>
                            <div>신고 접수</div>
                        </div>
                        <div class="align-self-center">➝</div>
                        <div>
                            <div class="fs-2 mb-1">📦</div>
                            <div>보관/게시</div>
                        </div>
                        <div class="align-self-center">➝</div>
                        <div>
                            <div class="fs-2 mb-1">🔍</div>
                            <div>본인 확인</div>
                        </div>
                        <div class="align-self-center">➝</div>
                        <div>
                            <div class="fs-2 mb-1">🤝</div>
                            <div>수령 완료</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
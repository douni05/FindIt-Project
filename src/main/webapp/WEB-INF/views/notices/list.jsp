<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 - FindIT</title>
    <link rel="icon" type="image/png" href="/images/FindIt_logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { 
            background-color: #f8f9fa; 
            font-family: 'Noto Sans KR', sans-serif; 
            padding-top: 70px; 
        }
        .navbar { background-color: white; box-shadow: 0 2px 10px rgba(0,0,0,0.05); padding: 10px 0 !important; }
        .navbar-brand { padding: 0 !important; }
        .navbar-logo { height: 30px; margin-right: 8px; }
        .nav-btn { border-radius: 20px; font-weight: 500; padding: 8px 20px; }
        .list-container { 
            max-width: 900px; 
            margin: 30px auto; 
            background: white; 
            padding: 40px; 
            border-radius: 20px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.05); 
        }
        .list-group-item { 
            border: none;
            border-bottom: 1px solid #f1f1f1; 
            padding: 15px 20px; 
            transition: background 0.2s;
        }
        .list-group-item:hover {
            background-color: #f8f9fa;
        }
        .list-group-item:last-child { 
            border-bottom: none; 
        }
        .notice-title { 
            font-weight: bold; 
            color: #343a40; 
        }
        .notice-date { 
            font-size: 0.85rem; 
            color: #6c757d; 
        }
        .notice-content { 
            font-size: 0.95rem; 
            color: #495057; 
            margin-top: 5px; 
            white-space: pre-wrap; 
        }
    </style>
</head>
<body>
    
    <nav class="navbar navbar-expand-lg fixed-top">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="/">
                <img src="/images/FindIt_logo.png" alt="FindIt Logo" class="navbar-logo">
                <span class="fw-bold text-primary">FindIT</span>
            </a>
            
            <div class="d-flex gap-2">
                <c:if test="${empty loginUser}">
                    <a href="/users/loginForm" class="btn btn-outline-primary nav-btn">로그인</a>
                    <a href="/users/insertForm" class="btn btn-primary nav-btn text-white">회원가입</a>
                </c:if>

                <c:if test="${not empty loginUser}">
                    <c:if test="${loginUser.role == 'ADMIN'}">
                        <a href="/admin" class="btn btn-danger nav-btn btn-sm">👑 관리자</a>
                    </c:if>
                    <a href="/users/myPage" class="btn btn-light nav-btn border">👤 마이페이지</a>
                    <a href="/users/logout" class="btn btn-outline-danger nav-btn">로그아웃</a>
                </c:if>
            </div>
        </div>
    </nav>
    
    <div class="container">
        <div class="list-container">
            <h2 class="fw-bold mb-4 text-center">📢 공지사항</h2>
            
            <div class="list-group list-group-flush border rounded-3">
                <c:choose>
                    <c:when test="${not empty notices}">
                        <c:forEach var="notice" items="${notices}">
                            <div class="list-group-item">
                                <div class="d-flex w-100 justify-content-between align-items-center">
                                    <h5 class="notice-title">${notice.title}</h5>
                                    <small class="notice-date">${notice.createdAt.toString().substring(0, 10)}</small>
                                </div>
                                <p class="notice-content">${notice.content}</p>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="list-group-item text-center py-5 text-muted">
                            등록된 공지사항이 없습니다.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>           
            
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
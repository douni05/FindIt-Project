<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 대시보드 - FindIT</title>
    <link rel="icon" type="image/png" href="/images/FindIt_logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Noto Sans KR', sans-serif; }
        
        .navbar { background-color: white; box-shadow: 0 2px 10px rgba(0,0,0,0.05); padding: 10px 0 !important; }
        .navbar-brand { padding: 0 !important; }
        .navbar-logo { height: 30px; margin-right: 8px; }
        .nav-btn { border-radius: 20px; font-weight: 500; padding: 8px 20px; }  
        .stat-card { border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); transition: 0.3s; background: white; }
        .stat-card:hover { transform: translateY(-5px); }
        
        .nav-tabs .nav-link { border: none; color: #6c757d; font-weight: 600; padding: 12px 20px; }
        .nav-tabs .nav-link.active { color: #0d6efd; border-bottom: 3px solid #0d6efd; background: transparent; }
        
        .table-custom th { background-color: #f1f3f5; font-weight: 600; }
        .table-custom td { vertical-align: middle; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm mb-5">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="/">
                <img src="/images/FindIt_logo.png" alt="FindIt_Logo" class="navbar-logo">
                <span class="fw-bold text-primary">FindIT</span>
                <span class="badge bg-danger ms-2 rounded-pill">Admin</span>
            </a>
            
            <div class="d-flex gap-2">
                <a href="/" class="btn btn-outline-secondary nav-btn">🏠 서비스 홈</a>
                <a href="/users/logout" class="btn btn-outline-danger nav-btn">로그아웃</a>
            </div>
        </div>
    </nav>

    <div class="container">
        
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="card stat-card h-100 border-start border-4 border-primary">
                    <div class="card-body p-4">
                        <div class="text-muted fw-bold small text-uppercase mb-2">총 회원 수</div>
                        <div class="d-flex justify-content-between align-items-center">
                            <h2 class="fw-bold mb-0 text-dark">${userCount}명</h2>
                            <span class="fs-1 text-primary opacity-25">👥</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card stat-card h-100 border-start border-4 border-success">
                    <div class="card-body p-4">
                        <div class="text-muted fw-bold small text-uppercase mb-2">해결 완료된 건</div>
                        <div class="d-flex justify-content-between align-items-center">
                            <h2 class="fw-bold mb-0 text-success">${solvedCount}건</h2>
                            <span class="fs-1 text-success opacity-25">🎉</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card stat-card h-100 border-start border-4 border-warning">
                    <div class="card-body p-4">
                        <div class="text-muted fw-bold small text-uppercase mb-2">장기 미수령 분실물</div>
                        <div class="d-flex justify-content-between align-items-center">
                            <h2 class="fw-bold mb-0 text-warning">${longTermItems.size()}건</h2>
                            <span class="fs-1 text-warning opacity-25">⚠️</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm rounded-4 bg-white">
            <div class="card-header bg-white border-bottom-0 pt-4 px-4">
                <ul class="nav nav-tabs card-header-tabs" id="adminTab" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#notice">📢 공지사항 관리</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#posts">📝 게시물 관리</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#users">👥 회원 관리</button>
                    </li>
                </ul>
            </div>

            <div class="card-body p-4">
                <div class="tab-content">
                    
                    <div class="tab-pane fade show active" id="notice">
                        <div class="row">
                            <div class="col-md-4 border-end">
                                <h5 class="fw-bold mb-3">새 공지 등록</h5>
                                <form action="/admin/notice/write" method="post">
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold">제목</label>
                                        <input type="text" name="title" class="form-control" placeholder="공지 제목" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold">내용</label>
                                        <textarea name="content" class="form-control" rows="5" placeholder="공지 내용" required></textarea>
                                    </div>
                                    <button class="btn btn-dark w-100">등록하기</button>
                                </form>
                            </div>
                            <div class="col-md-8 ps-md-4">
                                <h5 class="fw-bold mb-3">등록된 공지 목록</h5>
                                <div class="list-group">
                                    <c:forEach var="n" items="${notices}">
                                        <div class="list-group-item list-group-item-action">
                                            <div class="d-flex w-100 justify-content-between">
                                                <h6 class="mb-1 fw-bold text-primary">[공지] ${n.title}</h6>
                                                <small class="text-muted">${n.createdAt.toString().substring(0,10)}</small>
                                            </div>
                                            <p class="mb-1 small text-muted text-truncate">${n.content}</p>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="posts">
                        <div class="table-responsive">
                            <table class="table table-hover table-custom text-center">
                                <thead class="table-light">
                                    <tr><th>ID</th><th>상태</th><th>제목</th><th>작성자</th><th>작성일</th><th>관리</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${posts}">
                                        <tr>
                                            <td>${p.postId}</td>
                                            <td><span class="badge ${p.status=='PROCEEDING'?'bg-primary':'bg-secondary'}">${p.status}</span></td>
                                            <td class="text-start"><a href="/posts/detail/${p.postId}" target="_blank" class="text-decoration-none text-dark fw-bold">${p.title}</a></td>
                                            <td>${p.user.name}</td>
                                            <td>${p.createdAt.toString().substring(0,10)}</td>
                                            <td>
                                                <a href="/admin/post/delete/${p.postId}" class="btn btn-outline-danger btn-sm" onclick="return confirm('정말 삭제합니까? 복구할 수 없습니다.')">삭제</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="users">
                        <div class="table-responsive">
                            <table class="table table-hover table-custom text-center">
                                <thead class="table-light">
                                    <tr><th>ID</th><th>이름</th><th>아이디</th><th>권한</th><th>가입일</th><th>관리</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="u" items="${users}">
                                        <tr>
                                            <td>${u.id}</td>
                                            <td>${u.name}</td>
                                            <td>${u.loginId}</td>
                                            <td>
                                                <span class="badge ${u.role == 'ADMIN' ? 'bg-danger' : 'bg-success'} rounded-pill">${u.role}</span>
                                            </td>
                                            <td>-</td> 
                                            <td>
                                                <c:if test="${u.role != 'ADMIN'}">
                                                    <a href="/admin/user/delete/${u.id}" class="btn btn-dark btn-sm px-3" onclick="return confirm('회원을 강제 탈퇴시킵니까?')">추방</a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
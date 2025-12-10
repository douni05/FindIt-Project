<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지 - FindIT</title>
    <link rel="icon" type="image/png" href="/images/FindIt_logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Noto Sans KR', sans-serif; }
        .navbar { background-color: white; box-shadow: 0 2px 10px rgba(0,0,0,0.05); padding: 10px 0 !important; }
        .navbar-brand { padding: 0 !important; }
        .navbar-logo { height: 30px; margin-right: 8px; }
        .nav-btn { border-radius: 20px; font-weight: 500; padding: 8px 20px; }     
        .mypage-header { margin-bottom: 30px; }
        .card-custom { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); overflow: hidden; }
        .card-header-custom { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-bottom: none; }
        .profile-icon { font-size: 4rem; color: #667eea; background: #eef2ff; width: 100px; height: 100px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; }
        .list-group-item { border: none; border-bottom: 1px solid #f1f1f1; padding: 15px 20px; transition: background 0.2s; }
        .list-group-item:hover { background-color: #fafafa; }
        .status-badge { font-size: 0.75rem; padding: 5px 10px; border-radius: 20px; }
        .btn-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none; color: white; transition: opacity 0.3s;
        }
        .btn-gradient:hover { opacity: 0.9; color: white; }
    </style>
</head>
<body>
    
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm mb-5">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="/">
                <img src="/images/FindIt_logo.png" alt="FindIt_Logo" class="navbar-logo">
                <span class="fw-bold text-primary">FindIT</span>
            </a>
            
            <div class="d-flex gap-2">
                <a href="/" class="btn btn-outline-secondary nav-btn">🏠 홈으로</a>
                <a href="/users/logout" class="btn btn-outline-danger nav-btn">로그아웃</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row g-4">
            
            <div class="col-lg-4">
                <div class="card card-custom h-100">
                    <div class="card-body text-center p-4">
                        <div class="profile-icon">👤</div>
                        <h4 class="fw-bold mb-1">${user.name}</h4>
                        <p class="text-muted small mb-4">${user.loginId}</p>
                        
                        <form action="/users/update" method="post" class="text-start">
                            <div class="mb-3">
                                <label class="form-label text-muted small fw-bold">아이디</label>
                                <input type="text" class="form-control bg-light" value="${user.loginId}" disabled>
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-muted small fw-bold">이름</label>
                                <input type="text" name="name" class="form-control" value="${user.name}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-muted small fw-bold">전화번호</label>
                                <input type="text" name="phone" class="form-control" value="${user.phone}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-muted small fw-bold">비밀번호</label>
                                <button type="button" class="btn btn-outline-secondary w-100" data-bs-toggle="modal" data-bs-target="#passwordModal">
                                    🔒 비밀번호 변경하기
                                </button>
                            </div>
                            <button type="submit" class="btn btn-gradient w-100 fw-bold py-2">정보 수정하기</button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                <div class="card card-custom h-100">
                    <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                        <h5 class="mb-0 fw-bold">📝 내가 쓴 글</h5>
                        <span class="badge bg-white text-primary rounded-pill">${myPosts.size()}건</span>
                    </div>
                    <div class="card-body p-0">
                        <div class="list-group list-group-flush">
                            <c:choose>
                                <c:when test="${empty myPosts}">
                                    <div class="text-center py-5 text-muted">
                                        <p class="mb-0">작성한 게시글이 없습니다.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="p" items="${myPosts}">
                                        <div class="list-group-item d-flex justify-content-between align-items-center">
                                            <div class="d-flex align-items-center gap-3 overflow-hidden">
                                                <span class="badge ${p.type == 'LOST' ? 'bg-danger' : 'bg-success'} rounded-pill">
                                                    ${p.type == 'LOST' ? '분실' : '습득'}
                                                </span>
                                                <a href="/posts/detail/${p.postId}" class="text-decoration-none text-dark fw-bold text-truncate" style="max-width: 300px;">
                                                    ${p.title}
                                                </a>
                                            </div>
                                            <div class="d-flex align-items-center gap-2">
                                                <small class="text-muted d-none d-md-block">${p.lostDate.toString().substring(0, 10)}</small>
                                                <span class="badge ${p.status == 'PROCEEDING' ? 'bg-light text-primary' : 'bg-secondary'} border status-badge">
                                                    ${p.status == 'PROCEEDING' ? '보관중' : '완료'}
                                                </span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

	<div class="modal fade" id="passwordModal" tabindex="-1" aria-labelledby="passwordModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-bottom-0">
                    <h5 class="modal-title fw-bold" id="passwordModalLabel">비밀번호 변경</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                
                <form action="/users/updatePassword" method="post" onsubmit="return validatePassword()">
                    <div class="modal-body px-4 pb-4">
                        <p class="text-muted small mb-4">현재 비밀번호와 새 비밀번호를 입력하세요.</p>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold small">현재 비밀번호 <span class="text-danger">*</span></label>
                            <input type="password" name="currentPassword" class="form-control" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold small">새 비밀번호 <span class="text-danger">*</span></label>
                            <input type="password" name="newPassword" id="newPassword" class="form-control" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold small">새 비밀번호 확인 <span class="text-danger">*</span></label>
                            <input type="password" id="confirmPassword" class="form-control" required>
                            <div id="pwError" class="text-danger small mt-1" style="display:none;">비밀번호가 일치하지 않습니다.</div>
                        </div>
                    </div>
                    
                    <div class="modal-footer border-top-0 px-4 pb-4">
                        <button type="button" class="btn btn-light flex-grow-1" data-bs-dismiss="modal">취소</button>
                        <button type="submit" class="btn btn-primary flex-grow-1">완료</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // 1. 서버에서 보낸 성공/실패 메시지 띄우기
        var msg = "${message}";
        var errMsg = "${errorMessage}";
        
        if(msg && msg.trim() !== "") alert(msg);
        if(errMsg && errMsg.trim() !== "") alert(errMsg);

        // 2. 새 비밀번호 일치 확인 (자바스크립트 검증)
        function validatePassword() {
            var newPw = document.getElementById("newPassword").value;
            var confirmPw = document.getElementById("confirmPassword").value;
            var errorDiv = document.getElementById("pwError");

            if (newPw !== confirmPw) {
                errorDiv.style.display = "block"; // 에러 메시지 보임
                return false; // 전송 막기
            }
            errorDiv.style.display = "none";
            return true; // 전송 허용
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
</html>
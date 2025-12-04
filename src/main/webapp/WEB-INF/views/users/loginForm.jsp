<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>로그인 - FindIt</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Noto Sans KR', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .login-card {
            width: 100%;
            max-width: 400px;
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            padding: 40px;
            background: white;
        }
        .form-control {
            border-radius: 10px;
            padding: 12px;
            background-color: #f8f9fa;
            border: 1px solid #eee;
        }
        .form-control:focus {
            background-color: white;
            box-shadow: 0 0 0 3px rgba(13,110,253,0.1);
            border-color: #0d6efd;
        }
        .btn-login {
            border-radius: 10px;
            padding: 12px;
            font-weight: bold;
            font-size: 1.1rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        .btn-login:hover {
            opacity: 0.9;
        }
        .logo { font-size: 3rem; margin-bottom: 20px; }
    </style>
</head>
<body>

    <div class="login-card text-center">
        <div class="logo">🎒</div>
        <h3 class="fw-bold mb-4">로그인</h3>
        
        <form action="/users/login" method="post">
            <div class="mb-3 text-start">
                <label class="form-label text-muted small fw-bold">아이디</label>
                <input type="text" name="loginId" class="form-control" placeholder="아이디를 입력하세요" required>
            </div>
            <div class="mb-4 text-start">
                <label class="form-label text-muted small fw-bold">비밀번호</label>
                <input type="password" name="password" class="form-control" placeholder="비밀번호를 입력하세요" required>
            </div>
            
            <div class="d-grid gap-2 mb-4">
                <button type="submit" class="btn btn-primary btn-login">로그인</button>
            </div>
        </form>

        <div class="d-flex justify-content-between align-items-center">
            <a href="/" class="text-decoration-none text-muted small">← 홈으로</a>
            <span class="text-muted small">
                계정이 없으신가요? <a href="/users/insertForm" class="text-primary fw-bold text-decoration-none">회원가입</a>
            </span>
        </div>
    </div>
	
	<script>
        var errorMessage = "${errorMessage}";
        if (errorMessage && errorMessage.trim() !== "") {
            alert(errorMessage);
        }
    </script>
</body>
</html>
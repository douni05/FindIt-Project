<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>회원가입 - FindIT</title>
    <link rel="icon" type="image/png" href="/images/FindIt_logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Noto Sans KR', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .join-card {
            width: 100%;
            max-width: 500px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            padding: 40px;
            background: white;
        }
        .form-label { font-weight: 600; color: #495057; }
        .form-control {
            padding: 12px;
            border-radius: 10px;
            background-color: #f8f9fa;
            border: 1px solid #eee;
        }
        .form-control:focus {
       		background-color: white;
            box-shadow: 0 0 0 3px rgba(13,110,253,0.1);
            border-color: #0d6efd;
        }
        .btn-join {
            padding: 12px;
            border-radius: 10px;
            font-weight: bold;
            font-size: 1.1rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
        }
        .btn-join:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>

    <div class="join-card">
        <div class="text-center mb-4">
            <span class="fs-1">📝</span>
            <h3 class="fw-bold mt-2">회원가입</h3>
            <p class="text-muted small">FindIT 서비스 이용을 위해 정보를 입력해주세요.</p>
        </div>

        <form action="/users/insert" method="post">
            <div class="mb-3">
                <label class="form-label">아이디</label>
                <input type="text" name="loginId" class="form-control" placeholder="사용할 아이디를 입력하세요" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">비밀번호</label>
                <input type="password" name="password" class="form-control" placeholder="비밀번호를 입혁하세요. (4자리 이상)" required>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">이름</label>
                    <input type="text" name="name" class="form-control" placeholder="홍길동" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">전화번호</label>
                    <input type="text" name="phone" class="form-control" placeholder="010-0000-0000">
                </div>
            </div>

            <div class="d-grid gap-2 mt-4">
                <button type="submit" class="btn btn-primary btn-join">가입하기</button>
                <a href="/" class="btn btn-light btn-lg text-secondary">취소</a> 
            </div>
        </form>
        
        <div class="text-center mt-4">
            <span class="text-muted small">이미 계정이 있으신가요?</span>
            <a href="/users/loginForm" class="text-decoration-none fw-bold ms-1">로그인하기</a>
        </div>
    </div>

</body>
<script>
        var errorMessage = "${errorMessage}";
        if (errorMessage && errorMessage.trim() !== "") {
            alert(errorMessage);
        }
</script>
</html>
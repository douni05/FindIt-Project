<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>글쓰기 - FindIt</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .form-container { max-width: 700px; margin: 50px auto; background: white; padding: 40px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .form-label { font-weight: 600; color: #495057; }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-container">
            <h3 class="fw-bold mb-4 text-center">✏️ 게시글 등록</h3>
            
            <form action="/posts/insert" method="post" enctype="multipart/form-data">
                
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">유형</label>
                        <select name="type" class="form-select">
                            <option value="LOST">잃어버렸어요 (분실)</option>
                            <option value="FOUND">주웠어요 (습득)</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">카테고리</label>
                        <select name="category" class="form-select">
                            <option value="전자기기">💻 전자기기</option>
                            <option value="지갑/카드">💳 지갑/카드</option>
                            <option value="의류">👕 의류</option>
                            <option value="도서">📚 도서</option>
                            <option value="기타">🎸 기타</option>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">제목</label>
                    <input type="text" name="title" class="form-control" placeholder="예) 에어팟 프로 본체 찾습니다." required>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">장소 (건물명)</label>
                        <input type="text" name="building" class="form-control" placeholder="예) 제1공학관" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">상세 위치</label>
                        <input type="text" name="placeDetail" class="form-control" placeholder="예) 304호 강의실 책상 위">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">사진 첨부</label>
                    <input type="file" name="imageFiles" class="form-control" multiple accept="image/*">
                    <div class="form-text">📸 물건의 특징이 잘 보이는 사진을 올려주세요.</div>
                </div>

                <div class="mb-4">
                    <label class="form-label">내용</label>
                    <textarea name="content" class="form-control" rows="5" placeholder="물건의 색상, 브랜드, 특징 등을 자세히 적어주세요." required></textarea>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary btn-lg fw-bold">등록하기</button>
                    <a href="/posts/list" class="btn btn-light btn-lg">취소</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
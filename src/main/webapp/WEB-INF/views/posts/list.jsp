<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %> <!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시판 목록 - FindIT</title>
    <link rel="icon" type="image/png" href="/images/FindIt_logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Noto Sans KR', sans-serif; }
        .table-custom th { background-color: #f1f3f5; font-weight: 600; }
        .table-custom td { vertical-align: middle; }
        .status-badge { font-size: 0.8rem; padding: 5px 10px; border-radius: 20px; }
        .status-ongoing { background-color: #e3f2fd; color: #0d6efd; }
        .status-complete { background-color: #e9ecef; color: #495057; }
        .filter-btn-group .btn { border-radius: 20px; margin-right: 8px; }
        .filter-btn-group .active { background-color: #0d6efd; color: white; border-color: #0d6efd; }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold">📋 분실물 게시판</h2>
            <div>
                <a href="/" class="btn btn-outline-secondary me-2">🏠 홈으로</a>
                <a href="/posts/insertForm" class="btn btn-primary">✏️ 글쓰기</a>
            </div>
        </div>
		
		<!-- 1. 검색 및 필터링 폼 -->
        <form action="/posts/list" method="get" class="mb-4 bg-white p-3 rounded shadow-sm">
            <div class="row g-3 align-items-center">
                <div class="col-md-3">
                    <!-- 1-1. 카테고리 필터 -->
                    <select name="category" class="form-select form-select-sm" onchange="this.form.submit()">
                        <option value="ALL" ${currentCategory == 'ALL' ? 'selected' : ''}>전체 카테고리</option>
                        <option value="전자기기" ${currentCategory == '전자기기' ? 'selected' : ''}>💻 전자기기</option>
                        <option value="지갑/카드" ${currentCategory == '지갑/카드' ? 'selected' : ''}>💳 지갑/카드</option>
                        <option value="의류" ${currentCategory == '의류' ? 'selected' : ''}>👕 의류</option>
                        <option value="도서" ${currentCategory == '도서' ? 'selected' : ''}>📚 도서</option>
                        <option value="기타" ${currentCategory == '기타' ? 'selected' : ''}>🎸 기타</option>
                    </select>
                </div>
                
                <div class="col-md-5">
                    <!-- 1-2. 키워드 검색창 -->
                    <input type="text" name="keyword" class="form-control form-control-sm" placeholder="제목, 내용, 장소 검색" value="${currentKeyword}">
                </div>
                
                <div class="col-md-4 text-end">
                    <button type="submit" class="btn btn-dark btn-sm me-2">검색</button>
                    <a href="/posts/list" class="btn btn-light btn-sm border">초기화</a>
                </div>
            </div>
        </form>
        
        <!-- 2. 유형 필터 버튼 그룹 -->
        <div class="d-flex mb-3 filter-btn-group">
            <a href="/posts/list?keyword=${currentKeyword}&category=${currentCategory}&type=ALL" 
               class="btn btn-outline-primary btn-sm ${currentType == 'ALL' ? 'active' : ''}">
                전체 (${currentType == 'ALL' ? posts.size() : ''})
            </a>
            <a href="/posts/list?keyword=${currentKeyword}&category=${currentCategory}&type=FOUND" 
               class="btn btn-outline-primary btn-sm ${currentType == 'FOUND' ? 'active' : ''}">
                주웠어요 (습득)
            </a>
            <a href="/posts/list?keyword=${currentKeyword}&category=${currentCategory}&type=LOST" 
               class="btn btn-outline-primary btn-sm ${currentType == 'LOST' ? 'active' : ''}">
                잃어버렸어요 (분실)
            </a>
        </div>
        
        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <table class="table table-hover table-custom mb-0 text-center">
                    <thead class="border-bottom">
                        <tr>
                            <th width="10%">상태</th>
                            <th width="10%">유형</th>
                            <th width="15%">분류</th>
                            <th width="30%">제목</th>
                            <th width="15%">장소</th>
                            <th width="10%">작성자</th>
                            <th width="10%">작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty posts}">
                            <tr><td colspan="7" class="py-5 text-muted">등록된 게시글이 없습니다.</td></tr>
                        </c:if>

                        <c:forEach var="post" items="${posts}">
                            <tr>
                                <td>
                                    <span class="status-badge ${post.status == 'PROCEEDING' ? 'status-ongoing' : 'status-complete'}">
                                        ${post.status == 'PROCEEDING' ? '진행중' : '완료'}
                                    </span>
                                </td>
                                <td class="fw-bold ${post.type == 'LOST' ? 'text-danger' : 'text-success'}">
                                    ${post.type == 'LOST' ? '분실' : '습득'}
                                </td>
                                <td>${post.category}</td>
                                <td class="text-start ps-4">
                                    <a href="/posts/detail/${post.postId}" class="text-decoration-none text-dark fw-bold">
                                        ${post.title}
                                    </a>
                                </td>
                                <td>${post.building}</td>
                                <td>${post.user.name}</td>
                                <td class="text-muted small">
                                    ${post.createdAt.toString().substring(0, 10)}
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %> <!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시판 목록 - FindIt</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Noto Sans KR', sans-serif; }
        .table-custom th { background-color: #f1f3f5; font-weight: 600; }
        .table-custom td { vertical-align: middle; }
        .status-badge { font-size: 0.8rem; padding: 5px 10px; border-radius: 20px; }
        .status-ongoing { background-color: #e3f2fd; color: #0d6efd; }
        .status-complete { background-color: #e9ecef; color: #495057; }
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
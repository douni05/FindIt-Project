<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상세보기 - FindIT</title>
    <link rel="icon" type="image/png" href="/images/FindIt_logo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .detail-container { max-width: 1000px; margin: 50px auto; background: white; padding: 40px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .info-label { font-weight: bold; color: #888; width: 100px; display: inline-block; }
        .carousel-item img { height: 400px; object-fit: contain; background: #f1f1f1; border-radius: 10px; }
        .comment-box { background-color: #f8f9fa; padding: 20px; border-radius: 15px; margin-top: 30px; }
        .secret-comment { color: #aaa; font-style: italic; }
    </style>
</head>
<body>
    <div class="container">
        <div class="detail-container">
            <div class="mb-4">
                <a href="/posts/list" class="text-decoration-none text-secondary">⬅ 목록으로 돌아가기</a>
            </div>

            <div class="row g-5">
                <div class="col-md-6">
                    <c:choose>
                        <c:when test="${not empty images}">
                            <div id="carouselExample" class="carousel slide" data-bs-ride="carousel">
                                <div class="carousel-inner">
                                    <c:forEach var="img" items="${images}" varStatus="status">
                                        <div class="carousel-item ${status.first ? 'active' : ''}">
                                            <img src="/images/${img.saveName}" class="d-block w-100" alt="물품 이미지">
                                        </div>
                                    </c:forEach>
                                </div>
                                <button class="carousel-control-prev" type="button" data-bs-target="#carouselExample" data-bs-slide="prev">
                                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                </button>
                                <button class="carousel-control-next" type="button" data-bs-target="#carouselExample" data-bs-slide="next">
                                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-flex align-items-center justify-content-center bg-light rounded" style="height: 400px;">
                                <span class="text-muted">이미지가 없습니다.</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="col-md-6">
                
                	<c:if test="${loginUser.id == post.user.id}">
                        <div class="mb-3">
                            <form action="/posts/${post.postId}/status" method="post">
                                <c:if test="${post.status == 'PROCEEDING'}">
                                    <input type="hidden" name="status" value="COMPLETE">
                                    <button type="submit" class="btn btn-success w-100 fw-bold">🤝 완료로 변경하기</button>
                                </c:if>
                                <c:if test="${post.status == 'COMPLETE'}">
                                    <input type="hidden" name="status" value="PROCEEDING">
                                    <button type="submit" class="btn btn-secondary w-100 fw-bold">🔄 다시 진행중으로 변경하기</button>
                                </c:if>
                            </form>
                        </div>
                    </c:if>

                    <span class="badge ${post.type == 'LOST' ? 'bg-danger' : 'bg-success'} mb-2 px-3 py-2">
                        ${post.type == 'LOST' ? '분실' : '습득'}
                    </span>
                    <span class="badge bg-secondary mb-2 px-3 py-2">${post.status == 'PROCEEDING' ? '진행중' : '완료'}</span>
                    
                    <h2 class="fw-bold mb-4">${post.title}</h2>
                    
                    <div class="mb-4">
                        <p><span class="info-label">카테고리</span> ${post.category}</p>
                        <p><span class="info-label">습득 장소</span> ${post.building} ${post.placeDetail}</p>
                        <p><span class="info-label">작성자</span> ${post.user.name}</p>
                        <p><span class="info-label">등록일</span> ${post.lostDate.toString().substring(0, 10)}</p>
                    </div>

                    <div class="p-3 bg-light rounded mb-4">
                        <h6 class="fw-bold">상세 내용</h6>
                        <p class="mb-0 text-muted" style="white-space: pre-wrap;">${post.content}</p>
                    </div>
                </div>
            </div>

            <div class="comment-box">
                <h5 class="fw-bold mb-3">💬 비밀 댓글 <span class="text-primary">${comments.size()}</span></h5>
                
                <div class="list-group list-group-flush mb-3">
                    <c:forEach var="comment" items="${comments}">
                        <div class="list-group-item bg-transparent px-0">
                            <div class="d-flex justify-content-between">
                                <strong>${comment.user.name}</strong>
                                <small class="text-muted">${comment.lostDate.toString().substring(0, 16)}</small>
                            </div>
                            <div class="mt-1">
                                <c:choose>
                                    <c:when test="${loginUser.id == comment.user.id || loginUser.id == post.user.id}">
                                        <span class="text-dark">${comment.content}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="secret-comment">🔒 비밀 댓글입니다. (작성자와 당사자만 볼 수 있습니다)</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <form action="/posts/${post.postId}/comments" method="post" class="d-flex gap-2">
                    <input type="text" name="content" class="form-control" placeholder="댓글을 남겨주세요. (작성자와 당사자만 볼 수 있습니다)" required>
                    <button type="submit" class="btn btn-px-4 fw-bold primary text-nowrap">등록</button>
                </form>
            </div>

        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Blog List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <link href="css/style.css" rel="stylesheet">
        <style>
            .blog-card {
                border: 1px solid #ccc;
                margin-bottom: 20px;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }
            .blog-card img {
                width: 100%;
                height: auto;
                border-radius: 5px;
            }
            .blog-content {
                padding-top: 15px;
            }

            .blog-title {
                font-size: 1.5rem;
                font-weight: bold;
                margin-top: 0;
            }

            .blog-brief {
                margin-top: 10px;
            }

            .read-more-btn {
                display: inline-block;
                margin-top: 10px;
                color: #fff;
                background-color: #ff6666;
                border: none;
                padding: 10px 15px;
                border-radius: 5px;
                text-decoration: none;
            }

            .read-more-btn:hover {
                background-color: #cc0000;
            }
        </style>
    </head>
    <body>
        <header>
            <jsp:include page="template/header2.jsp"/>
        </header>

        <!-- Main content -->
        <div class="container mt-5" style="box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.2); border-radius: 10px; background: linear-gradient(to bottom, #ffffff 60%, rgba(255, 255, 255, 0.7));">
            <div class="row">
                <c:set var="visibleCount" value="0" />
                <c:forEach var="item" items="${listB}" varStatus="status">
                    <c:if test="${item.status}">
                        <c:set var="visibleCount" value="${visibleCount + 1}" />
                        <div class="col-md-6 mb-4">
                            <div class="blog-card">
                                <img src="images/blog/${item.image}" alt="Current Blog Image" style="max-width: 100%; height: auto;">
                                <div class="blog-title">${item.title}</div>
                                <div class="blog-brief">${item.brief}</div>
                                <a href="postDetails?id=${item.id}" class="read-more-btn">Continue Reading</a>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>

                <c:if test="${empty listB || visibleCount == 0}">
                    <div class="col-12">
                        <div class="no-data text-center">
                            No blogs available at the moment.
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- Pagination Controls -->
            <div class="pagination mt-4 text-center">
                <c:if test="${currentPage > 1}">
                    <a href="postList?page=${currentPage - 1}" class="btn btn-secondary">Previous</a>
                </c:if>

                <c:forEach var="i" begin="1" end="${totalPages}">
                    <a href="postList?page=${i}" class="btn ${i == currentPage ? 'btn-primary' : 'btn-light'}">${i}</a>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a href="postList?page=${currentPage + 1}" class="btn btn-secondary">Next</a>
                </c:if>
            </div>
        </div>

        <!-- Footer -->
        <footer>
            <jsp:include page="template/footer.jsp"/>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>

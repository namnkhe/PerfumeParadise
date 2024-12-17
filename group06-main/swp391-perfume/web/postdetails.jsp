<%-- 
    Document   : blogdetails
    Created on : 14 Oct 2024, 15:02:48
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Blog Details</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <link href="css/style.css" rel="stylesheet">
        <style>
            /* Expand the main content container */
            .main-container {
                max-width: 1200px; /* Expanded width */
                margin: auto; /* Center the container */
                padding: 2rem;
                background-color: #fff;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
            }
            .blog-title {
                font-size: 2.5rem; /* Larger font size for title */
                font-weight: bold;
                margin-bottom: 1.5rem;
                text-align: center; /* Center title */
            }
            .blog-content {
                font-size: 1.2rem;
                line-height: 1.8;
                white-space: pre-wrap; /* Preserve newlines and spaces */
                text-align: justify; /* Justify text for better readability */
            }
            .blog-meta {
                font-size: 1rem;
                color: #555;
                margin-bottom: 1.5rem;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header>
            <jsp:include page="template/header2.jsp"/>
        </header>

        <!-- Main Content -->
        <main class="container-fluid mt-5">
            <div class="main-container">
                <img src="images/blog/${blog.image}" alt="Current Blog Image" style="max-width: 100%; height: auto;"> <!-- Replace with actual image URL -->

                <!-- Blog Title Display -->
                <div class="mb-3">
                    <div class="blog-title">${blog.title}</div>
                </div>

                <!-- Blog Metadata -->
                <div class="blog-meta">
                    <p>Created by: ${blog.createdBy} on ${blog.createdAt}</p>
                    <c:if test="${not empty blog.updatedBy}">
                        <p>Last updated by: ${blog.updatedBy} on ${blog.updatedAt}</p>
                    </c:if>
                </div>

                <!-- Blog Content Display -->
                <div class="mb-3">
                    <div class="blog-content">${blog.content}</div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer>
            <jsp:include page="template/footer.jsp"/>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>

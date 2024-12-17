<%-- 
    Document   : blogdetails
    Created on : 14 Oct 2024, 15:02:48
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Blog Details</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                display: flex;
                min-height: 100vh;
                flex-direction: column;
                margin: 0;
            }

            .main-container {
                flex-grow: 1;
                display: flex;
                justify-content: center; /* Center the content horizontally */
                align-items: flex-start; /* Align items to the top */
                padding-top: 5%; /* Padding from the top */
                max-width: 1200px; /* Make the container wider */
                margin: auto;
                position: relative; /* Position relative to allow fixed sidebar */
            }

            .content-wrapper {
                width: 100%;
                padding: 2rem;
                box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
                background-color: #fff;
                border-radius: 10px;
            }

            .floating-sidebar {
                position: fixed;
                top: 20%; /* Adjust the top position as needed */
                right: 20px; /* Float to the right side */
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .button-group {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .blog-title {
                font-size: 1.5rem;
                font-weight: bold;
                margin-bottom: 1rem;
            }

            .blog-content {
                white-space: pre-wrap; /* Preserve newlines and spaces */
                font-size: 1rem;
                line-height: 1.6;
            }

            .blog-meta {
                font-size: 0.9rem;
                color: #555;
                margin-bottom: 1rem;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <jsp:include page="template/sidebar.jsp" />

        <!-- Main Content -->
        <main class="main-container">
            <div class="content-wrapper">
                <!-- Blog Title -->
                <div class="blog-title">${blog.title}</div>

                <!-- Blog Metadata -->
                <div class="blog-meta">
                    <p>Created by: ${blog.createdBy} on ${blog.createdAt}</p>
                    <c:if test="${not empty blog.updatedBy}">
                        <p>Last updated by: ${blog.updatedBy} on ${blog.updatedAt}</p>
                    </c:if>
                </div>

                <!-- Blog Content -->
                <div class="blog-content">${blog.content}</div>

                <div class="mb-3">
                    <label class="form-label">Current Image:</label>
                    <div>
                        <img src="images/blog/${blog.image}" alt="Current Blog Image" style="max-width: 100%; height: auto;">
                    </div>
                </div>
            </div>

            <!-- Floating Sidebar with Action Buttons -->
            <div class="floating-sidebar">
                <div class="button-group">
                    <!-- Back to Blog List Button -->
                    <a href="blogList" class="btn btn-secondary">Back to Blog List</a>

                    <!-- Conditional Hide/Unhide Button -->
                    <c:choose>
                        <c:when test="${blog.status}">
                            <a href="hideBlog?id=${blog.id}" class="btn btn-warning">Hide Blog</a>
                        </c:when>
                        <c:otherwise>
                            <a href="unhideBlog?id=${blog.id}" class="btn btn-success">Unhide Blog</a>
                        </c:otherwise>
                    </c:choose>

                    <!-- Update Blog Button -->
                    <a href="updateBlog?id=${blog.id}" class="btn btn-primary">Update Blog</a>

                    <!-- Delete Blog Button -->
                    <a href="deleteBlog?id=${blog.id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this blog?');">Delete Blog</a>
                </div>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

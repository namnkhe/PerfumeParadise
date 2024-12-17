<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Blog Manager</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                // Function to get cell value for sorting
                const getCellValue = (tr, idx) => tr.children[idx].innerText || tr.children[idx].textContent;

                // Comparator function for sorting
                const comparer = (idx, asc) => (a, b) =>
                        ((v1, v2) =>
                            v1 !== '' && v2 !== '' && !isNaN(v1) && !isNaN(v2) ? v1 - v2 : v1.toString().localeCompare(v2)
                        )(getCellValue(asc ? a : b, idx), getCellValue(asc ? b : a, idx));

                // Add click event listeners for sorting
                document.querySelectorAll('th[data-sort]').forEach(th => th.addEventListener('click', function () {
                        const table = th.closest('table');
                        const indicator = this.querySelector(".sort-indicator");

                        // Remove sort indicators from other headers
                        document.querySelectorAll('.sort-indicator').forEach(ind => ind.textContent = '');

                        // Sort the table
                        Array.from(table.querySelectorAll('tbody > tr'))
                                .sort(comparer(Array.from(th.parentNode.children).indexOf(th), this.asc = !this.asc))
                                .forEach(tr => table.querySelector('tbody').appendChild(tr));

                        // Update sort indicator
                        indicator.textContent = this.asc ? '↑' : '↓';
                    }));

                // Prevent unhiding blog without a thumbnail
                document.querySelectorAll('.unhide-btn').forEach(button => {
                    button.addEventListener('click', function (event) {
                        const row = this.closest('tr'); // Find the closest row
                        const thumbnail = row.querySelector('img'); // Find the image element in the row

                        // Check if thumbnail exists or the source is "no-thumbnail.jpg"
                        if (!thumbnail || thumbnail.src.includes('no-thumbnail.jpg')) {
                            event.preventDefault(); // Prevent the unhide action
                            alert('This blog cannot be unhidden because it has no thumbnail.');
                        }
                    });
                });
            });
        </script>
        <style>
            body {
                display: flex;
                min-height: 100vh;
                flex-direction: column;
            }
            .content {
                margin-left: 250px;
                padding: 20px;
                width: calc(100% - 250px);
            }
            .table th, .table td {
                vertical-align: middle;
                text-align: center;
            }
            .add-blog-btn {
                margin-bottom: 20px;
            }
            .no-data {
                text-align: center;
                font-size: 18px;
                color: #6c757d;
            }
            .sort-indicator {
                margin-left: 5px;
                font-size: 12px;
            }
            .actions-btn {
                display: flex;
                gap: 5px;
                justify-content: center;
            }
            .actions-btn a {
                white-space: nowrap;
                width: 32px;
                height: 32px;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .pagination {
                margin-top: 20px;
                text-align: center;
            }
            .pagination .btn {
                margin: 2px;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <jsp:include page="template/sidebar.jsp" />

        <!-- Main content -->
        <div class="content">
            <h2>Blog Manager</h2>

            <!-- Add Blog Button -->
            <div class="add-blog-btn">
                <a href="addBlog" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add New Blog
                </a>
            </div>

            <!-- Blog List Table -->
            <table class="table table-bordered table-hover table-striped" id="blogTable">
                <thead class="table-dark">
                    <tr>
                        <th>#</th> <!-- Sequential ID Column -->
                        <th>Thumbnail</th>
                        <th data-sort="title">Title <span class="sort-indicator"></span></th>
                        <th>Brief</th>
                        <th data-sort="createdBy">Created By <span class="sort-indicator"></span></th>
                        <th data-sort="updatedBy">Updated By <span class="sort-indicator"></span></th>
                        <th data-sort="createdAt">Created At <span class="sort-indicator"></span></th>
                        <th data-sort="updatedAt">Updated At <span class="sort-indicator"></span></th>
                        <th data-sort="status">Status <span class="sort-indicator"></span></th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Use a counter to display the row number -->
                    <c:set var="counter" value="0" />
                    <c:forEach var="item" items="${listB}" varStatus="status">
                        <tr>
                            <!-- Increment the counter for each row -->
                            <td>${status.index + 1}</td> <!-- Display the row number -->
                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.image}">
                                        <img src="images/blog/${item.image}" class="img-thumbnail" alt="${item.title}" style="max-width: 100px; height: 100px;">
                                    </c:when>
                                    <c:otherwise>
                                        No thumbnail
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${item.title}</td>
                            <td>${item.brief}</td>
                            <td>${item.createdBy}</td>
                            <td>${item.updatedBy}</td>
                            <td>${item.createdAt}</td>
                            <td>${item.updatedAt}</td>
                            <!-- Status Column: Show "Hidden" or "Visible" based on status -->
                            <td>
                                <c:choose>
                                    <c:when test="${item.status}">
                                        <span class="badge bg-success">Visible</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Hidden</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="actions-btn">
                                <!-- Update Button -->
                                <a href="updateBlog?id=${item.id}" class="btn btn-warning btn-sm" aria-label="Update Blog" title="Update Blog">
                                    <i class="fas fa-edit"></i>
                                </a>

                                <!-- Delete Button -->
                                <a href="deleteBlog?id=${item.id}" class="btn btn-danger btn-sm" aria-label="Delete Blog" title="Delete Blog"
                                   onclick="return confirm('Are you sure you want to delete this blog?');">
                                    <i class="fas fa-trash-alt"></i>
                                </a>

                                <!-- Read Button -->
                                <a href="blogDetails?id=${item.id}" class="btn btn-info btn-sm" aria-label="Read Blog" title="Read Blog">
                                    <i class="fas fa-book-open"></i>
                                </a>

                                <!-- Hide/Unhide Button -->
                                <c:choose>
                                    <c:when test="${item.status}">
                                        <a href="hideBlog?id=${item.id}" class="btn btn-success btn-sm" aria-label="Hide Blog" title="Hide Blog"
                                           onclick="return confirm('Are you sure you want to hide this blog?');">
                                            <i class="fas fa-eye"></i> 
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="unhideBlog?id=${item.id}" class="btn btn-secondary btn-sm unhide-btn" aria-label="Unhide Blog" title="Unhide Blog"
                                           onclick="return confirm('Are you sure you want to publish this blog?');">
                                            <i class="fas fa-eye-slash"></i> 
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listB}">
                        <tr>
                            <td colspan="10" class="no-data">No blogs available at the moment.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>

            <!-- Pagination Controls -->
            <div class="pagination mt-4 text-center">
                <c:if test="${currentPage > 1}">
                    <a href="blogList?page=${currentPage - 1}" class="btn btn-secondary">Previous</a>
                </c:if>

                <c:forEach var="i" begin="1" end="${totalPages}">
                    <a href="blogList?page=${i}" class="btn ${i == currentPage ? 'btn-primary' : 'btn-light'}">${i}</a>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a href="blogList?page=${currentPage + 1}" class="btn btn-secondary">Next</a>
                </c:if>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>

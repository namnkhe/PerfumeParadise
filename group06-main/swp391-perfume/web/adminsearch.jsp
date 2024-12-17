<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PerfumePod Search</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <style>
            body {
                display: flex;
            }
            .sidebar {
                background-color: #343a40;
                height: 100vh;
                width: 230px;
                position: fixed;
                top: 0;
                left: 0;
                padding-top: 20px;
            }
            .sidebar a {
                color: #fff;
                text-decoration: none;
                display: block;
                padding: 10px;
            }
            .sidebar a:hover {
                background-color: #495057;
            }
            .content {
                margin-left: 250px;
                padding: 20px;
                width: calc(100% - 250px);
            }
            .table th, .table td {
                vertical-align: middle;
            }
            .img-thumbnail {
                max-width: 40px;
            }
            .actions-btn {
                display: flex;
                gap: 10px;
            }
        </style>
    </head>
    <body>

        <!-- Sidebar -->
        <div class="sidebar">
            <a href="admin"><i class="fas fa-home"></i> Dashboard</a>
            <a href="Admin2"><i class="fas fa-box"></i> Product Manager</a>
            <a href="CustomerManagerServlet"><i class="fas fa-users"></i> Customers Manager</a>
            <a href="BlogManagerServlet"><i class="fas fa-blog"></i> Blog Manager</a>
            <a href="SliderManagerServlet"><i class="fas fa-image"></i> Slider Manager</a>
            <a href="FeedbackManagerServlet"><i class="fas fa-comment"></i> Feedback Manager</a>
            <a href="adminlogout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>

        <!-- Main content -->
        <div class="content">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3">
                <h1 class="h2">Search Results</h1>
            </div>

            <!-- Search Form -->
            <div class="container-fluid mb-3">
                <div class="row">
                    <div class="search col-12">
                        <form action="searchproduct" method="get" class="search-form">
                            <input value="1" type="hidden" name="u"/>
                            <jsp:include page="template/searchbaradmin.jsp"/>
                        </form>
                    </div>
                </div>
            </div>

            <c:if test="${requestScope.list.isEmpty()}">
                <span>No product found</span>
            </c:if>
            <hr>

            <!-- Product Table -->
            <div class="row">
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>ID</th> <!-- Added Product ID -->
                            <th>Thumbnail</th>
                            <th>Title</th>
                            <th>Quantity</th>
                            <th>Size</th>
                            <th>Price</th>
                            <th>Category</th>
                            <th>Brand</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${requestScope.list}" var="item">
                            <tr>
                                <td>${item.id}</td> <!-- Display Product ID -->
                                <td><img src="images/perfume/${item.image}" class="img-thumbnail" alt="${item.name}"></td>
                                <td>${item.name}</td>
                                <td>${item.quantity}</td>
                                <td>${item.size}ml</td>
                                <td>${item.price}$</td>
                                <td>${item.category.name}</td>
                                <td>${item.brand.name}</td>
                                <td class="actions-btn">
                                    <a href="update_perfume?id=${item.id}" class="btn btn-warning btn-sm">Update</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Include Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>

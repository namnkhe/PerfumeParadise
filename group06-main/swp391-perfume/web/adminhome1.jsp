<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product List</title>
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
            /* Ensure the search form displays in one line */
            .search-form {
                display: flex;
                gap: 8px;
                align-items: center;
                justify-content: flex-start;
                flex-wrap: nowrap;
            }
            .form-group {
                flex: 1;
                min-width: 120px;
            }
            .form-group label {
                font-size: 12px;
            }
            .search-buttons {
                display: flex;
                gap: 5px;
            }
        </style>
    </head>
    <body>

        <!-- Sidebar -->
        <div class="sidebar">
            <a href="admin"><i class="fas fa-home"></i> Dashboard</a>
            <a href="Admin2"><i class="fas fa-box"></i> Product Manager</a>
            <a href="customerList"><i class="fas fa-users"></i> Customers Manager</a>
            <a href="blogList"><i class="fas fa-blog"></i> Blog Manager</a>
            <a href="SliderManagerServlet"><i class="fas fa-image"></i> Slider Manager</a>
            <a href="FeedBackList"><i class="fas fa-comment"></i> Feedback Manager</a>
            <a href="adminlogout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>

        <!-- Main content -->
        <div class="content">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3">
                <h1 class="h2">Product List</h1>
                <!-- Button to Open Modal -->
                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addPerfumeModal">
                    Add New Product
                </button>
            </div>

            <!-- Add Perfume Modal -->
            <div class="modal fade" id="addPerfumeModal" tabindex="-1" aria-labelledby="addPerfumeModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addPerfumeModalLabel">Add New Perfume</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <!-- Form Add Perfume -->
                            <form enctype="multipart/form-data" action="addperfume" method="post">
                                <div class="mb-3">
                                    <label class="form-label">Perfume Name:</label>
                                    <input type="text" class="form-control" name="name" placeholder="Enter perfume name" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Size (ml):</label>
                                    <input type="number" class="form-control" name="size" min="0" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Price ($):</label>
                                    <input type="number" class="form-control" name="price" min="0" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Release Date:</label>
                                    <input type="date" class="form-control" name="releaseDate">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Category:</label>
                                    <select class="form-select" name="cid">
                                        <c:forEach items="${sessionScope.listC}" var="c">
                                            <option value="${c.id}">${c.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Brand:</label>
                                    <select class="form-select" name="bid">
                                        <c:forEach items="${sessionScope.listB}" var="b">
                                            <option value="${b.id}">${b.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Description:</label>
                                    <textarea class="form-control" name="description" rows="4" placeholder="Enter perfume description" required></textarea>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Select Image:</label>
                                    <input type="file" class="form-control" name="image" accept=".jpg" required>
                                </div>
                                <div class="text-center">
                                    <button type="submit" class="btn btn-primary">Add Perfume</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <script>
                $(document).ready(function () {
                    if ($('.alert-danger').length > 0) {
                        $('#addPerfumeModal').modal('show');
                    }
                });
            </script>


            <!-- Search Form in a Single Row -->
            <div class="container-fluid">
                <div class="row">
                    <div class="search col-12">
                        <form action="searchproduct" method="get" class="search-form">
                            <input value="1" type="hidden" name="u"/>
                            <jsp:include page="template/searchbaradmin.jsp"/>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Product Table -->
            <table id="productTable" class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Thumbnail</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Listed Price</th>
                        <th>Quantity</th>
                        <th>Brand</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${sessionScope.listP}" var="item">
                        <tr>
                            <td>${item.id}</td>
                            <td><img src="images/perfume/${item.image}" class="img-thumbnail" alt="${item.name}"></td>
                            <td>${item.name}</td>
                            <td>${item.category.name}</td>
                            <td>${item.price}$</td>
                            <td>${item.availableQuantity}</td>
                            <td>${item.brand.name}</td>
                            <td class="actions-btn">
                                <a href="update_perfume?id=${item.id}" class="btn btn-warning btn-sm">View detail</a>
                                <form action="${pageContext.request.contextPath}/hidePerfume" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="${item.id}"/>
                                    <button type="submit" class="btn btn-danger btn-sm">Hide</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Include Bootstrap and DataTables JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.1/js/jquery.dataTables.min.js"></script>
        <script>
                $(document).ready(function () {
                    $('#productTable').DataTable({
                        "paging": true, // Bật phân trang
                        "searching": true, // Bật tìm kiếm
                        "ordering": true, // Bật sắp xếp
                        "info": true, // Hiển thị thông tin bảng
                        "pageLength": 6, // Số dòng mỗi trang (có thể chỉnh lại theo ý muốn)
                        "lengthChange": false, // Ẩn tùy chọn thay đổi số dòng mỗi trang nếu không cần
                        "language": {
                            "paginate": {
                                "previous": "Previous",
                                "next": "Next"
                            },
                            "emptyTable": "No data available in table", // Thông báo nếu bảng rỗng
                        }
                    });
                });
        </script>
        <style>
            /* Khoảng cách giữa các nút phân trang */
            .dataTables_wrapper .dataTables_paginate .paginate_button {
                margin: 0 5px; /* Khoảng cách ngang giữa các nút */
                padding: 5px 10px; /* Độ rộng và chiều cao của nút */
                border-radius: 5px; /* Bo góc nút */
                color: #007bff; /* Màu chữ */
                background-color: #f8f9fa; /* Màu nền nhẹ */
                border: 1px solid #ddd; /* Đường viền cho nút */
            }

            /* Đổi màu nền khi di chuột qua */
            .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
                background-color: #007bff;
                color: white;
            }

            /* Kiểu dáng nút hiện tại (active) */
            .dataTables_wrapper .dataTables_paginate .paginate_button.current {
                background-color: #007bff;
                color: white;
            }
        </style>
    </body>
</html>

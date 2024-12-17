<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Perfume</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <style>
            body {
                display: flex;
                background-color: #f8f9fa;
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
            .img-thumbnail {
                max-width: 250px;
            }
            .form-control, .form-select {
                width: 100%;
            }
            .btn-primary {
                background-color: #007bff;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <div class="sidebar">
            <a href="Inventory"><i class="fas fa-home"></i> Dashboard</a>
            <a href="Inventory"><i class="fas fa-box"></i> Product Manager</a>
            <a href="inventorylogout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>

        <!-- Main content -->
        <div class="content">
            <h1 class="h2">Product Details</h1>

            <form action="inventoryupdate?id=${item.id}" method="post">
                <div class="row mb-3">
                    <div class="col-md-4">
                        <img class="img-fluid img-thumbnail" src="images/perfume/${item.image}" alt="${item.name}">
                    </div>
                    <div class="col-md-8">
                        <div class="mb-3">
                            <label for="name" class="form-label">Name</label>
                            <input type="text" id="name" name="name" class="form-control" value="${item.name}" readonly required>
                        </div>
                        <div class="row g-3 align-items-center">
                            <div class="col-md-4">
                                <label for="quantity" class="form-label">Quantity</label>
                                <input type="number" name="quantity" class="form-control" min="0" value="${item.quantity}" readonly required>
                            </div>
                            <div class="col-md-4">
                                <label for="size" class="form-label">Size (ml)</label>
                                <input type="number" name="size" class="form-control" min="0" value="${item.size}" readonly required>
                            </div>
                            <div class="col-md-4">
                                <label for="price" class="form-label">Price ($)</label>
                                <input type="number" name="price" class="form-control" min="0" value="${item.price}" readonly required>
                            </div>
                        </div>
                        <!-- New fields for Hold and Import Price -->
                        <div class="row g-3 mt-3">
                            <div class="col-md-4">
                                <label for="hold" class="form-label">Hold</label>
                                <input type="number" name="hold" class="form-control" min="0" value="${item.hold}" required>
                            </div>
                            <div class="col-md-4">
                                <label for="importPrice" class="form-label">Import Price ($)</label>
                                <input type="number" name="importPrice" class="form-control" min="0" value="${item.importPrice}" required>
                            </div>
                        </div>
                        <div class="row g-3 mt-3">
                            <div class="col-md-6">
                                <label for="cid" class="form-label">Category</label>
                                <select id="cid" name="cid" class="form-select" disabled required>
                                    <option value="${item.category.id}">${item.category.name}</option>
                                    <c:forEach items="${sessionScope.listC}" var="c">
                                        <c:if test="${c.id != item.category.id}">
                                            <option value="${c.id}">${c.name}</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="bid" class="form-label">Brand</label>
                                <select id="bid" name="bid" class="form-select" disabled required>
                                    <option value="${item.brand.id}">${item.brand.name}</option>
                                    <c:forEach items="${sessionScope.listB}" var="b">
                                        <c:if test="${b.id != item.brand.id}">
                                            <option value="${b.id}">${b.name}</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>


                        <!-- Phần nhập mô tả -->
                        <div class="mt-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea id="description" name="description" class="form-control" rows="4" readonly>${item.description}</textarea>
                        </div>

                        <div class="mt-3">
                            <button type="submit" class="btn btn-primary">Update</button>
                            <button type="reset" class="btn btn-secondary">Reset</button>
                        </div>
                    </div>
                </div>
            </form>

            <span style="color:red">${ms}</span>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

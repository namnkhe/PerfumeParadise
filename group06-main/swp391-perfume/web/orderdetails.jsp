<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Details</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <style>
            body {
                background-color: #f8f9fa;
                display: flex; /* Make the body a flex container */
                margin: 0;
                padding: 0;
            }
            /* Sidebar styling */
            .sidebar {
                width: 250px; /* Set a fixed width for the sidebar */
                background-color: #343a40;
                color: #ffffff;
                height: 100vh;
                position: fixed;
                top: 0;
                left: 0;
                padding-top: 20px;
                box-sizing: border-box;
            }
            .sidebar a {
                color: #ffffff;
                text-decoration: none;
                padding: 10px;
                display: block;
            }
            .sidebar a:hover {
                background-color: #495057;
            }
            /* Main content styling */
            .main-content {
                margin-left: 250px; /* Offset to make room for the sidebar */
                padding: 20px;
                width: calc(100% - 250px); /* Take the remaining width after sidebar */
                box-sizing: border-box;
            }
            .card-header {
                background-color: #007bff;
                color: white;
                font-size: 1.25rem;
                font-weight: bold;
            }
            .form-label {
                font-weight: bold;
            }
            .form-control-plaintext {
                font-size: 1rem;
            }
            .table-responsive {
                overflow-x: auto;
            }
            .table {
                margin-bottom: 0;
            }
            .table-dark th {
                color: #fff;
                background-color: #343a40;
            }
            /* Shrink image size in the table */
            .order-image {
                width: 80px; /* Set fixed width */
                height: 80px; /* Set fixed height */
                object-fit: cover; /* Ensures image maintains aspect ratio while fitting the dimensions */
            }
            .text-end {
                text-align: right;
            }
            .total-price {
                font-weight: bold;
                font-size: 1.2rem;
                color: #007bff;
            }
        </style>
    </style>
</head>
<body>
    <!-- Sidebar -->
    <jsp:include page="template/adminheader.jsp"/>

    <!-- Main Content Wrapper -->
    <div class="main-content">
        <div class="container-fluid mt-4">
            <!-- Screen Header -->
            <h1 class="text-center mb-4" style="font-size: 2rem; font-weight: bold; color: #333;">Order Details</h1>

            <div class="row g-4">
                <!-- Order Details Section (Left) -->
                <div class="col-md-8">
                    <div class="card shadow-sm mb-4" style="border-radius: 10px;">
                        <div class="card-header" style="background-color: #0056b3; color: #fff; border-radius: 10px 10px 0 0;">Order Information</div>
                        <div class="card-body" style="background-color: #f7f9fc; padding: 20px;">
                            <div class="row mb-3">
                                <div class="col-4">
                                    <label class="form-label">Billing Address</label>
                                </div>
                                <div class="col-8">
                                    <p class="form-control-plaintext">${o.address != null ? o.address : "N/A"}</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-4">
                                    <label class="form-label">Full Name</label>
                                </div>
                                <div class="col-8">
                                    <p class="form-control-plaintext">${c.fullname != null ? c.fullname : "N/A"}</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-4">
                                    <label class="form-label">Phone</label>
                                </div>
                                <div class="col-8">
                                    <p class="form-control-plaintext">${c.phone != null ? c.phone : "N/A"}</p>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-4">
                                    <label class="form-label">Email</label>
                                </div>
                                <div class="col-8">
                                    <p class="form-control-plaintext">${c.email != null ? c.email : "N/A"}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Order Details Table Section -->
                    <div class="card shadow-sm" style="border-radius: 10px;">
                        <div class="card-header" style="background-color: #0056b3; color: #fff; border-radius: 10px 10px 0 0;">Order Details</div>
                        <div class="card-body" style="background-color: #f7f9fc;">
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover" style="border-radius: 10px; overflow: hidden;">
                                    <thead class="table-dark">
                                        <tr>
                                            <th scope="col">Image</th>
                                            <th scope="col">Product Name</th>
                                            <th scope="col">Quantity</th>
                                            <th scope="col">Total Price</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:set var="sum" value="${0}"/>
                                        <c:if test="${not empty listOD}">
                                            <c:forEach items="${listOD}" var="item">
                                                <tr style="background-color: #fff;">
                                                    <td><img class="order-image" src="images/perfume/${item.perfume.image}" alt="${item.perfume.name}"></td>
                                                    <td>${item.perfume.name}</td>
                                                    <td>
                                                        <input id="${item.id}q" readonly name="quantity" value="${item.quantity}" type="number" class="form-control form-control-sm" />
                                                    </td>
                                                    <td>&dollar; ${item.total}</td>
                                                    <c:set var="price" value="${item.total}"/> 
                                                    <c:set var="sum" value="${sum + price}"/>
                                                </tr>
                                            </c:forEach>
                                        </c:if>
                                        <c:if test="${empty listOD}">
                                            <tr><td colspan="4" class="text-center">No products in this order.</td></tr>
                                        </c:if>
                                    </tbody>
                                    <tfoot>
                                        <tr style="background-color: #e9ecef;">
                                            <td colspan="3" class="text-end"><strong>Total:</strong></td>
                                            <td class="total-price">&dollar; ${sum}</td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Customer Information Section (Right) -->
                <div class="col-md-4">
                    <div class="card shadow-sm" style="border-radius: 10px;">
                        <div class="card-header" style="background-color: #0056b3; color: #fff; border-radius: 10px 10px 0 0;">Customer Information</div>
                        <div class="card-body text-center" style="background-color: #f7f9fc;">
                            <!-- Customer Avatar -->
                            <c:if test="${not empty c.image}">
                                <img src="images/avatars/${c.image}" alt="Customer Avatar" class="rounded-circle mb-3 border border-2 border-light shadow" style="width: 100px; height: 100px; object-fit: cover;">
                            </c:if>
                            <c:if test="${empty c.image}">
                                <img src="images/avatars/default-avatar.png" alt="Default Avatar" class="rounded-circle mb-3 border border-2 border-light shadow" style="width: 100px; height: 100px; object-fit: cover;">
                            </c:if>

                            <!-- Customer Details in Two-Column Format -->
                            <div class="row">
                                <div class="col-5 text-end">
                                    <label class="form-label">Full Name:</label>
                                </div>
                                <div class="col-7 text-start">
                                    <p class="form-control-plaintext">${c.fullname != null ? c.fullname : "N/A"}</p>
                                </div>

                                <div class="col-5 text-end">
                                    <label class="form-label">Username:</label>
                                </div>
                                <div class="col-7 text-start">
                                    <p class="form-control-plaintext">${c.username != null ? c.username : "N/A"}</p>
                                </div>

                                <div class="col-5 text-end">
                                    <label class="form-label">Email:</label>
                                </div>
                                <div class="col-7 text-start">
                                    <p class="form-control-plaintext">${c.email != null ? c.email : "N/A"}</p>
                                </div>

                                <div class="col-5 text-end">
                                    <label class="form-label">Phone:</label>
                                </div>
                                <div class="col-7 text-start">
                                    <p class="form-control-plaintext">${c.phone != null ? c.phone : "N/A"}</p>
                                </div>

                                <div class="col-5 text-end">
                                    <label class="form-label">Address:</label>
                                </div>
                                <div class="col-7 text-start">
                                    <p class="form-control-plaintext">${c.address != null ? c.address : "N/A"}</p>
                                </div>

                                <div class="col-5 text-end">
                                    <label class="form-label">Gender:</label>
                                </div>
                                <div class="col-7 text-start">
                                    <p class="form-control-plaintext">${c.gender != null ? c.gender : "N/A"}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

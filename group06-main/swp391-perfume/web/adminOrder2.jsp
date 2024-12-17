<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.List"%>
<%@page import="dal.OrderDetailDAO"%>
<%@page import="model.OrderDetail"%>
<%@page import="model.Order"%>
<%@page import="model.Perfume"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <style>
            body {
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
            .table th, .table td {
                vertical-align: middle;
            }
            .img-fluid {
                width: 40px;  /* Fixed width */
                height: 40px; /* Fixed height */
                object-fit: cover; /* Ensures the image covers the specified width and height */
                border-radius: 5px;
                margin-right: 5px; /* Add some space between the image and the text */
            }
            .btn-custom {
                border-radius: 20px;
                margin: 5px;
                width: 120px; /* Set a fixed width for all buttons */
            }
            .product-info {
                display: flex;
                align-items: center;
                justify-content: space-between; /* Aligns items evenly with space between */
            }
            .quantity {
                margin-left: auto; /* Pushes quantity to the right */
                white-space: nowrap; /* Prevents line break */
            }
            .text-center {
                text-align: center;
            }
        </style>
    </head>
    <body>

        <!-- Sidebar -->
        <jsp:include page="template/sidebar.jsp" />

        <!-- Main content -->
        <div class="content">
            <div class="card">
                <div class="card-body">
                    <h1>Order List</h1>
                    <div class="d-flex justify-content-between mb-3">
                        <div class="d-flex flex-wrap"> <!-- Flex container for buttons -->
                            <a href="adminvieworder"><button class="btn btn-outline-success btn-custom">All</button></a>
                            <a href="searchorder?status=denied"><button class="btn btn-outline-danger btn-custom">Denied</button></a>
                            <a href="searchorder?status=confirming"><button class="btn btn-outline-warning btn-custom">Confirming</button></a>
                            <a href="searchorder?status=preparing"><button class="btn btn-outline-info btn-custom">Preparing</button></a>
                            <a href="searchorder?status=shipping"><button class="btn btn-outline-primary btn-custom">Shipping</button></a>
                            <a href="searchorder?status=complete"><button class="btn btn-outline-success btn-custom">Complete</button></a>
                        </div>
                    </div>
                    <span>${requestScope.ms}</span>
                    <br/>
                    <div>
                        <table class="table table-striped table-bordered mt-4">
                            <thead class="table-dark">
                                <tr>
                                    <th class="text-center">Customer</th>
                                    <th class="text-center">Products</th>
                                    <th class="text-center">Address</th>
                                    <th class="text-center">Order Date</th>
                                    <th class="text-center">Status</th>
                                    <th class="text-center">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    OrderDetailDAO od = new OrderDetailDAO();
                                    request.setAttribute("od", od);
                                %>
                                <c:forEach items="${adminorders}" var="o">
                                    <c:set var="sum" value="0"/>
                                    <tr>
                                        <td class="text-center">${o.customer.username}</td>
                                        <td>
                                            <c:forEach items="${od.getOrderDetailsByOrderID(o.id)}" var="item">
                                                <div class="product-info mb-1">
                                                    <img class="img-fluid" src="images/perfume/${item.getPerfume().image}" alt="${item.getPerfume().name}">
                                                    <strong>${item.getPerfume().name}</strong>
                                                    <span class="quantity ms-auto"> (Quantity: ${item.quantity})</span>
                                                    <c:set var="price" value="${item.total}"/> 
                                                    <c:set var="sum" value="${sum + price}"/>
                                                </div>
                                            </c:forEach>
                                        </td>
                                        <td class="text-center">${o.address}</td>
                                        <td class="text-center">${o.orderdate}</td>
                                        <td>
                                            <form action="adminvieworder" method="post" class="d-inline">
                                                <input type="hidden" name="orderId" value="${o.id}" />
                                                <select name="status" class="form-select" required>
                                                    <option value="denied">Denied</option>
                                                    <option value="confirming">Confirming</option>
                                                    <option value="shipping">Shipping</option>
                                                    <option value="complete">Complete</option>
                                                </select>
                                                <button type="submit" class="btn btn-primary btn-sm ms-2">Update</button>
                                            </form>
                                        </td>
                                        <td><strong>${sum}&dollar;</strong></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </body>
</html>
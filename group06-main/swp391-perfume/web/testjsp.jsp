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
                max-width: 30px;
                border-radius: 5px;
            }
            .btn-custom {
                border-radius: 20px;
                margin: 5px;
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
                        <a href="adminvieworder"><button class="btn btn-outline-success btn-custom">All</button></a>
                        <a href="searchorder?status=denied"><button class="btn btn-outline-danger btn-custom">Denied</button></a>
                        <a href="searchorder?status=confirming"><button class="btn btn-outline-warning btn-custom">Confirming</button></a>
                        <a href="searchorder?status=preparing"><button class="btn btn-outline-info btn-custom">Preparing</button></a>
                        <a href="searchorder?status=shipping"><button class="btn btn-outline-primary btn-custom">Shipping</button></a>
                        <a href="searchorder?status=complete"><button class="btn btn-outline-success btn-custom">Complete</button></a>
                    </div>
                    <span>${requestScope.ms}</span>
                    <br/>
                    <div>
                        <table class="table table-striped table-bordered mt-4">
                            <thead class="table-dark">
                                <tr>
                                    <th>Customer</th>
                                    <th>Products</th>
                                    <th>Address</th>
                                    <th>Order Date</th>
                                    <th>Status</th>
                                    <th>Total</th>
                                </tr>
                            </thead>
                            <%
                                                                OrderDetailDAO od = new OrderDetailDAO();
                                                                request.setAttribute("od", od);
                            %>
                            <c:forEach items="${adminorders}" var="o">
                                <c:set var="sum" value="0"/>
                                <tr>

                                    <td>${o.customer.username}</td>
                                    <td>
                                        <c:forEach items="${od.getOrderDetailsByOrderID(o.id)}" var="item">
                                            <div class="d-flex align-items-center mb-1">
                                                <img class="img-fluid me-2" src="images/perfume/${item.getPerfume().image}" alt="${item.getPerfume().name}">
                                                <strong>${item.getPerfume().name}</strong> (Quantity: ${item.quantity})
                                                <c:set var="price" value="${item.total}"/> 
                                                <c:set var="sum" value="${sum + price}"/>
                                            </div>
                                        </c:forEach>
                                    </td>
                                    <td>${o.address}</td>
                                    <td>${o.orderdate}</td>
                                    <td class="text-capitalize">${o.status}</td>

                                    <td><strong>${sum}&dollar;</strong></td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </body>
</html>
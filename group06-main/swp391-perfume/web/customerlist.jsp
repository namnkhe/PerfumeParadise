<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Customer Manager</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
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
            }
            .actions-btn {
                display: flex;
                gap: 10px;
            }
            .no-data {
                text-align: center;
                font-size: 18px;
                color: #6c757d;
            }
            .add-blog-btn {
                margin-bottom: 20px;
            }
            .actions-btn a {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 36px;
                height: 36px;
                border-radius: 5px;
            }
            .actions-btn a i {
                font-size: 18px;
                color: #fff;
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
            <h2>Customer Manager</h2>

            <!-- Customer List Table -->
            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Username</th>
                        <th>Full Name</th>
                        <th>Gender</th>
                        <th>Phone</th>
                        <th>Email</th>
                        <th>Address</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${listC}" var="item" varStatus="status">
                        <tr>
                            <td>${(currentPage - 1) * 20 + status.index + 1}</td>
                            <td>${item.username}</td>
                            <td>${item.fullname}</td>
                            <td>${item.gender}</td>
                            <td>${item.phone}</td>
                            <td>${item.email}</td>
                            <td>${item.address}</td>
                            <td>
                                <div class="actions-btn">
                                    <a href="customerDetails?id=${item.id}" class="btn btn-info btn-sm" style="background-color: #00bcd4;"><i class="fas fa-book"></i></a>
                                    <a href="deleteCustomer?id=${item.id}" class="btn btn-danger btn-sm" style="background-color: #f44336;"><i class="fas fa-trash-alt"></i></a>
                                    <a href="updateCustomer?id=${item.id}" class="btn btn-warning btn-sm" style="background-color: #ffeb3b;"><i class="fas fa-edit"></i></a>
                                    <a href="changeStatusCustomer?id=${item.id}" class="btn btn-secondary btn-sm" style="background-color: #607d8b;"><i class="fas fa-eye-slash"></i></a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listC}">
                        <tr>
                            <td colspan="8" class="no-data">No customer available at the moment.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>

            <!-- Pagination Controls -->
            <div class="pagination mt-4 text-center">
                <c:if test="${currentPage > 1}">
                    <a href="customerList?page=${currentPage - 1}" class="btn btn-secondary">Previous</a>
                </c:if>

                <c:forEach var="i" begin="1" end="${totalPages}">
                    <a href="customerList?page=${i}" class="btn ${i == currentPage ? 'btn-primary' : 'btn-light'}">${i}</a>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a href="customerList?page=${currentPage + 1}" class="btn btn-secondary">Next</a>
                </c:if>
            </div>
        </div>
    </body>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</html>

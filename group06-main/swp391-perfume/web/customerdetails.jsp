<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Customer Details</title>
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
            .customer-info {
                box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.2);
                padding: 30px;
                border-radius: 10px;
                background: #ffffff;
            }
            .customer-info h3 {
                margin-bottom: 20px;
                color: #333;
            }
            .customer-info .info-item {
                margin-bottom: 15px;
                font-size: 18px;
            }
            .info-label {
                font-weight: bold;
            }
            .btn-back {
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <jsp:include page="template/sidebar.jsp" />

        <!-- Main content -->
        <div class="content">
            <h2>Customer Details</h2>

            <c:if test="${not empty c}">
                <div class="customer-info">
                    <h3>Customer Information</h3>
                    <div class="info-item">
                        <span class="info-label">Username:</span> ${c.username}
                    </div>
                    <div class="info-item">
                        <span class="info-label">Full Name:</span> ${c.fullname}
                    </div>
                    <div class="info-item">
                        <span class="info-label">Gender:</span> ${c.gender}
                    </div>
                    <div class="info-item">
                        <span class="info-label">Phone:</span> ${c.phone}
                    </div>
                    <div class="info-item">
                        <span class="info-label">Email:</span> ${c.email}
                    </div>
                    <div class="info-item">
                        <span class="info-label">Address:</span> ${c.address}
                    </div>

                    <a href="customerList" class="btn btn-primary btn-back"><i class="fas fa-arrow-left"></i> Back to Customer List</a>
                </div>
            </c:if>
            <c:if test="${empty c}">
                <div class="no-data text-center">
                    <p>No customer information available at the moment.</p>
                    <a href="customerList" class="btn btn-primary btn-back"><i class="fas fa-arrow-left"></i> Back to Customer List</a>
                </div>
            </c:if>
        </div>
    </body>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</html>

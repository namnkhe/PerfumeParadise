<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard</title> 
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                display: flex;
                min-height: 100vh;
            }
            .sidebar {
                background-color: #343a40;
                height: 100vh;
                width: 250px;
                position: fixed;
                top: 0;
                left: 0;
                padding-top: 20px;
            }
            .sidebar a {
                color: #fff;
                text-decoration: none;
                padding: 15px;
                display: block;
            }
            .sidebar a:hover {
                background-color: #495057;
                text-decoration: none;
            }
            .main-content {
                margin-left: 250px;
                padding: 20px;
                width: calc(100% - 250px);
            }
            .dashboard-card {
                padding: 10px;
                background-color: #ffffff;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
            }
            .dashboard-card h5 {
                margin: 0;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <jsp:include page="template/sidebar2.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <h1 class="h2">Admin Dashboard</h1>

            <!-- Tổng quan về đơn hàng -->
            <div class="row">
                <div class="col-md-3">
                    <div class="dashboard-card">
                        <h5>Orders Submitted</h5>
                        <h2>${totalOrdersSubmitted}</h2> <!-- Hiển thị số đơn hàng đã submitted -->
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="dashboard-card">
                        <h5>Orders Success</h5>
                        <h2>${totalOrdersSuccess}</h2> <!-- Hiển thị số đơn hàng thành công -->
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="dashboard-card">
                        <h5>Orders Cancelled</h5>
                        <h2>${totalOrdersCancelled}</h2> <!-- Hiển thị số đơn hàng đã bị hủy -->
                    </div>
                </div>
            </div>

            <!-- Tổng doanh thu -->
            <div class="row">
                <div class="col-md-3">
                    <div class="dashboard-card">
                        <h5>Total Revenue</h5>
                        <h2>${totalRevenue}$</h2> <!-- Hiển thị tổng doanh thu -->
                    </div>
                </div>

                <!-- Doanh thu theo sản phẩm -->
                <div class="col-md-9">
                    <div class="dashboard-card">
                        <h5>Revenue by Product</h5>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Revenue</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${revenueByProduct}">
                                    <tr>
                                        <td>${product[0]}</td>
                                        <td>${product[1]}$</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Khách hàng mới -->
            <div class="row">
                <div class="col-md-6">
                    <div class="dashboard-card">
                        <h5>Newly Registered Customers</h5>
                        <h2>${totalNewCustomers}</h2> <!-- Hiển thị số khách hàng mới đăng ký -->
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="dashboard-card">
                        <h5>Newly Bought Customers</h5>
                        <h2>${totalNewBuyers}</h2> <!-- Hiển thị số khách hàng mới mua hàng -->
                    </div>
                </div>
            </div>

            <!-- Phản hồi (Average Star) -->
            <div class="row">
                <div class="col-md-3">
                    <div class="dashboard-card">
                        <h5>Average Star (Total)</h5>
                        <h2>${avgStarTotal}</h2> <!-- Hiển thị đánh giá trung bình (tất cả) -->
                    </div>
                </div>
                <div class="col-md-9">
                    <div class="dashboard-card">
                        <h5>Average Star by Product</h5>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Average Star</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${avgStarByProduct}">
                                    <tr>
                                        <td>${product[0]}</td>
                                        <td>${product[1]}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Xu hướng đơn hàng 7 ngày gần đây -->
            <div class="row">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            Order Trend (All Orders)
                        </div>
                        <div class="card-body">
                            <canvas id="orderTrendAllChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header">
                            Order Trend (Success Orders)
                        </div>
                        <div class="card-body">
                            <canvas id="orderTrendSuccessChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Script để hiển thị biểu đồ -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            // Biểu đồ Order Trend (All Orders)
            var orderTrendAllData = {
            labels: [
            <c:forEach var="trend" items="${orderTrendAll}">
            '${trend[0]}',
            </c:forEach>
            ],
                    datasets: [{
                    label: 'Total Orders',
                            data: [
            <c:forEach var="trend" items="${orderTrendAll}">
                ${trend[1]},
            </c:forEach>
                            ],
                            backgroundColor: 'rgba(75, 192, 192, 0.6)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 2
                    }]
            };
            var ctx1 = document.getElementById('orderTrendAllChart').getContext('2d');
            var orderTrendAllChart = new Chart(ctx1, {
            type: 'line',
                    data: orderTrendAllData,
                    options: {
                    scales: {
                    y: {
                    beginAtZero: true
                    }
                    }
                    }
            });
            // Biểu đồ Order Trend (Success Orders)
            var orderTrendSuccessData = {
            labels: [
            <c:forEach var="trend" items="${orderTrendSuccess}">
            '${trend[0]}',
            </c:forEach>
            ],
                    datasets: [{
                    label: 'Success Orders',
                            data: [
            <c:forEach var="trend" items="${orderTrendSuccess}">
                ${trend[1]},
            </c:forEach>
                            ],
                            backgroundColor: 'rgba(54, 162, 235, 0.6)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 2
                    }]
            };
            var ctx2 = document.getElementById('orderTrendSuccessChart').getContext('2d');
            var orderTrendSuccessChart = new Chart(ctx2, {
            type: 'line',
                    data: orderTrendSuccessData,
                    options: {
                    scales: {
                    y: {
                    beginAtZero: true
                    }
                    }
                    }
            });
        </script>
    </body>
</html>

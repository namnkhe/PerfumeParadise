<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Marketing Dashboard</title> 
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                display: flex;
                min-height: 100vh; /* Đảm bảo nội dung bao phủ toàn bộ chiều cao màn hình */
            }
            .sidebar {
                background-color: #343a40;
                height: 100vh; /* Đảm bảo sidebar có chiều cao 100% */
                width: 250px;
                position: fixed;
                top: 0;
                left: 0;
                padding-top: 20px;
            }
            .sidebar a {
                color: #fff;
                text-decoration: none;
                padding: 10px;
                display: block;
            }
            .sidebar a:hover {
                background-color: #495057;
                text-decoration: none;
            }
            .main-content {
                margin-left: 250px; /* Tương ứng với chiều rộng sidebar */
                padding: 20px;
                width: calc(100% - 250px); /* Đảm bảo chiều rộng hợp lý */
            }
            .dashboard-card {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px;
                background-color: #ffffff;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            .dashboard-card h5 {
                margin: 0;
            }
        </style>
    </head>
    <body>
        <!-- cainaylacuamktdashboard -->
        <!-- Sidebar -->
        <div class="sidebar">
            <a class="nav-link active" href="admin">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a class="nav-link" href="Admin2">
                <i class="fas fa-box"></i> Product Manager
            </a>
            <a class="nav-link" href="customerList">
                <i class="fas fa-users"></i> Customer Manager
            </a>
            <a class="nav-link" href="blogList">
                <i class="fas fa-blog"></i> Blog Manager
            </a>
            <a class="nav-link" href="SliderController">
                <i class="fas fa-image"></i> Slider Manager
            </a>
            <a class="nav-link" href="FeedBackList">
                <i class="fas fa-comment"></i> Feedback Manager
            </a>
            <a class="nav-link" href="adminlogout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3">
                <h1 class="h2">Marketing Dashboard</h1>
            </div>


            <div class="row">
                <!-- Total Revenue -->
                <div class="col-md-3 mb-4">
                    <div class="dashboard-card">
                        <h5>Total Revenue</h5>
                        <h2>${totalRevenue}$</h2>
                    </div>
                </div>

                <!-- Total Products -->
                <div class="col-md-3 mb-4">
                    <div class="dashboard-card">
                        <h5>Total Products</h5>
                        <h2>${totalProducts}</h2>
                    </div>
                </div>

                <!-- Total Customers -->
                <div class="col-md-3 mb-4">
                    <div class="dashboard-card">
                        <h5>Total Customers</h5>
                        <h2>${totalCustomers}</h2>
                    </div>
                </div>

                <!-- Total Orders -->
                <div class="col-md-3 mb-4">
                    <div class="dashboard-card">
                        <h5>Total Orders</h5>
                        <h2>${totalOrders}</h2>
                    </div>
                </div>

                <!-- Total Posts (Placeholder) -->
                <div class="col-md-3 mb-4">
                    <div class="dashboard-card">
                        <h5>Total Posts</h5>
                        <h2>${totalPosts}</h2>
                    </div>
                </div>

                <!-- Total Feedbacks (Placeholder) -->
                <div class="col-md-3 mb-4">
                    <div class="dashboard-card">
                        <h5>Total Feedbacks</h5>
                        <h2>${totalFeedbacks}</h2>
                    </div>
                </div>
            </div>



            <!-- Revenue and Top Seller Charts -->
            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-header">Recent Sales (Last 7 days)</div>
                        <div class="card-body">
                            <canvas id="revenueChart" style="height: 400px; width: 100%;"></canvas>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-header">Most Sold Items</div>
                        <div class="card-body">
                            <canvas id="topSellerChart" style="height: 400px; width: 100%;"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Scripts -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <script>
                // Revenue Chart Data
                var revenueData = {
                labels: [
                <c:forEach var="sell" items="${sellingRecent}" varStatus="status">
                "${sell.date}"<c:if test="${!status.last}">,</c:if>
                </c:forEach>
                ],
                        datasets: [{
                        label: 'Revenue',
                                data: [
                <c:forEach var="sell" items="${sellingRecent}" varStatus="status">
                    ${sell.totalprice}<c:if test="${!status.last}">,</c:if>
                </c:forEach>
                                ],
                                backgroundColor: 'rgba(54, 162, 235, 0.6)',
                                borderColor: 'rgba(54, 162, 235, 1)',
                                borderWidth: 2
                        }]
                };
                var ctx1 = document.getElementById('revenueChart').getContext('2d');
                var revenueChart = new Chart(ctx1, {
                type: 'bar',
                        data: revenueData,
                        options: {
                        responsive: true,
                                maintainAspectRatio: false,
                                scales: {
                                y: { beginAtZero: true }
                                }
                        }
                });
                // Top Seller Chart Data
                var topSellerData = {
                labels: [
                <c:forEach var="stock" items="${topStock}" varStatus="status">
                "${stock.perfume_name}"<c:if test="${!status.last}">,</c:if>
                </c:forEach>
                ],
                        datasets: [{
                        label: 'Most Sold Items',
                                data: [
                <c:forEach var="stock" items="${topStock}" varStatus="status">
                    ${stock.quantity}<c:if test="${!status.last}">,</c:if>
                </c:forEach>
                                ],
                                backgroundColor: [
                                        'rgba(255, 99, 132, 0.6)', 'rgba(54, 162, 235, 0.6)',
                                        'rgba(255, 206, 86, 0.6)', 'rgba(75, 192, 192, 0.6)',
                                        'rgba(153, 102, 255, 0.6)', 'rgba(255, 159, 64, 0.6)'
                                ],
                                borderColor: [
                                        'rgba(255, 99, 132, 1)', 'rgba(54, 162, 235, 1)',
                                        'rgba(255, 206, 86, 1)', 'rgba(75, 192, 192, 1)',
                                        'rgba(153, 102, 255, 1)', 'rgba(255, 159, 64, 1)'
                                ],
                                borderWidth: 2
                        }]
                };
                var ctx2 = document.getElementById('topSellerChart').getContext('2d');
                var topSellerChart = new Chart(ctx2, {
                type: 'bar',
                        data: topSellerData,
                        options: {
                        responsive: true,
                                maintainAspectRatio: false,
                                scales: {
                                y: { beginAtZero: true }
                                }
                        }
                });
            </script>

    </body>
</html>
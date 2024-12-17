<%-- 
    Document   : newjsp
    Created on : 13 Oct 2024, 22:13:08
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
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
            <a href="FeedBackList" class="nav-link" href="Feed">
                <i class="fas fa-comment"></i> FeedBack Manager
            </a>


            <a class="nav-link" href="adminlogout">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </body>
</html>

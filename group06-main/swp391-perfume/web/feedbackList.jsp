<%@page import="model.Feedback"%>
<%@page import="model.Customer"%>
<%@page import="model.Perfume"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Feedback List</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
            }
            h1 {
                color: #343a40;
                margin-bottom: 20px;
            }
            .table {
                background-color: #fff;
                border-radius: 0.5rem;
            }
            th {
                background-color: #007bff;
                color: black;
            }
            .pagination {
                justify-content: center;
            }
            .form-select {
                width: auto;
                display: inline-block;
            }
            .sidebar {
                min-width: 250px;
                max-width: 250px;
                background-color: #343a40;
                color: white;
                min-height: 100vh;
            }
            .content {
                flex-grow: 1;
                padding: 20px;
            }
            .container-fluid {
                display: flex;
                padding: 0;
            }
            .main-content {
                margin-left: 250px;
                width: calc(100% - 250px);
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <!-- Sidebar -->
            <div class="sidebar">
                <jsp:include page="template/sidebar.jsp" />
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <div class="container mt-5">
                    <h1>Feedback List</h1>

                    <!-- Filter and Search Form -->
                    <form method="get" action="FeedBackList" class="row g-3 mb-4">
                        <div class="col-md-3">
                            <input type="text" class="form-control" name="searchFullName" placeholder="Search by Full Name" value="${searchFullName}">
                        </div>
                        <div class="col-md-3">
                            <input type="text" class="form-control" name="searchByName" placeholder="Search by Product Name" value="${searchByName}">
                        </div>
                        <div class="col-md-3">
                            <input type="number" class="form-control" name="searchByRating" placeholder="Search by Rating (1-5)" value="${searchByRating}">
                        </div>
                        <div class="col-md-3 text-end">
                            <button type="submit" class="btn btn-primary">Filter</button>
                        </div>
                    </form>

                    <table class="table table-bordered table-hover">
                        <thead>
                            <tr>
                                <th>Contact Full Name</th> 
                                <th>Product Name</th>    
                                <th>Rated Star</th>      
                                <th>Status</th>           
                                <th>Action</th>           
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Feedback> feedbackList = (List<Feedback>) request.getAttribute("feedbackList");
                                if (feedbackList != null && !feedbackList.isEmpty()) {
                                    for (Feedback feedback : feedbackList) {
                                        Customer customer = feedback.getCustomer();
                                        Perfume product = feedback.getProduct();
                            %>
                            <tr>
                                <td><%= customer != null ? customer.getUsername(): "N/A" %></td>
                                <td><%= product != null ? product.getName() : "N/A" %></td>
                                <td><%= feedback.getRating() %></td>
                                <td>
                                    <!-- Form auto-submit khi thay đổi trạng thái -->
                                    <form method="post" action="FeedBackList?action=updateStatus" id="form<%= feedback.getId() %>">
                                        <input type="hidden" name="feedbackId" value="<%= feedback.getId() %>">
                                        <select name="status" class="form-select" onchange="autoSubmit('<%= feedback.getId() %>')">
                                            <option value="Pending" <%= "Pending".equals(feedback.getStatus()) ? "selected" : "" %>>Pending</option>
                                            <option value="Confirmed" <%= "Confirmed".equals(feedback.getStatus()) ? "selected" : "" %>>Confirmed</option>
                                            <option value="Rejected" <%= "Rejected".equals(feedback.getStatus()) ? "selected" : "" %>>Rejected</option>
                                        </select>
                                        <input type="hidden" name="searchFullName" value="${searchFullName}">
                                        <input type="hidden" name="searchByName" value="${searchByName}">
                                        <input type="hidden" name="searchByRating" value="${searchByRating}">
                                    </form>
                                </td>
                                <td>
                                    <a href="FeedbackDetails?feedbackId=<%= feedback.getId() %>" class="btn btn-sm btn-info">View</a>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="5" class="text-center">No feedback available.</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Auto submit khi select thay đổi -->
        <script>
            function autoSubmit(feedbackId) {
                document.getElementById('form' + feedbackId).submit();
            }
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
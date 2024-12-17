<%@page import="model.Customer"%>
<%@page import="model.Perfume"%>
<%@page import="model.Feedback"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Feedback Details</title>

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
            .card {
                background-color: #fff;
                border-radius: 0.5rem;
                padding: 20px;
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-2">
                    <jsp:include page="template/sidebar.jsp" />
                </div>

                <!-- Main content -->
                <div class="col-md-9">
                    <h1>Feedback Details</h1>
                    <div class="card">
                        <%
                            Feedback feedback = (Feedback) request.getAttribute("feedback");
                            if (feedback != null) {
                                Customer customer = feedback.getCustomer();
                                Perfume product = feedback.getProduct();
                        %>
                        <form method="post" action="FeedbackDetails">
                            <input type="hidden" name="feedbackId" value="<%= feedback.getId() %>">

                            <div class="row mb-3">
                                <label class="col-sm-2 col-form-label">Full Name:</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" value="<%= customer != null ? customer.getUsername() : "N/A" %>" readonly>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-sm-2 col-form-label">Email:</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" value="<%= customer != null ? customer.getEmail() : "N/A" %>" readonly>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-sm-2 col-form-label">Mobile:</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" value="<%= customer != null ? customer.getPhone() : "N/A" %>" readonly>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-sm-2 col-form-label">Product:</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" value="<%= product != null ? product.getName() : "N/A" %>" readonly>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-sm-2 col-form-label">Rated Star:</label>
                                <div class="col-sm-10">
                                    <input type="number" name="rating" class="form-control" value="<%= feedback.getRating() %>" min="1" max="5" required>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-sm-2 col-form-label">Feedback:</label>
                                <div class="col-sm-10">
                                    <textarea name="comment" class="form-control" rows="4" required><%= feedback.getComment() %></textarea>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-sm-2 col-form-label">Avatar:</label>
                                <div class="col-sm-10">
                                    <%
                                        String avatarPath = customer != null ? customer.getAvatarUrl(): ""; 
                                        if (avatarPath != null && !avatarPath.isEmpty()) {
                                    %>
                                    <img src="<%= avatarPath %>" class="img-thumbnail" alt="Customer Avatar">
                                    <%
                                        } else {
                                    %>
                                    <p>No avatar available.</p>
                                    <%
                                        }
                                    %>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-sm-2 col-form-label">Status:</label>
                                <div class="col-sm-10">
                                    <select name="status" class="form-select">
                                        <option value="Pending" <%= "Pending".equals(feedback.getStatus()) ? "selected" : "" %>>Pending</option>
                                        <option value="Confirmed" <%= "Confirmed".equals(feedback.getStatus()) ? "selected" : "" %>>Confirmed</option>
                                        <option value="Rejected" <%= "Rejected".equals(feedback.getStatus()) ? "selected" : "" %>>Rejected</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-sm-10 offset-sm-2">
                                    <button type="submit" class="btn btn-success">Update Feedback</button>
                                </div>
                            </div>
                        </form>

                        <%
                            } else {
                        %>
                        <p>No feedback details available.</p>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
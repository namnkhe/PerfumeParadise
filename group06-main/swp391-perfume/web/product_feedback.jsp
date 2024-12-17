<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Feedback" %>
<%@ page import="model.Customer" %>
<%@ page import="model.Perfume" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Feedback for Product</title>
        <link rel="stylesheet" href="styles.css"> <!-- Nếu bạn có stylesheet -->
    </head>
    <body>
        <div class="container">
            <h1>Feedback for Product</h1>
            <div class="feedback-list">
                <%
                    ArrayList<Feedback> feedbackList = (ArrayList<Feedback>) request.getAttribute("feedbackList");
                    Perfume product = (Perfume) request.getAttribute("product");

                    if (feedbackList != null && !feedbackList.isEmpty()) {
                        for (Feedback feedback : feedbackList) {
                            Customer customer = feedback.getCustomer();
                %>
                <div class="feedback-item">
                    <div class="customer-info">
                        <img src="<%= customer.getAvatarUrl() %>" alt="Customer Avatar" class="customer-avatar">
                        <h3><%= customer.getUsername() %></h3>
                    </div>
                    <div class="feedback-content">
                        <p><strong>Rating:</strong> <%= feedback.getRating() %> / 5</p>
                        <p><strong>Comment:</strong> <%= feedback.getComment() %></p>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <p>No feedback available for this product.</p>
                <%
                    }
                %>
            </div>
        </div>
    </body>
</html>
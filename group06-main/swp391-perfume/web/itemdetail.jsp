<%@page import="java.util.List"%>
<%@page import="model.Feedback"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${perfume.name}</title> 
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <link href="css/style.css" rel="stylesheet">
        <style>
            .product-container {
                padding: 40px;
            }
            .product-description {
                margin-top: 20px;
            }
            .product-info {
                padding-left: 30px;
            }
            .product-info span {
                display: block;
                margin-bottom: 10px;
                font-size: 16px;
            }
            .product-img img {
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            .footer {
                margin-top: 50px;
            }
            .feedback-container {
                margin-top: 30px;
                max-height: 160px; /* Set max height for 2 feedbacks */
                overflow-y: auto;  /* Enable vertical scroll */
                padding-right: 15px; /* Add padding for scrollbar space */
            }
            .feedback-item {
                border: 1px solid #ddd;
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 10px;
                background-color: #f9f9f9;
            }
            .feedback-item .rating {
                color: #FFD700; /* Gold color for stars */
            }
            .feedback-item img {
                border-radius: 50%;
                width: 40px;
                height: 40px;
                margin-right: 10px;
            }
            .feedback-item strong {
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="template/header2.jsp"/>
        <div class="container-fluid product-container">
            <div class="row">
                <div class="col-md-5 product-img" style="text-align: center;">
                    <img src="images/perfume/${perfume.image}" width="60%" alt="${perfume.name}"/>
                </div>
                <div class="col-md-7 product-info">
                    <span class="name"><strong>${perfume.name}</strong></span>
                    <a href="productfilter?bid=${perfume.brand.id}">${perfume.brand.name}</a><br>
                    <span>Size: ${perfume.size}ml</span>
                    <span>Price: ${perfume.price}$</span>
                    <span>Quantity: ${perfume.availableQuantity}</span>
                    <span>Release Date: ${perfume.releaseDate}</span>
                    <span><strong>Description:</strong> ${perfume.description}</span> 
                    <c:choose>
                        <c:when test="${perfume.availableQuantity > 0}">
                            <a href="addcart?pid=${perfume.id}">
                                <button class="btn btn-outline-success mt-3">Add to Cart</button>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-outline-secondary mt-3" disabled>Out of Stock</button>
                        </c:otherwise>
                    </c:choose>

                    <!-- Display Success Message -->
                    <c:if test="${not empty ms}">
                        <div class="alert alert-success mt-3" role="alert">
                            ${ms}
                        </div>
                    </c:if>

                    <div class="feedback-container">

                        <% List<Feedback> list = (List<Feedback>) request.getAttribute("feedList"); %>

                        <% if (list != null && !list.isEmpty()) { %>
                        <c:forEach var="feedback" items="${feedList}">
                            <div class="feedback-item">
                                <div>
                                    <img src="images/customers/${feedback.customer.image}" alt="User Image">
                                    <strong>${feedback.customer.username}</strong>
                                </div>
                                <div class="rating">
                                    <c:forEach var="i" begin="1" end="5">
                                        <i class="fas fa-star <c:if test='${i <= feedback.rating}'>checked</c:if>'"></i>
                                    </c:forEach>
                                </div>
                                <div>
                                    ${feedback.comment}
                                </div>
                            </div>
                        </c:forEach>
                        <% } else { %>
                        <p>No feedback available for this product.</p>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="template/footer.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Hide the success message after 3 seconds
            setTimeout(function () {
                const alert = document.querySelector('.alert-success');
                if (alert) {
                    alert.style.display = 'none';
                }
            }, 3000);
        </script>
    </body>
</html>
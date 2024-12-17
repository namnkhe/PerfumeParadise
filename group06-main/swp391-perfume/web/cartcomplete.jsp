<%-- 
    Document   : cartcomplete
    Created on : 7 Nov 2024, 15:50:10
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <link href="css/style.css" rel="stylesheet">
        <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    </head>
    <body>

        <header>
            <jsp:include page="template/header2.jsp"/>
        </header>

        <!-- Navigation Arrow Buttons (Placed under the header) -->
        <div class="container-fluid mt-3">
            <div class="d-flex justify-content-start mb-4">
                <!-- Home Button -->
                <a href="home" class="btn btn-outline-primary me-2">
                    <i class="fas fa-arrow-left"></i> Home
                </a>
            </div>
        </div>

        <!-- Adjust container to fluid and stack sections vertically -->
        <div class="container-fluid mt-4">
            <!-- Order Information Section (Full-width, appears on top) -->
            <div class="row g-4">
                <div class="col-12">
                    <div class="card shadow-sm">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0"><b>Order Information</b></h4>
                        </div>
                        <div class="card-body">
                            <!-- Display labels and values in one column as plain text with colored labels -->
                            <div class="row mb-3">
                                <div class="col-4">
                                    <label class="form-label" style="color: #512da8;"><b>Billing Address</b></label>
                                </div>
                                <div class="col-8">
                                    <p class="form-control-plaintext">${o.address}</p>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-4">
                                    <label class="form-label" style="color: #512da8;"><b>Full Name</b></label>
                                </div>
                                <div class="col-8">
                                    <p class="form-control-plaintext">${account.fullname}</p>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-4">
                                    <label class="form-label" style="color: #512da8;"><b>Phone</b></label>
                                </div>
                                <div class="col-8">
                                    <p class="form-control-plaintext">${account.phone}</p>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-4">
                                    <label class="form-label" style="color: #512da8;"><b>Email</b></label>
                                </div>
                                <div class="col-8">
                                    <p class="form-control-plaintext">${account.email}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Spacer for vertical separation -->
                <div class="col-12 mt-4">
                    <!-- Order Details Section (Full-width, appears below Order Information) -->
                    <div class="card shadow-sm">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0"><b>Order Details</b></h4>
                        </div>
                        <div class="card-body">
                            <table class="table table-bordered">
                                <thead class="table-dark">
                                    <tr>
                                        <th scope="col">Image</th>
                                        <th scope="col">Product Name</th>
                                        <th scope="col">Quantity</th>
                                        <th scope="col">Total Price</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:set var="sum" value="${0}"/>
                                    <c:forEach items="${listOD}" var="item">
                                        <tr>
                                            <td>
                                                <img class="img-fluid" src="images/perfume/${item.getPerfume().image}" alt="${item.getPerfume().name}" style="max-width: 100px; height: auto;">
                                            </td>
                                            <td>${item.getPerfume().name}</td>
                                            <td>
                                                <input id="${item.id}q" readonly name="quantity" value="${item.quantity}" type="number"
                                                       class="form-control form-control-sm" />
                                            </td>
                                            <td>
                                                &dollar; ${item.total}
                                                <c:set var="price" value="${item.total}"/> 
                                                <c:set var="sum" value="${sum + price}"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="3" class="text-end"><b>Total:</b></td>
                                        <td><b>&dollar; ${sum}</b></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <footer class="mt-5">
            <jsp:include page="template/footer.jsp"/>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Check-out</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <link href="css/style.css" rel="stylesheet">
        <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
        <script>
            function toggleNewAddressField(selectElement) {
                var newAddressInput = document.getElementById("newAddressInput");

                if (selectElement.value === "other") {
                    newAddressInput.style.display = "block";
                    newAddressInput.required = true;
                } else {
                    newAddressInput.style.display = "none";
                    newAddressInput.required = false;
                    newAddressInput.value = ""; // Clear custom input if another option is selected
                }
            }
        </script>
        <style>
            #backToDropdown {
                font-weight: bold;      /* Makes text stand out */
                padding-left: 8px;      /* Add padding to separate the icon */
                text-decoration: none;  /* Removes underline */
            }
        </style>
    </head>
    <body>

        <header>
            <jsp:include page="template/header2.jsp"/>
        </header>

        <div class="container-fluid p-0">
            <div class="row">
                <!-- Order Details Section (Stretched to the left) -->
                <!-- Edited here: col-lg-8 to give more width to the order details section -->
                <!-- Edited here: Order Details enclosed in a Bootstrap card -->
                <div class="col-lg-6 mb-4">
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
                                    <c:forEach items="${sessionScope.cart}" var="item">
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
                            <div class="text-end mt-3">
                                <a href="viewcart" class="btn btn-secondary">Change Cart</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Order Information Section (Put inside a card) -->
                <!-- Edited here: col-lg-4 to shrink this section and placed inside a Bootstrap card -->
                <div class="col-lg-6 mb-4">
                    <div class="card shadow-sm">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0"><b>Order Information</b></h4>
                        </div>
                        <div class="card-body">
                            <p class="mb-3 text-muted">Complete your purchase by providing your information and your payment method.</p>

                            <form action="checkout" method="post" id="checkoutForm">
                                <!-- Hidden input to store the final address for submission -->


                                <div class="mb-3">
                                    <label for="addressSelect" class="form-label"><b>Billing Address</b></label>
                                    <select id="addressSelect" name="address" class="form-control" onchange="toggleNewAddressField(this)" required>
                                        <c:choose>
                                            <c:when test="${not empty listA}">
                                                <c:forEach items="${listA}" var="a">
                                                    <option value="${a.name}">${a.name}</option>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${account.address}">${account.address}</option>
                                            </c:otherwise>
                                        </c:choose>
                                        <option value="other">Add new address</option>
                                    </select>

                                    <!-- Input for new address, hidden by default -->
                                    <input type="text" id="newAddressInput" name="newAddressInput" class="form-control mt-2" placeholder="Enter a new address" style="display: none;">
                                </div>

                                <div class="mb-3">
                                    <label for="name" class="form-label"><b>Full Name</b></label>
                                    <input type="text" id="name" class="form-control" name="name" value="${account.fullname}" placeholder="Enter your name" required>
                                </div>

                                <div class="mb-3">
                                    <label for="phone" class="form-label"><b>Phone</b></label>
                                    <input type="text" id="phone" class="form-control" name="phone" value="${account.phone}" placeholder="Enter your phone number" required>
                                </div>

                                <div class="mb-3">
                                    <label for="email" class="form-label"><b>Email</b></label>
                                    <input type="email" id="email" class="form-control" name="email" readonly value="${account.email}">
                                </div>

                                <!-- Start of Styled Payment Method Section with Better Spacing and Styling -->
                                <div class="mb-3">
                                    <label class="form-label"><b>Payment Method</b></label>
                                    <div class="card p-3 shadow-sm">
                                        <div class="d-flex justify-content-around">
                                            <div class="me-2">
                                                <input type="radio" class="btn-check" name="paymentMethod" id="cod" value="COD" autocomplete="off" required>
                                                <label class="btn btn-outline-primary btn-lg" for="cod">
                                                    <i class="fas fa-money-bill-wave"></i> Cash on Delivery
                                                </label>
                                            </div>

                                            <div>
                                                <input type="radio" class="btn-check" name="paymentMethod" id="vnpay" value="VNPay" autocomplete="off">
                                                <label class="btn btn-outline-primary btn-lg" for="vnpay">
                                                    <i class="fas fa-credit-card"></i> VNPay
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- End of Styled Payment Method Section -->

                                <button type="submit" class="btn btn-primary btn-block">Submit</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <footer>
            <jsp:include page="template/footer.jsp"/>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

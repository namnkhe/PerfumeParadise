<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="model.Perfume"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Shopping Cart</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <link href="css/style.css" rel="stylesheet">
        <style>
            /* Ensure the entire page takes full height */
            html, body {
                height: 100%;
                margin: 0;
                display: flex;
                flex-direction: column;
            }

            /* Main content container */
            .content {
                flex: 1;
            }

            /* Ensure footer stays at the bottom */
            footer {
                background-color: #dark-color; /* Replace with your desired footer background */
                padding: 1rem;
                text-align: center;
                width: 100%;
            }

            .card {
                margin: 2rem auto;
                padding: 2rem;
                border-radius: 12px;
                background-color: #fff;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }

            .summary {
                background-color: #f0f0f0;
                padding: 1.5rem;
                border-radius: 12px;
            }

            .summary h5 {
                font-weight: bold;
            }

            .btn {
                margin-top: 1rem;
                width: 100%;
            }

            .cart img {
                border-radius: 8px;
            }

            .btn:hover {
                background-color: #28a745;
                color: #fff;
            }

            .title h4 {
                margin-bottom: 1rem;
                font-weight: bold;
                color: #333;
            }

            .align-items-center {
                align-items: center !important;
            }

            .header-row {
                font-weight: bold;
                background-color: #f0f0f0;
                padding: 10px;
                border-bottom: 2px solid #ddd;
                border-radius: 8px;
            }

            .header-row div {
                padding: 5px 0;
            }
        </style>
        <script type="text/javascript">
            function doDelete(id) {
                if (confirm("Are you sure to delete this item")) {
                    window.location = "removecartdetail?id=" + id;
                }
            }

            function increase(id, availableQuantity) {
                var quantity = document.getElementById(id + 'q');
                var qu = parseInt(quantity.value) + 1;
                if (qu <= availableQuantity) {
                    quantity.value = qu;
                    var formq = document.getElementById(id);
                    formq.submit();
                } else {
                    window.alert("Not enough quantity!");
                }
            }

            function decrease(id) {
                var quantity = document.getElementById(id + 'q');
                var q = parseInt(quantity.value) - 1;
                if (q == 0) {
                    doDelete(id);
                } else {
                    quantity.value = q;
                    var formq = document.getElementById(id);
                    formq.submit();
                }
            }

            function validateQuantity(id, availableQuantity) {
                var quantityInput = document.getElementById(id + 'q');
                var requestedQuantity = parseInt(quantityInput.value);

                if (requestedQuantity > availableQuantity) {
                    alert("Số lượng không đủ! Số lượng có sẵn: " + availableQuantity);
                    quantityInput.value = availableQuantity;
                }
            }



        </script>
    </head>
    <body>

        <header>
            <jsp:include page="template/header2.jsp"/>
        </header>
        <!-- Main content area -->
        <div class="content container">
            <div class="card">
                <div class="row">
                    <div class="col-md-8 cart">
                        <div class="title">
                            <h4>Shopping Cart</h4>
                        </div>

                        <!-- Header Row for Product Table -->
                        <div class="row header-row">
                            <div class="col-2">Product</div>
                            <div class="col">Product Name</div>
                            <div class="col text-center">Quantity</div>
                            <div class="col text-right">Total Price</div>
                            <div class="col text-center"></div>
                        </div>

                        <span class="text-danger">${requestScope.ms}</span>
                        <div class="row border-top border-bottom">
                            <!-- Initialize sum variable -->
                            <c:set var="sum" value="${0}"/>
                            <c:forEach items="${sessionScope.cart}" var="item">
                                <div class="row main align-items-center py-3">
                                    <div class="col-2">
                                        <img class="img-fluid" src="images/perfume/${item.getPerfume().image}">
                                    </div>
                                    <div class="col">
                                        <div class="row">${item.getPerfume().name}</div>
                                    </div>
                                    <div class="col d-flex justify-content-between">
                                        <form id="${item.id}" action="updatecartdetail" class="d-flex">
                                            <input name="id" value="${item.id}" type="hidden"/>
                                            <button type="button" class="btn btn-link px-2"
                                                    onclick="decrease('${item.id}');">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                            <!-- Sử dụng availableQuantity thay cho quantity -->
                                            <input id="${item.id}q" name="quantity" value="${item.quantity}" type="number"
                                                   class="form-control form-control-sm text-center" style="width: 60px;" 
                                                   min="1" max="${item.getPerfume().availableQuantity}" 
                                                   oninput="this.value = Math.min(Math.max(1, this.value), ${item.getPerfume().availableQuantity})" 
                                                   onblur="validateQuantity('${item.id}', ${item.getPerfume().availableQuantity})" />

                                            <button type="button" class="btn btn-link px-2"
                                                    onclick="increase('${item.id}', ${item.getPerfume().availableQuantity});">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                        </form>
                                    </div>
                                    <div class="col text-right">&dollar; ${item.total}</div>
                                    <div class="col text-center">
                                        <button class="btn btn-danger px-2" onclick="doDelete('${item.id}')">
                                            &#10005;
                                        </button>
                                    </div>
                                </div>

                                <!-- Update the sum with each item's total price -->
                                <c:set var="sum" value="${sum + item.total}"/>
                            </c:forEach>

                        </div>
                    </div>
                    <div class="col-md-4 summary">
                        <h5>Summary</h5>
                        <div class="row" style="border-top: 1px solid rgba(0,0,0,.1); padding: 2vh 0;">
                            <div class="col">TOTAL PRICE</div>
                            <!-- Display the calculated sum -->
                            <div class="col text-right">&dollar; ${sum}</div>
                        </div>
                        <a href="checkout"><button class="btn btn-success">CHECKOUT</button></a>
                        <a href="home"><button class="btn btn-outline-secondary">BUY MORE</button></a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer section -->
        <footer>
            <jsp:include page="template/footer.jsp"/>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" 
                integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" 
        crossorigin="anonymous"></script>
    </body>
</html>

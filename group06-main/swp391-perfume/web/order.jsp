<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dal.OrderDetailDAO"%>
<%@page import="model.OrderDetail"%>
<%@page import="model.Order"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <link href="css/style.css" rel="stylesheet">
        <script type="text/javascript">
            function doDelete(id, status) {
                if (status == 'confirming' || status == 'denied') {
                    if (confirm("Are you sure to delete this item")) {
                        window.location = "removeorder?id=" + id;
                    }
                } else {
                    window.alert("Your order is confirmed!");
                }
            }
        </script>
    </head>
    <body>
        <!-- Header -->
        <header>
            <jsp:include page="template/header.jsp"/>
        </header>

        <!-- Main Content -->
        <div class="container my-4">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h2 class="mb-0">Order Summary</h2>
                </div>

                <div class="card-body">
                    <span class="text-success">${requestScope.ms}</span>

                    <!-- Order Details Loop -->
                    <% OrderDetailDAO odd = new OrderDetailDAO();
                        request.setAttribute("odd", odd);
                    %>
                    <div id="ordersContainer">
                        <c:forEach items="${orders}" var="o">
                            <div class="card mb-4 product-item"> <!-- Di chuyển class vào đây -->
                                <div class="card-header bg-light">
                                    <div class="row">
                                        <!-- Improved Details Button -->
                                        <div class="col-md-6">
                                            <a href="orderInformations?id=${o.id}" class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-info-circle"></i> View Details
                                            </a>
                                        </div>
                                        <div class="col-md-6 text-md-end">
                                            <button class="btn btn-danger btn-sm" onclick="doDelete('${o.id}', '${o.status}')">
                                                <i class="fas fa-times"></i> Cancel
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <div class="card-body">
                                    <div class="row mb-2">
                                        <div class="col-md-4">
                                            <strong>Address:</strong> ${o.address}
                                        </div>
                                        <div class="col-md-4">
                                            <strong>Order Date:</strong> ${o.orderdate}
                                        </div>
                                        <div class="col-md-4">
                                            <strong>Status:</strong> ${o.status}
                                        </div>
                                    </div>

                                    <!-- Order Products Loop -->
                                    <c:set var="sum" value="${0}"/>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Product</th>
                                                    <th>Quantity</th>
                                                    <th>Total Price</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${odd.getOrderDetailsByOrderID(o.id)}" var="od">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <img class="img-fluid me-2" src="images/perfume/${od.getPerfume().image}" style="max-width: 60px;">
                                                                <span>${od.getPerfume().name}</span>
                                                            </div>
                                                        </td>
                                                        <td>${od.quantity}</td>
                                                        <td>${od.total} $</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${o.status == 'complete'}">
                                                                    <a href="javascript:void(0);" 
                                                                       class="btn btn-primary btn-sm"
                                                                       onclick="openFeedbackModal('${o.id}', '${od.getPerfume().id}')">
                                                                        <i class="fas fa-star"></i> Rate
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a href="javascript:void(0);" 
                                                                       class="btn btn-secondary btn-sm" 
                                                                       style="pointer-events: none;">
                                                                        <i class="fas fa-star"></i> Rate
                                                                    </a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <c:set var="price" value="${od.total}"/> 
                                                        <c:set var="sum" value="${sum + price}"/>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                            <tfoot>
                                                <tr>
                                                    <td colspan="2" class="text-end"><strong>Total:</strong></td>
                                                    <td colspan="2"><strong>${sum} $</strong></td>
                                                </tr>
                                            </tfoot>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Pagination -->
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center" id="pagination"></ul>
                    </nav>
                </div>
            </div>
        </div>

        <!-- Modal Feedback -->
        <div class="modal fade" id="feedbackModal" tabindex="-1" aria-labelledby="feedbackModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="feedbackModalLabel">Rate Product</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="feedbackForm" method="post" action="order">
                            <input type="hidden" name="action" value="feedback">
                            <div class="mb-3">
                                <label for="rating" class="form-label">Rating:</label>
                                <select class="form-select" id="rating" name="rating" required>
                                    <option value="5">5 - Excellent</option>
                                    <option value="4">4 - Good</option>
                                    <option value="3">3 - Average</option>
                                    <option value="2">2 - Poor</option>
                                    <option value="1">1 - Very Bad</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="comment" class="form-label">Comment:</label>
                                <textarea class="form-control" id="comment" name="comment" rows="3" required></textarea>
                            </div>
                            <input type="hidden" id="orderId" name="orderId">
                            <input type="hidden" id="productId" name="productId">
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer>
            <jsp:include page="template/footer.jsp"/>
        </footer>

        <!-- Script to open modal -->
        <script type="text/javascript">
            function openFeedbackModal(orderId, productId) {
                document.getElementById('orderId').value = orderId;
                document.getElementById('productId').value = productId;

                var feedbackModal = new bootstrap.Modal(document.getElementById('feedbackModal'));
                feedbackModal.show();
            }
        </script>
        <script>
            const itemsPerPage = 3; // Số sản phẩm mỗi trang
            const items = document.querySelectorAll('.product-item'); // Lấy tất cả sản phẩm
            const totalItems = items.length; // Tổng số sản phẩm
            const totalPages = Math.ceil(totalItems / itemsPerPage); // Tổng số trang
            let currentPage = 1; // Trang hiện tại

            // Hàm hiển thị sản phẩm theo trang
            function displayItems(page) {
                const startIndex = (page - 1) * itemsPerPage; // Tính chỉ số bắt đầu
                const endIndex = startIndex + itemsPerPage; // Tính chỉ số kết thúc

                // Ẩn tất cả sản phẩm
                items.forEach((item, index) => {
                    item.style.display = (index >= startIndex && index < endIndex) ? 'block' : 'none';
                });
            }

            // Hàm thiết lập phân trang
            function setupPagination() {
                const pagination = document.getElementById('pagination');

                // Tạo các nút phân trang
                for (let i = 1; i <= totalPages; i++) {
                    const li = document.createElement('li');
                    li.className = 'page-item';
                    const a = document.createElement('a');
                    a.className = 'page-link';
                    a.href = '#';
                    a.textContent = i;
                    a.onclick = (e) => {
                        e.preventDefault();
                        currentPage = i; // Cập nhật trang hiện tại
                        displayItems(currentPage); // Hiển thị sản phẩm cho trang hiện tại
                    };
                    li.appendChild(a);
                    pagination.appendChild(li);
                }
            }

            // Hiển thị sản phẩm cho trang đầu tiên và thiết lập phân trang
            displayItems(currentPage);
            setupPagination();
        </script>
    </body>
</html>

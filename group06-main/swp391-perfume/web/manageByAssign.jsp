<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dal.OrderDetailDAO"%>
<%@page import="model.OrderDetail"%>
<%@page import="model.Order"%>
<%@page import="model.Perfume"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <style>
            .order-table th, .order-table td {
                text-align: center;
                vertical-align: middle;
            }
            .status-buttons .btn {
                margin-right: 5px;
            }
            .container-fluid {
                max-width: 1000px;
                margin-top: 20px;
            }
            .table-responsive {
                max-height: 500px;
                overflow-y: auto;
            }
            /* Thêm màu sắc cho từng trạng thái đơn hàng */
            .text-complete {
                color: green;
                font-weight: bold;
            }
            .text-shipping {
                color: blue;
                font-weight: bold;
            }
            .text-preparing {
                color: orange;
                font-weight: bold;
            }
            .text-approved {
                color: purple;
                font-weight: bold;
            }
            .text-packed {
                color: teal;
                font-weight: bold;
            }
            .text-denied {
                color: red;
                font-weight: bold;
            }
            .btn.active {
                background-color: red; /* Màu nền của nút được nhấn */
                color: white; /* Màu chữ của nút được nhấn */
            }
        </style>
        <script type="text/javascript">
            function changeStatus1(id, old_status, new_status) {
                if (old_status === 'denied' || old_status === 'complete') {
                    return;
                }

                if (old_status === 'confirming' && new_status === 'denied') {
                    window.location = "Staffstatuschange?id=" + id + "&new_status=" + new_status;
                    return;
                }
                if (old_status === 'approved' && new_status === 'denied') {
                    window.location = "Staffstatuschange?id=" + id + "&new_status=" + new_status;
                    return;
                }
                if (old_status === 'preparing' && new_status === 'denied') {
                    window.location = "Staffstatuschange?id=" + id + "&new_status=" + new_status;
                    return;
                }
                if (old_status === 'packed' && new_status === 'denied') {
                    window.location = "Staffstatuschange?id=" + id + "&new_status=" + new_status;
                    return;
                }

                if (old_status === 'shipping' && new_status === 'denied') {
                    window.location = "Staffstatuschange?id=" + id + "&new_status=" + new_status;
                    return;
                }
                if (old_status === 'shipping' && new_status === 'complete') {
                    window.location = "Staffstatuschange?id=" + id + "&new_status=" + new_status;
                    return;
                }

                if (new_status === 'approved') {
                    window.location = "Staffstatuschange?id=" + id + "&new_status=" + new_status;
                }
            }

            function deleteOrder(id, event) {
                event.preventDefault();
                if (confirm("Bạn có chắc chắn muốn xóa đơn hàng này không?")) {
                    window.location = "deleteorder?id=" + id;
                }
            }

            // Hàm JavaScript để lọc đơn hàng theo tên khách hàng
            function searchOrders() {
                let input = document.getElementById("searchInput").value.toLowerCase();
                let table = document.getElementById("orderTable");
                let rows = table.getElementsByTagName("tr");

                for (let i = 1; i < rows.length; i++) { // Bỏ qua hàng đầu tiên (header)
                    let customerCell = rows[i].getElementsByTagName("td")[1]; // Cột "Customer" ở vị trí thứ 1
                    if (customerCell) {
                        let customerName = customerCell.textContent || customerCell.innerText;
                        rows[i].style.display = customerName.toLowerCase().includes(input) ? "" : "none";
                    }
                }
            }

            function highlightButton(button) {
                // Lưu trạng thái nút được nhấn vào Local Storage
                localStorage.setItem('activeButton', button.getAttribute('data-status'));

                // Cập nhật trạng thái nút
                updateButtonState();
            }

            // Hàm để cập nhật trạng thái các nút khi tải trang
            function updateButtonState() {
                const activeButton = localStorage.getItem('activeButton');

                // Xóa lớp 'active' khỏi tất cả các nút
                const buttons = document.querySelectorAll('.mb-4 a');
                buttons.forEach(btn => {
                    if (btn.getAttribute('data-status') === activeButton) {
                        btn.classList.add('active');
                    } else {
                        btn.classList.remove('active');
                    }
                });
            }

            // Kiểm tra trạng thái khi tải trang
            window.onload = function () {
                updateButtonState();
            };
        </script>
    </head>
    <body>
        <jsp:include page="template/StaffSideBar.jsp"/>

        <%
            // Tạo đối tượng OrderDetailDAO và lưu vào request
            OrderDetailDAO od = new OrderDetailDAO();
            request.setAttribute("od", od);
        %>

        <div class="container-fluid">
            <h1 class="mb-4">Order Management</h1>

            <!-- Các nút lọc theo trạng thái đơn hàng -->
            <div class="mb-4 btn-group" role="group">
                <a href="Staff" class="btn btn-outline-warning" data-status="all" onclick="highlightButton(this)">All</a>
                <a href="Staffsearchorder?status=confirming" class="btn btn-outline-warning" data-status="confirming" onclick="highlightButton(this)">Confirming</a>
                <a href="Staffsearchorder?status=approved" class="btn btn-outline-warning" data-status="approved" onclick="highlightButton(this)">Approved</a>
                <a href="Staffsearchorder?status=preparing" class="btn btn-outline-warning" data-status="preparing" onclick="highlightButton(this)">Preparing</a>
                <a href="Staffsearchorder?status=packed" class="btn btn-outline-warning" data-status="packed" onclick="highlightButton(this)">Packed</a>
                <a href="Staffsearchorder?status=shipping" class="btn btn-outline-warning" data-status="shipping" onclick="highlightButton(this)">Shipping</a>
            </div>

            <!-- Thanh tìm kiếm -->
            <div class="mb-4">
                <input type="text" id="searchInput" onkeyup="searchOrders()" class="form-control" placeholder="Tìm kiếm theo tên khách hàng...">
            </div>

            <!-- Bảng hiển thị danh sách đơn hàng -->
            <div class="table-responsive">
                <table class="table table-bordered order-table" id="orderTable">
                    <thead class="table-light">
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Address</th>
                            <th>Order Date</th>
                            <th>Order Status</th>
                            <th>Price Total</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${listStaffByOrder}" var="o">
                            <c:set var="sum" value="0"/>
                            <c:forEach items="${od.getOrderDetailsByOrderID(o.id)}" var="item">
                                <c:set var="price" value="${item.total}"/>
                                <c:set var="sum" value="${sum + price}"/>
                            </c:forEach>
                            <tr>
                                <td>${o.id}</td>
                                <td>${o.customer.username}</td>
                                <td>${o.address}</td>
                                <td>${o.orderdate}</td>
                                <td class="text-<c:out value='${o.status}' />">${o.status}</td>
                                <td>${sum}&dollar;</td>
                                <td class="status-dropdown">
                                    <select onchange="changeStatus1(${o.id}, '${o.status}', this.value)" title="Chọn trạng thái đơn hàng" class="form-select">
                                        <!-- Show "Confirming" option if the status is "confirming" -->
                                        <c:if test="${o.status == 'confirming'}">
                                            <option value="confirming" selected>Confirming</option>
                                            <option value="approved">Approved</option>
                                            <option value="denied">Denied</option>
                                        </c:if>

                                        <!-- Show "Shipping" option if status is "approved" -->
                                        <c:if test="${o.status == 'approved'}">
                                            <option value="approved">Approved</option>
                                            <option value="denied">Denied</option>
                                        </c:if>

                                        <!-- Show "Complete" option if status is "shipping" -->
                                        <c:if test="${o.status == 'packed'}">
                                            <option value="packed">Packed</option>
                                            <option value="denied">Denied</option>
                                        </c:if>
                                        <c:if test="${o.status == 'shipping'}">
                                            <option value="complete">Complete</option>
                                            <option value="denied">Denied</option>
                                        </c:if>
                                        <c:if test="${o.status == 'preparing'}">
                                            <option value="denied">Denied</option>
                                        </c:if>


                                    </select>

                                </td>

                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

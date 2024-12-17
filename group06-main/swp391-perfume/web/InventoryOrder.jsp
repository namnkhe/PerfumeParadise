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
            .sidebar {
                position: fixed;
                left: 0;
                top: 0;
                height: 100%;
                width: 200px;
                background-color: #f8f9fa; /* màu nền */
                padding-top: 20px;
                border-right: 1px solid #ddd;
                box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
            }
            .sidebar a {
                display: block;
                padding: 10px 15px;
                color: #333;
                text-decoration: none;
                font-weight: bold;
            }
            .sidebar a:hover {
                background-color: #ddd;
            }
            .btn.active {
                background-color: red; /* Màu nền của nút được nhấn */
                color: white; /* Màu chữ của nút được nhấn */
            }

            .pagination {
                display: flex;
                justify-content: center;
                margin-top: 20px;
            }
            .pagination button {
                margin: 0 5px;
                padding: 5px 10px;
            }
        </style>
        <script type="text/javascript">
            function changeStatus(id, old_status, new_status) {
                if (old_status === 'denied' || old_status === 'complete') {
                    return;
                }

                if (old_status === 'preparing' && new_status === 'packed') {
                    window.location = "inventoryorder?id=" + id + "&new_status=" + new_status;
                    return;
                }
                if (old_status === 'packed' && new_status === 'shipping') {
                    window.location = "inventoryorder?id=" + id + "&new_status=" + new_status;
                    return;
                }

                if (old_status === 'shipping' && new_status === 'denied') {
                    window.location = "inventoryorder?id=" + id + "&new_status=" + new_status;
                    return;
                }
                if (old_status === 'approved' && new_status === 'preparing') {
                    window.location = "inventoryorder?id=" + id + "&new_status=" + new_status;
                    return;
                }

                if (new_status === 'approved') {
                    window.location = "inventoryorder?id=" + id + "&new_status=" + new_status;
                }
            }

            function deleteOrder(id, event) {
                event.preventDefault();
                if (confirm("Bạn có chắc chắn muốn xóa đơn hàng này không?")) {
                    window.location = "deleteorder?id=" + id;
                }
            }
            function searchOrders() {
                // Lấy giá trị từ input
                const searchInput = document.getElementById('searchInput').value.toLowerCase();
                const rows = document.querySelectorAll('.order-table tbody tr');

                rows.forEach(row => {
                    // Lấy các ô cần tìm kiếm (tên khách hàng và trạng thái)
                    const customerName = row.cells[1].textContent.toLowerCase();
                    const orderStatus = row.cells[4].textContent.toLowerCase();

                    // Kiểm tra nếu từ khóa trùng với tên khách hàng hoặc trạng thái
                    if (customerName.includes(searchInput) || orderStatus.includes(searchInput)) {
                        row.style.display = ''; // Hiện hàng
                    } else {
                        row.style.display = 'none'; // Ẩn hàng
                    }
                });
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

        <%
            // Tạo đối tượng OrderDetailDAO và lưu vào request
            OrderDetailDAO od = new OrderDetailDAO();
            request.setAttribute("od", od);
        %>

        <!-- Sidebar -->
        <div class="sidebar">
            <a href="Inventory"><i class="fas fa-home"></i> Dashboard</a>
            <a href="inventoryvieworder"><i class="fas fa-home"></i> Order</a>
            <a href="Inventory"><i class="fas fa-box"></i> Product Manager</a>
            <a href="inventorylogout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>


        <div class="container-fluid">
            <h1 class="mb-4">Order Management</h1>
            <div class="mb-3">
                <input type="text" id="searchInput" onkeyup="searchOrders()" class="form-control" placeholder="Tìm kiếm đơn hàng theo tên khách hàng hoặc trạng thái...">
            </div>
            <!-- Các nút lọc theo trạng thái đơn hàng, chỉ hiển thị các trạng thái đã phê duyệt -->
            <div class="mb-4">
                <a href="inventoryvieworder" class="btn btn-outline-warning" data-status="all" onclick="highlightButton(this)">All</a>
                <a href="insearchorder?status=approved" class="btn btn-outline-warning" data-status="approved" onclick="highlightButton(this)">Approved</a>
                <a href="insearchorder?status=preparing" class="btn btn-outline-warning" data-status="preparing" onclick="highlightButton(this)">Prepare Order</a>
                <a href="insearchorder?status=packed" class="btn btn-outline-warning" data-status="packed" onclick="highlightButton(this)">Packed</a>
                <a href="insearchorder?status=shipping" class="btn btn-outline-warning" data-status="shipping" onclick="highlightButton(this)">Shipping</a>
                <a href="insearchorder?status=denied" class="btn btn-outline-warning" data-status="shipping" onclick="highlightButton(this)">Denied</a>

            </div>



            <div class="table-responsive">
                <table class="table table-bordered order-table">
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
                        <c:forEach items="${adminorders}" var="o">
                            <c:if test="${o.status == 'approved' || o.status == 'denied' || o.status == 'preparing' || o.status == 'packed' || o.status == 'shipping' || o.status == 'complete'}">

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
                                    <td>${o.status}</td>
                                    <td>${sum}&dollar;</td>
                                    <td class="status-dropdown">
                                        <c:choose>
                                            <c:when test="${o.status == 'denied' || o.status == 'complete'}">
                                                <!-- Không hiển thị dropdown và button khi trạng thái là denied hoặc complete -->
                                            </c:when>
                                            <c:otherwise>
                                                <select onchange="changeStatus(${o.id}, '${o.status}', this.value)" title="Chọn trạng thái đơn hàng" class="form-select">
                                                    <!-- Show "Confirming" option if the status is "confirming" -->

                                                    <!-- Show "Shipping" option if status is "approved" -->
                                                    <c:if test="${o.status == 'approved'}">
                                                        <option value="approved">Approved</option>
                                                        <option value="preparing">Preparing</option>
                                                    </c:if>

                                                    <c:if test="${o.status == 'preparing'}">
                                                        <option value="preparing">preparing</option>
                                                        <option value="packed">Packed</option>
                                                    </c:if>
                                                    <c:if test="${o.status == 'packed'}">
                                                        <option value="packed">Packed</option>
                                                        <option value="shipping">Shipping</option>
                                                    </c:if>
                                                    <c:if test="${o.status == 'shipping'}">
                                                        <option value="shipping">Shipping</option>
                                                        <option value="denied">Denied</option>
                                                    </c:if>




                                                </select>

                                            </td>
                                        </c:otherwise>
                                    </c:choose>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="pagination">
                <button id="prev-btn" onclick="changePage(-1)" disabled>Previous</button>
                <span id="page-numbers"></span>
                <button id="next-btn" onclick="changePage(1)">Next</button>
            </div>

        </div>
        <script type="text/javascript">
            const rowsPerPage = 5; // Number of rows per page
            let currentPage = 1;

            function paginate() {
                const rows = document.querySelectorAll('.order-table tbody tr');
                const totalRows = rows.length;
                const totalPages = Math.ceil(totalRows / rowsPerPage);

                // Hide all rows initially
                rows.forEach((row, index) => {
                    row.style.display = 'none';
                });

                // Display only rows for the current page
                const start = (currentPage - 1) * rowsPerPage;
                const end = Math.min(start + rowsPerPage, totalRows);
                for (let i = start; i < end; i++) {
                    rows[i].style.display = '';
                }

                // Update pagination buttons
                document.getElementById('prev-btn').disabled = currentPage === 1;
                document.getElementById('next-btn').disabled = currentPage === totalPages;

                updatePageNumbers(totalPages);
            }

            function changePage(offset) {
                currentPage += offset;
                paginate();
            }

            function updatePageNumbers(totalPages) {
                const pageNumbersContainer = document.getElementById('page-numbers');
                pageNumbersContainer.innerHTML = '';

                for (let i = 1; i <= totalPages; i++) {
                    const pageButton = document.createElement('button');
                    pageButton.innerText = i;
                    pageButton.className = 'page-btn';
                    if (i === currentPage) {
                        pageButton.classList.add('active'); // Highlight the current page
                    }
                    pageButton.addEventListener('click', () => goToPage(i));
                    pageNumbersContainer.appendChild(pageButton);
                }
            }

            function goToPage(page) {
                currentPage = page;
                paginate();
            }

            window.onload = function () {
                paginate();
            };

        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

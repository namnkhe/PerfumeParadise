<%@page import="dal.AdminDAO"%>
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
            function changeStatus(id, old_status, new_status) {
                if (old_status === 'denied' || old_status === 'complete') {
                    return;
                }

                if (old_status === 'confirming' && new_status === 'denied') {
                    window.location = "changeorderstatus?id=" + id + "&new_status=" + new_status;
                    return;
                }
                if (old_status === 'approved' && new_status === 'denied') {
                    window.location = "changeorderstatus?id=" + id + "&new_status=" + new_status;
                    return;
                }
                if (old_status === 'preparing' && new_status === 'denied') {
                    window.location = "changeorderstatus?id=" + id + "&new_status=" + new_status;
                    return;
                }
                if (old_status === 'packed' && new_status === 'denied') {
                    window.location = "changeorderstatus?id=" + id + "&new_status=" + new_status;
                    return;
                }
                if (old_status === 'packed' && new_status === 'shipping') {
                    window.location = "changeorderstatus?id=" + id + "&new_status=" + new_status;
                    return;
                }

                if (old_status === 'shipping' && new_status === 'denied') {
                    window.location = "changeorderstatus?id=" + id + "&new_status=" + new_status;
                    return;
                }
                if (old_status === 'shipping' && new_status === 'complete') {
                    window.location = "changeorderstatus?id=" + id + "&new_status=" + new_status;
                    return;
                }

                if (new_status === 'approved') {
                    window.location = "changeorderstatus?id=" + id + "&new_status=" + new_status;
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
        <div class="sidebar"><jsp:include page="template/adminheader.jsp"/></div>

        <%
            // Tạo đối tượng OrderDetailDAO và lưu vào request
            OrderDetailDAO od = new OrderDetailDAO();
            request.setAttribute("od", od);
            AdminDAO ad = new AdminDAO();
            request.setAttribute("ad", ad);
           
        %>

        <div class="container-fluid">
            <h1 class="mb-4">Order Management</h1>
            <a class="navbar-brand" href="admin"><i class="fas fa-store"></i> Home</a>
            <!-- Các nút lọc theo trạng thái đơn hàng -->

            <div class="mb-4 btn-group" role="group">
                <a href="Salesvieworder" class="btn btn-outline-danger" data-status="all" onclick="highlightButton(this)">All</a>
                <a href="searchorder?status=denied" class="btn btn-outline-danger" data-status="denied" onclick="highlightButton(this)">Denied</a>
                <a href="searchorder?status=confirming" class="btn btn-outline-danger" data-status="confirming" onclick="highlightButton(this)">Confirming</a>
                <a href="searchorder?status=approved" class="btn btn-outline-danger" data-status="approved" onclick="highlightButton(this)">Approved</a>
                <a href="searchorder?status=preparing" class="btn btn-outline-danger" data-status="preparing" onclick="highlightButton(this)">Preparing</a>
                <a href="searchorder?status=packed" class="btn btn-outline-danger" data-status="packed" onclick="highlightButton(this)">Packed</a>
                <a href="searchorder?status=shipping" class="btn btn-outline-danger" data-status="shipping" onclick="highlightButton(this)">Shipping</a>
                <a href="searchorder?status=complete" class="btn btn-outline-danger" data-status="complete" onclick="highlightButton(this)">Complete</a>
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
                            <th>#</th>
                            <th>Details</th>
                            <th>Customer</th>
                            <th>Address</th>
                            <th>Order Date</th>
                            <th>Order Status</th>
                            <th>Price Total</th>
                            <th class="ActionAssign" >Actions</th>
                            <th class="ActionAssign">Staff</th>
                            <th class="ActionAssignStaff" >Assign</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${adminorders}" var="o" varStatus="status">
                            <c:set var="sum" value="0"/>
                            <c:set var="staffName" value=""/>
                            <c:set var="numOrder" value=""/>


                            <c:forEach items="${od.getOrderDetailsByOrderID(o.id)}" var="item">
                                <c:set var="price" value="${item.total}"/>
                                <c:set var="sum" value="${sum + price}"/>
                                <c:set var="staffID" value="${item.staffID}"/>
                                <c:set var="staffName" value="${ad.getStaffNameById(staffID)}"/>
                                <c:set var="numOrder" value="${od.getNumberOfOrderStaff(staffID)}"/>

                            </c:forEach>
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>
                                    <a href="orderDetails?orderId=${o.id}" class="btn btn-primary btn-sm">
                                        <i class="fas fa-info-circle"></i>
                                    </a>
                                </td>
                                <td>${o.customer.username}</td>
                                <td>${o.address}</td>
                                <td>${o.orderdate}</td>
                                <td class="text-<c:out value='${o.status}' />">${o.status}</td>
                                <td>${sum}&dollar;</td>
                                <td class="status-dropdown">
                                    <c:choose>
                                        <c:when test="${o.status == 'denied' || o.status == 'complete'}">
                                            <!-- Không hiển thị dropdown và button khi trạng thái là denied hoặc complete -->
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Hiển thị dropdown và button cho các trạng thái khác -->
                                            <select onchange="changeStatus(${o.id}, '${o.status}', this.value)" title="Chọn trạng thái đơn hàng" class="form-select">
                                                <c:choose>
                                                    <c:when test="${o.status == 'confirming'}">
                                                        <option value="confirming" selected>Confirming</option>
                                                        <option value="approved">Approved</option>
                                                        <option value="denied">Denied</option>
                                                    </c:when>
                                                    <c:when test="${o.status == 'approved'}">
                                                        <option value="approved" selected>Approved</option>
                                                        <option value="denied">Denied</option>
                                                    </c:when>
                                                    <c:when test="${o.status == 'packed'}">
                                                        <option value="packed" selected>Packed</option>
                                                        <option value="shipping">Shipping</option>
                                                        <option value="denied">Denied</option>
                                                    </c:when>
                                                    <c:when test="${o.status == 'shipping'}">
                                                        <option value="shipping" selected>Shipping</option>
                                                        <option value="complete">Complete</option>
                                                        <option value="denied">Denied</option>
                                                    </c:when>
                                                    <c:when test="${o.status == 'preparing'}">
                                                        <option value="denied">Denied</option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <!-- Default option if none match -->
                                                        <option value="">Select Status</option>
                                                    </c:otherwise>
                                                </c:choose>
                                            </select>

                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${numOrder > 0}">
                                        <c:out value="${staffName}"/>

                                    </c:if>
                                </td>
                                <td>

                                    <form action="Staff" method="post" class="d-inline"> <!-- Form for assigning staff -->
                                        <input type="hidden" name="orderId" value="${o.id}" /> <!-- Order ID -->
                                        <c:choose>
                                            <c:when test="${o.status == 'denied' || o.status == 'complete'}">
                                                <span></span>
                                            </c:when>
                                            <c:otherwise>
                                                <select name="staffId" class="form-select" required style="display: inline-block">
                                                    <c:forEach var="staff" items="${staffList}">
                                                        <c:set var="numOrderStaff" value="${od.getNumberOfOrderStaff(staff.id)}"/>
                                                        <option value="${staff.id}">${staff.username} (${numOrderStaff}) </option>
                                                    </c:forEach>
                                                </select>
                                                </select>
                                                <button type="submit" class="btn btn-warning btn-sm ms-2">Assign</button> <!-- Assign button -->
                                            </c:otherwise>
                                        </c:choose>                            
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        <script type="text/javascript">
            let currentPage = 1; // Trang hiện tại
            const rowsPerPage = 6; // Số lượng hàng trên mỗi trang
            let totalRows = 0; // Tổng số hàng
            let totalPages = 0; // Tổng số trang

            function paginate() {
                const table = document.getElementById("orderTable");
                const rows = table.getElementsByTagName("tr");
                totalRows = rows.length - 1; // Bỏ qua hàng tiêu đề
                totalPages = Math.ceil(totalRows / rowsPerPage);

                // Ẩn tất cả các hàng trước
                for (let i = 1; i < rows.length; i++) {
                    rows[i].style.display = "none";
                }

                // Hiển thị hàng trên trang hiện tại
                const start = (currentPage - 1) * rowsPerPage + 1;
                const end = Math.min(start + rowsPerPage - 1, totalRows);
                for (let i = start; i <= end; i++) {
                    rows[i].style.display = ""; // Hiển thị các hàng của trang hiện tại
                }

                // Cập nhật các nút phân trang
                updatePagination();
            }

            function updatePagination() {
                const pagination = document.getElementById("pagination");
                pagination.innerHTML = ""; // Xóa các nút phân trang cũ

                // Tạo các nút phân trang động
                for (let i = 1; i <= totalPages; i++) {
                    const button = document.createElement("button");
                    button.innerText = i;
                    button.classList.add("btn", "btn-secondary", "m-1");
                    button.disabled = (i === currentPage); // Vô hiệu hóa nút trang hiện tại
                    button.onclick = function () {
                        currentPage = i; // Cập nhật trang hiện tại
                        paginate(); // Gọi hàm phân trang để hiển thị dữ liệu mới
                    };
                    pagination.appendChild(button);
                }
            }

            // Hàm gọi phân trang sau khi tải trang
            window.onload = function () {
                const table = document.getElementById("orderTable");
                const rows = table.getElementsByTagName("tr");

                // Tính toán số trang ngay khi trang được tải
                totalRows = rows.length - 1; // Loại bỏ hàng tiêu đề
                totalPages = Math.ceil(totalRows / rowsPerPage); // Tính số trang

                // Gọi phân trang để ẩn các hàng và chỉ hiển thị hàng cho trang hiện tại
                paginate();
            };
        </script>


        <!-- Phân trang -->
        <!-- Pagination -->

        <div class="my-4 d-flex justify-content-center" id="pagination"></div>

    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

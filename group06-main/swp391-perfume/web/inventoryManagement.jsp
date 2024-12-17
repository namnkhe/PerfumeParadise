<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <style>
            body {
                display: flex;
            }
            .sidebar {
                background-color: #343a40;
                height: 100vh;
                width: 230px;
                position: fixed;
                top: 0;
                left: 0;
                padding-top: 20px;
            }
            .sidebar a {
                color: #fff;
                text-decoration: none;
                display: block;
                padding: 10px;
            }
            .sidebar a:hover {
                background-color: #495057;
            }
            .content {
                margin-left: 250px;
                padding: 20px;
                width: calc(100% - 250px);
            }
            .table th, .table td {
                vertical-align: middle;
            }
            .img-thumbnail {
                max-width: 40px;
            }
            .actions-btn {
                display: flex;
                gap: 10px;
            }
            .search-bar {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                justify-content: space-between;
                align-items: center;
            }
            .search-bar div {
                flex: 1;
                min-width: 150px;
            }
            .input-group {
                display: flex;
                align-items: center;
            }
            .input-group input {
                width: 100%;
            }
        </style>
    </head>
    <body>

        <!-- Sidebar -->
        <div class="sidebar">
            <a href="Inventory"><i class="fas fa-home"></i> Dashboard</a>
            <a href="inventoryvieworder"><i class="fas fa-home"></i> Order</a>
            <a href="Inventory"><i class="fas fa-box"></i> Product Manager</a>
            <a href="inventorylogout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>

        <!-- Main content -->
        <div class="content">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3">
                <h1 class="h2">Product List</h1>
                <a href="inventoryaddperfume" class="btn btn-success">Add New Product</a>
            </div>

            <!-- Product Table -->
            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Thumbnail</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Listed Price</th>
                        <th>Quantity</th>
                        <th>Hold</th>
                        <th>Available Quantity</th>
                        <th>Import Price</th>
                        <th>Brand</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="productTableBody">
                    <c:forEach items="${sessionScope.listP}" var="item">
                        <tr>
                            <td>${item.id}</td>
                            <td><img src="images/perfume/${item.image}" class="img-thumbnail" alt="${item.name}"></td>
                            <td>${item.name}</td>
                            <td>${item.category.name}</td>
                            <td>${item.price}$</td>
                            <td>${item.quantity}</td>
                            <td>${item.hold}</td>
                            <td>${item.quantity - item.hold}</td> <!-- Available Quantity -->
                            <td>${item.importPrice}$</td>
                            <td>${item.brand.name}</td>
                            <td class="actions-btn">
                                <a href="inventoryupdate?id=${item.id}" class="btn btn-warning btn-sm">View Detail</a>
                                <button class="btn btn-info btn-sm" onclick="showImportModal('${item.id}', '${item.name}')">Import</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Pagination -->
            <div id="pagination" class="d-flex justify-content-center mt-3">
                <button id="prevPage" class="btn btn-secondary" onclick="changePage(-1)">Previous</button>
                <span id="pageInfo" class="mx-3"></span>
                <div id="pageNumbers" class="mx-3"></div> <!-- Nơi để hiển thị số trang -->
                <button id="nextPage" class="btn btn-secondary" onclick="changePage(1)">Next</button>
            </div>

            <!-- Import Modal -->
            <div class="modal fade" id="importModal" tabindex="-1" aria-labelledby="importModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="importModalLabel">Import Product</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form id="importForm">
                                <input type="hidden" id="importProductId" name="productId">
                                <div class="mb-3">
                                    <label for="importPrice" class="form-label">Import Price</label>
                                    <input type="number" class="form-control" id="importPrice" name="importPrice" required>
                                </div>
                                <div class="mb-3">
                                    <label for="importSize" class="form-label">Size</label>
                                    <input type="text" class="form-control" id="importSize" name="size" required>
                                </div>
                                <div class="mb-3">
                                    <label for="importQuantity" class="form-label">Quantity</label>
                                    <input type="number" class="form-control" id="importQuantity" name="quantity" required>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="button" class="btn btn-primary" onclick="submitImport()">Import</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Scripts -->
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
            <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
            <script>
                                let currentPage = 1;
                                const itemsPerPage = 6; // Số sản phẩm hiển thị trên mỗi trang
                                const items = document.querySelectorAll('#productTableBody tr'); // Lấy tất cả hàng trong bảng
                                const totalPages = Math.ceil(items.length / itemsPerPage); // Tính tổng số trang

                                function displayPageNumbers() {
                                    const pageNumbersContainer = document.getElementById('pageNumbers');
                                    pageNumbersContainer.innerHTML = ''; // Xóa nội dung hiện tại

                                    for (let i = 1; i <= totalPages; i++) {
                                        const pageButton = document.createElement('button');
                                        pageButton.innerText = i;
                                        pageButton.className = 'btn btn-secondary mx-1'; // Định dạng nút
                                        pageButton.onclick = function () {
                                            currentPage = i; // Cập nhật trang hiện tại
                                            displayItems(); // Hiển thị lại sản phẩm
                                            displayPageNumbers(); // Cập nhật số trang
                                        };
                                        pageNumbersContainer.appendChild(pageButton); // Thêm nút vào container
                                    }
                                }

                                function displayItems() {
                                    // Ẩn tất cả sản phẩm
                                    items.forEach((item, index) => {
                                        item.style.display = 'none'; // Ẩn tất cả các hàng
                                    });
                                    // Hiển thị sản phẩm của trang hiện tại
                                    const start = (currentPage - 1) * itemsPerPage;
                                    const end = start + itemsPerPage;
                                    for (let i = start; i < end && i < items.length; i++) {
                                        items[i].style.display = ''; // Hiển thị hàng tương ứng
                                    }
                                    // Cập nhật thông tin trang
                                    document.getElementById('pageInfo').innerText = `Page ${currentPage} of ${totalPages}`;
                                }

                                function changePage(direction) {
                                    currentPage += direction; // Cập nhật trang hiện tại
                                    if (currentPage < 1)
                                        currentPage = 1; // Giới hạn trang
                                    if (currentPage > totalPages)
                                        currentPage = totalPages; // Giới hạn trang
                                    displayItems(); // Hiển thị lại sản phẩm
                                    displayPageNumbers(); // Cập nhật số trang
                                }

                                function showImportModal(productId, productName) {
                                    document.getElementById('importProductId').value = productId; // Cập nhật ID sản phẩm
                                    $('#importModal').modal('show'); // Hiển thị modal
                                }

                                function submitImport() {
                                    const productId = document.getElementById('importProductId').value;
                                    const importPrice = document.getElementById('importPrice').value;
                                    const size = document.getElementById('importSize').value;
                                    const quantity = document.getElementById('importQuantity').value;
                                    console.log("Product ID:", productId);
                                    console.log("Import Price:", importPrice);
                                    console.log("Size:", size);
                                    console.log("Quantity:", quantity);
                                    // Gửi thông tin nhập hàng đến server
                                    $.ajax({
                                        url: 'importPerfume',
                                        type: 'POST',
                                        data: {
                                            productId: productId,
                                            importPrice: importPrice,
                                            size: size,
                                            quantity: quantity
                                        },
                                        success: function (response) {
                                            $('#alertContainer').html('<div class="alert alert-success">Nhập hàng thành công!</div>'); // Hiển thị thông báo thành công
                                            setTimeout(() => location.reload(), 2000); // Tải lại trang sau 2 giây
                                        },
                                        error: function (error) {
                                            $('#alertContainer').html('<div class="alert alert-danger">Có lỗi xảy ra khi nhập hàng!</div>'); // Hiển thị thông báo lỗi
                                            console.error('Error importing product:', error);
                                        }
                                    });
                                }
                                $(document).ready(function () {
                                    displayItems(); // Hiển thị sản phẩm khi trang được tải
                                    displayPageNumbers(); // Hiển thị số trang khi trang được tải
                                });
            </script>
    </body>
</html>

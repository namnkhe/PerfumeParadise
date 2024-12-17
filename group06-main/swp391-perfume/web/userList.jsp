<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
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
            .actions {
                gap: 10px;
                max-width: 29px;
            }
            .action-col {
                max-width: 26px;
            }
        </style>
    </head>
    <body>

        <!-- Sidebar -->
        <jsp:include page="template/sidebar2.jsp" />

        <!-- Main content -->
        <div class="content">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3">
                <h1 class="h2">Admin List</h1>
                <a href="#" class="btn btn-success" onclick="openAddAdminModal()">Add New Admin</a>
            </div>

            <div class="row mb-4">
                <div class="col-md-12">
                    <form id="search-form" method="get" action="StaffController">
                        <input type="hidden" name="service" value="search">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label for="username">Username</label>
                                <input type="text" class="form-control" id="username" name="username" placeholder="Enter username">
                            </div>
                            <div class="col-md-3">
                                <label for="role">Role</label>
                                <select class="form-control" id="role" name="role">
                                    <option value="All">All</option>
                                    <option value="0">Marketer</option>
                                    <option value="1">Admin</option>
                                    <option value="2">Sale</option>
                                    <option value="3">Inventory</option>
                                    <option value="4">Staff</option>
                                </select>
                            </div>
                        </div>
                        <div class="row mt-2">
                            <div class="col-md-12">
                                <button type="submit" class="btn btn-primary">Search</button>
                                <a href="StaffController" class="btn btn-secondary">Reset</a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Admin Table -->
            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th class="action-col">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${adminList}" var="admin">
                        <tr>
                            <td>${admin.id}</td>
                            <td>${admin.username}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${admin.role == 0}">Marketer</c:when>
                                    <c:when test="${admin.role == 1}">Admin</c:when>
                                    <c:when test="${admin.role == 2}">Sale</c:when>
                                    <c:when test="${admin.role == 3}">Inventory</c:when>
                                    <c:when test="${admin.role == 4}">Staff</c:when>
                                </c:choose>
                            </td>
                            <td class="actions">
                                <button class="btn btn-warning btn-sm" 
                                        onclick="openUpdateAdminModal(${admin.id}, '${admin.username}', ${admin.role})">
                                    Update
                                </button>
                                <a href="StaffController?id=${admin.id}&service=delete" class="btn btn-danger btn-sm">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Update Admin Modal -->
        <div class="modal fade" id="updateAdminModal" tabindex="-1" aria-labelledby="updateAdminModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="updateAdminModalLabel">Update Admin</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="updateAdminForm" method="post" action="StaffController?service=update">
                            <input type="hidden" id="adminId" name="id">
                            <div class="mb-3">
                                <label for="adminUsername" class="form-label">Username:</label>
                                <input type="text" class="form-control" id="adminUsername" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="adminRole" class="form-label">Role:</label>
                                <select class="form-select" id="adminRole" name="role" required>
                                    <option value="0">Makerter</option>
                                    <option value="1">Admin</option>
                                    <option value="2">Sale</option>
                                    <option value="3">Inventory</option>
                                    <option value="4">Staff</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary">Update</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add Admin Modal -->
        <div class="modal fade" id="addAdminModal" tabindex="-1" aria-labelledby="addAdminModalLabel" aria-hidden="true" 
             <c:if test="${not empty errorMessage}">
                 <script>
                 var addModal = new bootstrap.Modal(document.getElementById('addAdminModal'));
                 addModal.show();
             </script>
        </c:if>
        >
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addAdminModalLabel">Add Staff</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">
                            ${errorMessage}
                        </div>
                    </c:if>
                    <form id="addAdminForm" method="post" action="StaffController">
                        <input type="hidden" name="service" value="addAdmin">
                        <div class="mb-3">
                            <label for="newAdminUsername" class="form-label">Username:</label>
                            <input type="text" class="form-control" id="newAdminUsername" name="username" 
                                   value="${not empty username ? username : ''}" required>
                        </div>
                        <div class="mb-3">
                            <label for="newAdminPassword" class="form-label">Password:</label>
                            <input type="password" class="form-control" id="newAdminPassword" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label for="newAdminRole" class="form-label">Role:</label>
                            <select class="form-select" id="newAdminRole" name="role" required>
                                <option value="0" ${role == '0' ? 'selected' : ''}>Marketer</option>
                                <option value="1" ${role == '1' ? 'selected' : ''}>Admin</option>
                                <option value="2" ${role == '2' ? 'selected' : ''}>Sale</option>
                                <option value="3" ${role == '3' ? 'selected' : ''}>Inventory</option>
                                <option value="4" ${role == '4' ? 'selected' : ''}>Staff</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-success">Add Staff</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
                                            function openUpdateAdminModal(adminId, username, role) {
                                                // Populate the modal fields with admin data
                                                document.getElementById('adminId').value = adminId;
                                                document.getElementById('adminUsername').value = username;
                                                document.getElementById('adminRole').value = role; // Set the selected role

                                                // Show the update admin modal
                                                var updateModal = new bootstrap.Modal(document.getElementById('updateAdminModal'));
                                                updateModal.show();
                                            }

                                            function openAddAdminModal() {
                                                // Show the add admin modal
                                                var addModal = new bootstrap.Modal(document.getElementById('addAdminModal'));
                                                addModal.show();
                                            }
        <c:if test="${not empty errorMessage}">
                                            var addModal = new bootstrap.Modal(document.getElementById('addAdminModal'));
                                            addModal.show();
        </c:if>
    </script>

</body>
</html>
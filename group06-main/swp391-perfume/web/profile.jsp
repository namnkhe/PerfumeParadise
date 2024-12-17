<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Profile - Perfume Paradise</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&display=swap" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet"> <!-- Ensure path is correct -->
        <style>
            body, html {
                background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
            }
            .container {
                max-width: 900px;
                margin: 30px auto;
                padding: 20px;
            }
            .profile-card {
                border: none;
                border-radius: 15px;
                padding: 30px;
                background-color: #fff;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                transition: transform 0.2s;
            }
            .profile-card:hover {
                transform: translateY(-5px);
            }
            .profile-avatar {
                width: 150px;
                height: 150px;
                object-fit: cover;
                border-radius: 50%;
                border: 4px solid #512da8;
                margin-top: -75px;
                background-color: #fff;
            }
            h1 {
                font-family: 'Dancing Script', cursive;
                font-size: 3rem;
                color: #512da8;
            }
            .btn-primary, .btn-success {
                background: linear-gradient(135deg, #ff4b2b, #ff416c);
                border: none;
                color: #fff;
                font-weight: bold;
                transition: background 0.3s ease;
            }
            .btn-primary:hover, .btn-success:hover {
                background: linear-gradient(135deg, #ff416c, #ff4b2b);
            }
            .btn-close {
                font-size: 1.2rem;
            }
            .modal-content {
                border-radius: 15px;
                padding: 20px;
            }
            .modal-body {
                text-align: center;
            }
            .modal-body input[type="file"], .modal-body input[type="password"] {
                margin: 10px 0;
                padding: 10px;
                font-size: 1rem;
            }
            .form-label {
                font-weight: 500;
                color: #512da8;
            }
            .alert-info {
                background-color: #cce5ff;
                color: #004085;
                border-color: #b8daff;
            }
            .form-select {
                color: #6c757d;
            }
        </style>
    </head>
    <body>
        <header><jsp:include page="template/header2.jsp"/></header>

        <div class="container">
            <h1 class="text-center mb-4">Profile</h1>

            <c:if test="${not empty mess}">
                <div class="alert alert-info text-center">${mess}</div>
            </c:if>

            <div class="row">
                <div class="col-md-4 text-center">
                    <div class="profile-card">
                        <img src="${account.avatarUrl}" alt="Avatar" class="profile-avatar">
                        <h3 class="mt-3">${account.fullname}</h3>
                        <button class="btn btn-primary mt-3" data-bs-toggle="modal" data-bs-target="#changeAvatarModal">Change Avatar</button>
                    </div>
                </div>
                <div class="col-md-8">
                    <form action="profile" method="post" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label for="name" class="form-label">Full Name</label>
                            <input type="text" class="form-control" name="name" value="${account.fullname}" required>
                        </div>
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" name="username" value="${account.username}" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" name="email" value="${account.email}" required>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">Phone</label>
                            <input type="text" class="form-control" name="phone" value="${account.phone}" required>
                        </div>
                        <div class="mb-3">
                            <label for="address" class="form-label">Address</label>
                            <input type="text" class="form-control" name="address" value="${account.address}" required>
                        </div>
                        <div class="mb-3">
                            <label for="gender" class="form-label">Gender</label>
                            <select class="form-select" name="gender" required>
                                <option value="Male" <c:if test="${account.gender == 'Male'}">selected</c:if>>Male</option>
                                <option value="Female" <c:if test="${account.gender == 'Female'}">selected</c:if>>Female</option>
                                <option value="Other" <c:if test="${account.gender == 'Other'}">selected</c:if>>Other</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-success w-100">Save Changes</button>
                            <!-- Reset Password Button -->
                            <button type="button" class="btn btn-secondary w-100 mt-3" data-bs-toggle="modal" data-bs-target="#resetPasswordModal">Reset Password</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Modal for Change Avatar -->
            <div class="modal fade" id="changeAvatarModal" tabindex="-1" aria-labelledby="changeAvatarModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="changeAvatarModalLabel">Change Avatar</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form action="uploadAvatar" method="post" enctype="multipart/form-data">
                            <div class="modal-body">
                                <input type="file" name="avatar" accept="image/*" required class="form-control">
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Upload Avatar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Modal for Reset Password -->
            <div class="modal fade" id="resetPasswordModal" tabindex="-1" aria-labelledby="resetPasswordModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="resetPasswordModalLabel">Reset Password</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form action="resetPassword" method="post">
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="currentPassword" class="form-label">Current Password</label>
                                    <input type="password" class="form-control" name="currentPassword" required>
                                </div>
                                <div class="mb-3">
                                    <label for="newPassword" class="form-label">New Password</label>
                                    <input type="password" class="form-control" name="newPassword" required>
                                </div>
                                <div class="mb-3">
                                    <label for="confirmNewPassword" class="form-label">Confirm New Password</label>
                                    <input type="password" class="form-control" name="confirmNewPassword" required>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Reset Password</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <footer>
            <jsp:include page="template/footer.jsp" />
        </footer>


    </body>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</html>

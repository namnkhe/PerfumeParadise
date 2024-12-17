<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Customer Information</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <style>
            body {
                display: flex;
                min-height: 100vh;
                flex-direction: column;
                background-color: #f8f9fa;
                font-family: Arial, sans-serif;
            }
            .content {
                margin-left: 250px;
                padding: 40px;
                width: calc(100% - 250px);
                max-width: 800px;
                margin: 40px auto;
            }
            .update-form {
                box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.2);
                padding: 40px;
                border-radius: 15px;
                background: #ffffff;
            }
            .update-form h3 {
                margin-bottom: 30px;
                color: #333;
                text-align: center;
            }
            .btn-back {
                margin-top: 20px;
            }
            .btn-success {
                width: 100%;
                padding: 12px;
                font-size: 1.1rem;
                border-radius: 8px;
            }
            .btn-back {
                width: 100%;
                padding: 12px;
                margin-top: 15px;
                font-size: 1.1rem;
                border-radius: 8px;
            }
            .form-label {
                font-weight: 600;
                color: #555;
            }
            .update-form .form-control, .update-form .form-select {
                height: 45px;
                font-size: 1rem;
                padding: 10px;
                border-radius: 8px;
                border: 1px solid #ced4da;
            }
            .update-form .form-control:focus, .update-form .form-select:focus {
                box-shadow: 0px 0px 5px rgba(0, 123, 255, 0.5);
                border-color: #80bdff;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <jsp:include page="template/sidebar.jsp" />

        <!-- Main content -->
        <div class="content">
            <h2 class="text-center mb-4">Update Customer</h2>

            <c:if test="${not empty c}">
                <form action="updateCustomer" method="post" class="update-form">
                    <h3>Update Customer Information</h3>
                    <input type="hidden" name="id" value="${c.id}">
                    <div class="mb-4">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" class="form-control" id="username" name="username" value="${c.username}" required>
                    </div>
                    <div class="mb-4">
                        <label for="fullname" class="form-label">Full Name</label>
                        <input type="text" class="form-control" id="fullname" name="fullname" value="${c.fullname}" required>
                    </div>
                    <div class="mb-4">
                        <label for="gender" class="form-label">Gender</label>
                        <select class="form-select" id="gender" name="gender" required>
                            <option value="Male" <c:if test="${c.gender == 'Male'}">selected</c:if>>Male</option>
                            <option value="Female" <c:if test="${c.gender == 'Female'}">selected</c:if>>Female</option>
                            <option value="Other" <c:if test="${c.gender == 'Other'}">selected</c:if>>Other</option>
                            </select>
                        </div>
                        <div class="mb-4">
                            <label for="phone" class="form-label">Phone</label>
                            <input type="text" class="form-control" id="phone" name="phone" value="${c.phone}" required>
                    </div>
                    <div class="mb-4">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" value="${c.email}" required>
                    </div>
                    <div class="mb-4">
                        <label for="address" class="form-label">Address</label>
                        <input type="text" class="form-control" id="address" name="address" value="${c.address}" required>
                    </div>
                    <button type="submit" class="btn btn-success"><i class="fas fa-save"></i> Save Changes</button>
                    <a href="customerManager" class="btn btn-primary btn-back"><i class="fas fa-arrow-left"></i> Back to Customer List</a>
                </form>
            </c:if>
            <c:if test="${empty c}">
                <div class="no-data text-center">
                    <p>No customer information available to update.</p>
                    <a href="customerManager" class="btn btn-primary btn-back"><i class="fas fa-arrow-left"></i> Back to Customer List</a>
                </div>
            </c:if>
        </div>
    </body>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</html>

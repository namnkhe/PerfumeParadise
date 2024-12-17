<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Staff Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <link href="css/style.css" rel="stylesheet">
        <style>
            .btn-lg {
                font-size: 1.25rem;
                padding: .5rem 1rem;
            }
            .table th, .table td {
                vertical-align: middle;
            }
            .table-responsive {
                margin-top: 1rem;
            }
        </style>
        <script type="text/javascript">
            function doDelete(username) {
                if (confirm("Are you sure you want to delete this account?")) {
                    window.location = "deletestaff?username=" + username;
                }
            }
            function promote(username) {
                if (confirm("Are you sure you want to promote " + username + "?")) {
                    window.location = "promotestaff?username=" + username;
                }
            }
        </script>
    </head>
    <body>
        <jsp:include page="template/adminheader.jsp"/>
        <div class="container mt-4">
            <div class="card shadow-lg border-0">
                <div class="card-header bg-primary text-white">
                    <h1 class="h3 mb-0">Staff Management</h1>
                </div>
                <div class="card-body">
                    <a href="createstaff" class="btn btn-primary btn-lg mb-3">Create Staff</a>
                    <c:if test="${not empty requestScope.ms}">
                        <div class="alert alert-info">${requestScope.ms}</div>
                    </c:if>
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead class="thead-light">
                                <tr>
                                    <th>Actions</th>
                                    <th>Username</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${requestScope.staffs}" var="s">
                                    <tr>
                                        <td>
                                            <button class="btn btn-danger btn-lg" onclick="doDelete('${s.username}')">
                                                <i class="fas fa-trash-alt"></i> Delete
                                            </button>
                                            <button class="btn btn-success btn-lg" onclick="promote('${s.username}')">
                                                Promote
                                            </button>
                                        </td>
                                        <td>${s.username}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </body>
</html>

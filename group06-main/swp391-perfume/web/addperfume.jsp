<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add Perfume - PerfumeParadise</title>
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <link href="css/style.css" rel="stylesheet">
        <style>
            /* Custom styles specific to this page */
            .gradient-form {
                background-color: #f8f9fa;
            }
            .logo {
                width: 150px;
                height: auto;
            }
            .card {
                background-color: #fff;
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
                border-radius: 15px;
            }
            .form-control:focus {
                border-color: #6cb2eb; /* Custom focus color */
                box-shadow: 0 0 0 0.25rem rgba(108, 178, 235, 0.25);
            }
            .btn-primary {
                background-color: #6cb2eb;
                border-color: #6cb2eb;
            }
            .btn-primary:hover {
                background-color: #559ad8;
                border-color: #559ad8;
            }
            .form-label {
                font-weight: bold;
            }
            .form-select {
                width: 100%;
                padding: .375rem .75rem;
                font-size: 1rem;
                line-height: 1.5;
                color: #495057;
                background-color: #fff;
                background-clip: padding-box;
                border: 1px solid #ced4da;
                border-radius: .25rem;
                transition: border-color .15s ease-in-out,box-shadow .15s ease-in-out;
            }
        </style>
    </head>
    <body>

        <section class="h-100 gradient-form">
            <div class="container py-5">
                <div class="row justify-content-center align-items-center">
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <img src="images/logo.jpg" alt="PerfumeParadise Logo" class="logo">
                                    <h4 class="mt-3 mb-4">PerfumeParadise</h4>
                                </div>
                                <form enctype="multipart/form-data" action="addperfume" method="post">
                                    <h1 class="mb-4">Adding Perfume</h1>
                                    <div class="mb-3">
                                        <label class="form-label">Perfume Name:</label>
                                        <input type="text" class="form-control" name="name" placeholder="Enter perfume name" required>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="col-sm-6">
                                            <label class="form-label">Quantity:</label>
                                            <input type="number" class="form-control" name="quantity" min="0" required>
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="form-label">Size (ml):</label>
                                            <input type="number" class="form-control" name="size" min="0" required>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="col-sm-6">
                                            <label class="form-label">Price ($):</label>
                                            <input type="number" class="form-control" name="price" min="0" required>
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="form-label">Release Date:</label>
                                            <input type="date" class="form-control" name="releaseDate">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Category:</label>
                                        <select class="form-select" name="cid">
                                            <c:forEach items="${sessionScope.listC}" var="c">
                                                <option value="${c.id}">${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Brand:</label>
                                        <select class="form-select" name="bid">
                                            <c:forEach items="${sessionScope.listB}" var="b">
                                                <option value="${b.id}">${b.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <!-- Thêm trường mô tả -->
                                    <div class="mb-3">
                                        <label class="form-label">Description:</label>
                                        <textarea class="form-control" name="description" rows="4" placeholder="Enter perfume description" required></textarea>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Select Image:</label>
                                        <input type="file" class="form-control" name="image" accept=".jpg" required>
                                    </div>
                                    <div class="text-center">
                                        <button class="btn btn-primary btn-block" type="submit">
                                            <i class="fas fa-plus me-2"></i> Add Perfume
                                        </button>
                                        <span class="text-danger mt-2">${requestScope.ms}</span>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </body>
</html>

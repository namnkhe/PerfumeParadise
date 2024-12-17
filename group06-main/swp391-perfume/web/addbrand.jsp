<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add Brand - PerfumeParadise</title>
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <link href="css/style.css" rel="stylesheet">
        <style>
            /* Custom styles specific to this page */
            .gradient-form {
                background-color: #eee;
                min-height: 100vh;
            }
            .logo {
                width: 20%;
            }
            .card {
                background-color: #fff; /* Set card background color */
            }
            .main-content {
                padding-left: 250px; /* Adjust to match sidebar width */
                width: calc(100% - 250px); /* Fill remaining space next to sidebar */
            }
        </style>
    </head>
    <body>
        <jsp:include page="template/adminheader.jsp"/>
        <div class="main-content">
            <section class="h-100 gradient-form">
                <div class="container py-5 h-100">
                    <div class="row justify-content-center align-items-center h-100">
                        <div class="col-xl-8">
                            <div class="card rounded-3 shadow">
                                <div class="card-body p-4">
                                    <div class="text-center">
                                        <img src="images/logo.jpg" alt="PerfumeParadise Logo" class="logo">
                                        <h4 class="mt-3 mb-4">PerfumeParadise</h4>
                                    </div>
                                    <div class="container">
                                        <div class="form-container">
                                            <form enctype="multipart/form-data" action="addbrand" method="post">
                                                <h1 class="mb-4" style="font-size: 1.5rem;">Adding Brand</h1>
                                                <div class="form-outline mb-4">
                                                    <input type="text" class="form-control" name="name" placeholder="Brand Name" required id="name">
                                                </div>
                                                <div class="form-outline mb-4">
                                                    <label for="image">Select Brand Image:</label>
                                                    <input type="file" id="image" name="image" accept=".jpg" required>
                                                </div>
                                                <div class="text-center">
                                                    <button class="btn btn-primary btn-block mb-3" type="submit">
                                                        <i class="fas fa-plus me-2"></i> Add Brand
                                                    </button>
                                                    <span style="color: red;">${requestScope.ms}</span>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Staff</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <!-- Custom CSS -->
        <link href="css/style.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="template/adminheader.jsp" />

        <section class="h-100 gradient-form">
            <div class="container py-5 h-100">
                <div class="row d-flex justify-content-center align-items-center h-100">
                    <div class="col-xl-8">
                        <div class="card rounded-3">
                            <div class="row g-0">
                                <div class="col-lg-4 bg-light">
                                    <div class="p-4">
                                        <div class="text-center">
                                            <img src="images/logo.jpg" style="width: 50%;" alt="logo" class="logo">
                                            <h4 class="mt-3 mb-0">PerfumeParadise</h4>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-8">
                                    <div class="card-body p-md-5">
                                        <h1 class="mb-4">Create Staff</h1>
                                        <form action="createstaff" method="post">
                                            <div class="mb-3">
                                                <input type="text" class="form-control" name="username" placeholder="Username" required>
                                            </div>
                                            <div class="mb-3">
                                                <input type="password" class="form-control" name="password" placeholder="Password" required>
                                            </div>
                                            <div class="mb-4">
                                                <input type="password" class="form-control" name="repassword" placeholder="Re-password" required>
                                            </div>
                                            <button type="submit" class="btn btn-primary btn-block">Create</button>
                                            <div class="mt-3 text-danger">
                                                ${requestScope.registerError}<br>
                                                ${requestScope.ms}
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

        <jsp:include page="template/footer.jsp" />

        <!-- Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Admin Login</title>
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <style>
            body {
                background: url('images/back2.jpeg') no-repeat center center fixed;
                background-size: cover;
            }
            .card {
                background: rgba(255, 255, 255, 0.9);
                border-radius: 1rem;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            .btn-primary {
                background-color: #1d4ed8;
                border-color: #1d4ed8;
            }
            .btn-primary:hover {
                background-color: #153e75;
                border-color: #153e75;
            }
            .form-control:focus {
                border-color: #1d4ed8;
                box-shadow: none;
            }
            .logo {
                width: 150px;
                height: auto;
            }
        </style>
    </head>
    <body>
        <section class="h-100">
            <div class="container py-5 h-100">
                <div class="row d-flex justify-content-center align-items-center h-100">
                    <div class="col-xl-5 col-lg-6 col-md-8">
                        <div class="card text-black shadow">
                            <div class="card-body p-md-5 mx-md-4">
                                <div class="text-center mb-5">
                                    <img src="images/logo.jpg" alt="logo" class="logo">
                                    <h4 class="mt-1 mb-5 pb-1">PerfumeParadise</h4>
                                </div>
                                <form action="adminlogin" method="post">
                                    <h1 class="text-center mb-4">Admin Login</h1>
                                    <div class="form-outline mb-4">
                                        <input type="text" id="form2Example11" name="username" class="form-control" required />
                                        <label class="form-label" for="form2Example11">Username</label>
                                    </div>
                                    <div class="form-outline mb-4">
                                        <input type="password" id="form2Example22" name="password" required class="form-control" />
                                        <label class="form-label" for="form2Example22">Password</label>
                                    </div>
                                    <div class="text-center pt-1 mb-5 pb-1">
                                        <button class="btn btn-primary btn-block fa-lg gradient-custom-2 mb-3" type="submit">Login</button><br/>
                                        <a class="text-muted" href="#!">Forgot password?</a>
                                        <br><span style="color: red;">${requestScope.error}</span>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Register</title>
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <style>
            body {
                background-color: #f7f7f7;
                font-family: 'Roboto', sans-serif;
            }
            .gradient-form {
                background: linear-gradient(45deg, #ff9a9e, #fad0c4);
                padding: 50px 0;
                background-image: url('images/bannervip8.avif');
                background-size: cover;
                background-position: center;
            }
            .card {
                border: none;
                border-radius: 15px;
                box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            }
            .card-body {
                padding: 40px;
            }
            .logo {
                width: 100px;
                margin-bottom: 20px;
            }
            h1 {
                font-family: 'Dancing Script', cursive;
                font-size: 2.5rem;
                margin-bottom: 20px;
                color: #333;
            }
            .form-control {
                border-radius: 25px;
                padding: 10px 20px;
                margin-bottom: 15px;
            }
            .btn-primary {
                border-radius: 25px;
                padding: 10px 30px;
                background-color: #ff6666;
                border: none;
                transition: background-color 0.3s;
            }
            .btn-primary:hover {
                background-color: #cc0000;
            }
            .text-center {
                text-align: center;
            }
        </style>
    </head>
    <body>
        <jsp:include page="template/header2.jsp"/>
        <section class="h-100 gradient-form">
            <div class="container py-5 h-100">
                <div class="row d-flex justify-content-center align-items-center h-100">
                    <div class="col-xl-8">
                        <div class="card rounded-3 text-black">
                            <div class="row g-0">
                                <div class="col-lg-12">
                                    <div class="card-body p-md-5 mx-md-4">
                                        <div class="text-center">
                                            <img src="images/logo.jpg" alt="logo" class="logo">
                                            <h4 class="mt-1 mb-5 pb-1">PerfumeParadise</h4>
                                        </div>

                                        <div class="container" id="container">
                                            <div class="form-container sign-in">
                                                <form action="register" method="post">
                                                    <h1>Create Account</h1>
                                                    <div class="form-outline mb-4">
                                                        <input type="text" class="form-control" name="username" placeholder="Username" required id="username">
                                                    </div>
                                                    <div class="form-outline mb-4">
                                                        <input type="password" class="form-control" name="password" placeholder="Password" required id="password">
                                                    </div>
                                                    <div class="form-outline mb-4">
                                                        <input type="password" class="form-control" name="repassword" placeholder="Re-enter Password" required id="repassword">
                                                    </div>
                                                    <div class="form-outline mb-4">
                                                        <input type="text" class="form-control" name="fullname" placeholder="Full Name" required id="fullname">
                                                    </div>
                                                    <div class="form-outline mb-4">
                                                        <select class="form-control" name="gender" required id="gender">
                                                            <option value="" disabled selected>Select Gender</option>
                                                            <option value="male">Male</option>
                                                            <option value="female">Female</option>
                                                            <option value="other">Other</option>
                                                        </select>
                                                    </div>
                                                    <div class="form-outline mb-4">
                                                        <input type="email" class="form-control" name="email" required placeholder="Email" id="email">
                                                    </div>
                                                    <div class="form-outline mb-4">
                                                        <input type="text" class="form-control" name="phone" required placeholder="Mobile" id="phone">
                                                    </div>
                                                    <div class="form-outline mb-4">
                                                        <input type="text" class="form-control" name="address" required placeholder="Address" id="address">
                                                    </div>
                                                    <div class="text-center pt-1 mb-5 pb-1">
                                                        <button class="btn btn-primary btn-block gradient-custom-2 mb-3" type="submit">
                                                            Sign Up
                                                        </button><br/>
                                                        <span style="color: red;">${requestScope.registerError}</span><br/>
                                                        <span style="color: red;">${requestScope.ms}</span>
                                                    </div>
                                                    <p class="text-center">A verification link will be sent to your email. Please check your email to verify your account before accessing the system.</p>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-3"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">        
        <title>Login</title>
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <link href="css/style.css" rel="stylesheet">
        <style>
            body {
                background-color: #eee;
            }
            .card {
                border: none;
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            .form-control {
                border-radius: 10px;
            }
            .logo {
                width: 50%;
            }
            .password-toggle {
                position: relative;
            }
            .password-toggle .toggle-password {
                position: absolute;
                right: 10px; /* Positioning inside the input field */
                top: calc(50% + 0.5cm); /* Shift down by 0.5 cm */
                transform: translateY(-50%);
                cursor: pointer;
                font-size: 1.2rem;
                color: #888;
            }
            .background-image {
                background: url('images/bannervip2.jpg') no-repeat center center;
                background-size: cover;
            }
            .btn-custom-login {
                background: linear-gradient(45deg, #ff4b2b, #ff416c);
                border: none;
                color: #fff;
                font-weight: bold;
                padding: 10px;
                width: 100%;
                transition: background 0.3s ease;
                border-radius: 8px;
            }
            .btn-custom-login:hover {
                background: linear-gradient(45deg, #ff416c, #ff4b2b);
                color: #fff;
            }
            .btn-custom-forgot {
                background: linear-gradient(45deg, #ffa07a, #ff6347);
                border: none;
                color: #fff;
                padding: 10px;
                width: 100%;
                font-weight: bold;
                transition: background 0.3s ease, color 0.3s ease;
                border-radius: 8px;
                margin-top: 10px;
            }
            .btn-custom-forgot:hover {
                background: linear-gradient(45deg, #ff6347, #ffa07a);
                color: #fff;
            }
        </style>
    </head>
    <body>
        <jsp:include page="template/header2.jsp"/>
        <section class="h-100 gradient-form">
            <div class="container py-5 h-100">
                <div class="row d-flex justify-content-center align-items-center h-100">
                    <div class="col-xl-10">
                        <div class="card">
                            <div class="row g-0">
                                <div class="col-lg-6 d-flex align-items-center">
                                    <div class="card-body p-md-5 mx-md-4">
                                        <div class="text-center">
                                            <img src="images/logo.jpg" alt="logo" class="logo">
                                            <h4 class="mt-1 mb-5 pb-1" style="font-family: 'Brush Script MT', cursive; color: #ff4b2b;">Perfume Paradise</h4>
                                        </div>
                                        <form action="login" method="post">
                                            <h1 class="mb-4" style="font-family: 'Georgia', serif;">Login</h1>
                                            <div class="form-outline mb-4">
                                                <label class="form-label" for="form2Example11">Email</label>
                                                <input type="email" id="form2Example11" name="email" class="form-control" required />
                                            </div>

                                            <div class="form-outline mb-4 password-toggle">
                                                <label class="form-label" for="form2Example22">Password</label>
                                                <input type="password" id="form2Example22" name="password" required class="form-control" />
                                                <i class="fas fa-eye toggle-password" onclick="togglePassword()"></i>
                                            </div>

                                            <div class="form-check mb-4">
                                                <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe" />
                                                <label class="form-check-label" for="rememberMe">Remember Me</label>
                                            </div>

                                            <div class="text-center pt-1 mb-5 pb-1">
                                                <button class="btn btn-custom-login mb-3" type="submit">Login</button>
                                                <button class="btn btn-custom-forgot" type="submit" name="forgot" value="true">Forgot password</button>
                                                <br><span style="color: red;">${requestScope.error}</span>
                                            </div>
                                            <div class="d-flex align-items-center justify-content-center pb-4">
                                                <p class="mb-0 me-2">Don't have an account?</p>
                                                <a href="register"><button type="button" class="btn btn-outline-danger">Create new</button></a>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                                <div class="col-lg-6 background-image">
                                    <!-- Promotional image section -->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <%
            // Retrieve cookies and set default values for email and password
            Cookie[] cookies = request.getCookies();
            String email = "";
            String password = "";
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("email".equals(cookie.getName())) {
                        email = cookie.getValue();
                    } else if ("password".equals(cookie.getName())) {
                        password = cookie.getValue();
                    }
                }
            }
        %>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
        <script>
                                                    // Auto-fill fields if cookies are present
                                                    document.addEventListener("DOMContentLoaded", function () {
                                                        const email = "<%= email %>";
                                                        const password = "<%= password %>";
                                                        if (email)
                                                            document.getElementById('form2Example11').value = email;
                                                        if (password)
                                                            document.getElementById('form2Example22').value = password;
                                                    });

                                                    function togglePassword() {
                                                        const passwordField = document.getElementById('form2Example22');
                                                        const toggleIcon = document.querySelector('.toggle-password');
                                                        const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
                                                        passwordField.setAttribute('type', type);
                                                        toggleIcon.classList.toggle('fa-eye');
                                                        toggleIcon.classList.toggle('fa-eye-slash');
                                                    }
        </script>
    </body>
</html>

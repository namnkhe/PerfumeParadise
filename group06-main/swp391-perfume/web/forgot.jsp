<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reset Password</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <style>
            body, html {
                height: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                background: linear-gradient(135deg, #a8edea, #fed6e3);
                margin: 0;
                font-family: Arial, sans-serif;
            }
            .card {
                width: 100%;
                max-width: 400px;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                border: none;
            }
            .btn-primary {
                background: linear-gradient(45deg, #ff4b2b, #ff416c);
                border: none;
            }
            .btn-primary:hover {
                background: linear-gradient(45deg, #ff416c, #ff4b2b);
            }
            .message {
                font-weight: bold;
                margin-top: 15px;
                text-align: center;
            }
            .success-message {
                color: green;
            }
            .error-message {
                color: red;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="card p-4">
                <h2 class="text-center mb-4" style="color: #ff4b2b;">Reset Password</h2>
                <p class="text-center mb-4">Enter your new password!</p>

                <!-- Display success or error message -->
                <c:if test="${not empty successMessage}">
                    <div class="message success-message">${successMessage}</div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="message error-message">${errorMessage}</div>
                </c:if>

                <form action="forgot" method="post" id="resetForm">
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">New Password</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Confirm New Password</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Reset Password</button>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </body>
</html>

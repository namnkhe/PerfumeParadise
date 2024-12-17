<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Verify OTP</title>
        <link rel="stylesheet" href="styles.css">
        <style>
            body, html {
                margin: 0;
                padding: 0;
                font-family: Arial, sans-serif;
                height: 100%;
                display: flex;
                justify-content: center;
                align-items: center;
                background: linear-gradient(135deg, #a8edea, #fed6e3);
            }

            .otp-container {
                background-color: #ffffff;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                width: 100%;
                max-width: 360px;
                text-align: center;
                box-sizing: border-box;
            }

            .otp-container h2 {
                margin-bottom: 15px;
                color: #333;
                font-size: 1.8rem;
                font-weight: 600;
            }

            .otp-container input[type="text"] {
                width: 100%;
                padding: 12px;
                margin-bottom: 20px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 1rem;
                box-sizing: border-box;
            }

            .otp-container button {
                width: 100%;
                padding: 12px;
                font-size: 1rem;
                font-weight: 600;
                background: linear-gradient(135deg, #28a745, #218838);
                color: #fff;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                transition: background 0.3s;
                margin-top: 10px;
            }

            .otp-container button.resend {
                background: linear-gradient(135deg, #007bff, #0069d9);
            }

            .otp-container button:disabled {
                background: #c4c4c4;
                cursor: not-allowed;
            }

            .message {
                padding: 12px;
                margin-bottom: 15px;
                border-radius: 8px;
                color: #fff;
                font-weight: 500;
                font-size: 1rem;
                background-color: #dc3545;
            }

            .message.success {
                background-color: #28a745;
            }
        </style>
    </head>
    <body>
        <div class="otp-container">
            <h2>Verify Your OTP</h2>

            <!-- Display message if present -->
            <c:if test="${not empty message}">
                <div class="message ${type}">${message}</div>
            </c:if>

            <!-- OTP Verification Form -->
            <form action="verifyOtp" method="post" id="otpForm">
                <input type="text" name="otp" id="otpInput" placeholder="Enter OTP" required>
                <button type="submit" id="verifyButton">Verify</button>
            </form>

            <!-- Resend OTP Form -->
            <form action="verifyOtp" method="post" id="resendForm">
                <input type="hidden" name="action" value="resendOtp">
                <button type="submit" class="resend">Resend OTP</button>
            </form>

            <!-- Success handling script -->
            <c:if test="${type == 'success'}">
                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        document.getElementById("otpInput").disabled = true;
                        document.getElementById("verifyButton").disabled = true;
                    });

                    const purpose = "${purpose}";
                    setTimeout(function () {
                        if (purpose === "forgot") {
                            window.location.href = "forgot";
                        } else {
                            window.location.href = "home";
                        }
                    }, 5000); // Redirect after 5 seconds
                </script>
            </c:if>
        </div>
    </body>
</html>

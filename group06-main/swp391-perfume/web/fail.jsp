<%-- 
    Document   : fail
    Created on : Oct 20, 2024, 2:28:01 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            body {
                text-align: center;
                padding: 50px;
            }
            h1 {
                color: red;
            }
            .button {
                background-color: #4CAF50; /* Green */
                border: none;
                color: white;
                padding: 15px 32px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                margin-top: 20px;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <h1>Thanh toán thất bại!</h1>
        <button class="button" onclick="window.location.href = 'home.jsp'">Back to Home</button>
    </body>
</html>

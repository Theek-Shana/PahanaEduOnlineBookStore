<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Email Sent</title>
    <style>
        body {
            font-family: Arial;
            background: #d4edda;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .message-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            border-left: 6px solid #28a745;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            width: 400px;
        }
        h2 {
            color: #28a745;
            text-align: center;
        }
        p {
            color: #333;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="message-box">
    <h2>Success!</h2>
    <p>An email has been sent to your address. Please check your inbox.</p>
</div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register New Customer</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            background: linear-gradient(to right, #2c3e50, #3498db);
            font-family: 'Montserrat', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .register-container {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            backdrop-filter: blur(12px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            padding: 30px 40px;
            color: #fff;
            width: 400px;
            animation: fadeIn 0.6s ease-in-out;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: none;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.2);
            color: #fff;
        }

        input[type="submit"] {
            width: 100%;
            padding: 12px;
            border: none;
            background-color: #1abc9c;
            color: #fff;
            font-weight: bold;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #16a085;
        }

        a {
            color: #f1c40f;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        .message {
            text-align: center;
            margin-top: 10px;
        }

        .error { color: #e74c3c; }
        .success { color: #2ecc71; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
<div class="register-container">
    <h2>Register New Customer</h2>

    <form action="customer-register" method="post">
        <input type="text" name="fullname" placeholder="Full Name" required/>
        <input type="email" name="email" placeholder="Email" required/>
        <input type="text" name="mobile" placeholder="Mobile" required/>
        <input type="password" name="password" placeholder="Password" required/>
        <input type="submit" value="Register"/>
    </form>

    <div class="message">
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>

        <c:if test="${not empty success}">
            <p class="success">${success}</p>
        </c:if>
    </div>

    <div class="message">
        <p><a href="login">← Back to Login</a></p>
    </div>
</div>
</body>
</html>

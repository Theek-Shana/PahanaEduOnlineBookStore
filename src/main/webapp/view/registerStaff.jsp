<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register Staff</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: #121212;
            font-family: 'Montserrat', sans-serif;
            color: #ffffff;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background-color: #1e1e1e;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.5);
            width: 100%;
            max-width: 400px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #00bcd4;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            padding: 10px;
            margin-bottom: 15px;
            border: none;
            border-radius: 8px;
            background-color: #2e2e2e;
            color: #ffffff;
        }

        input[type="submit"] {
            padding: 10px;
            background-color: #00bcd4;
            border: none;
            border-radius: 8px;
            color: white;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #0194a3;
        }

        .error-message {
            color: #ff4c4c;
            margin-bottom: 15px;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Register New Staff Member</h2>

    <%
        String error = request.getParameter("error");
        if ("1".equals(error)) {
    %>
        <div class="error-message">Failed to register staff member. Please try again.</div>
    <%
        }
    %>

    <form action="<%= request.getContextPath() %>/staff-register" method="post">
        <input type="text" name="name" placeholder="Full Name" required/>
        <input type="email" name="email" placeholder="Email" required/>
        <input type="text" name="mobile" placeholder="Mobile" required/>
        <input type="password" name="password" placeholder="Password" required/>
        <input type="submit" value="Register"/>
    </form>
</div>
</body>
</html>

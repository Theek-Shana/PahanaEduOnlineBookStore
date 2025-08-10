<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Enter OTP</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        form { width: 300px; margin: auto; }
        input, button { padding: 8px; margin-top: 10px; width: 100%; }
    </style>
</head>
<body>
<h2>Enter OTP to Reset Password</h2>

<% String error = request.getParameter("error"); %>
<% if ("InvalidOTP".equals(error)) { %>
    <p style="color:red;">Invalid OTP. Please try again.</p>
<% } else if ("FieldsRequired".equals(error)) { %>
    <p style="color:red;">Please fill all fields.</p>
<% } %>

<form action="<%= request.getContextPath() %>/forgot-password" method="post">
    <input type="hidden" name="action" value="reset"/>
    <input type="text" name="otp" placeholder="Enter OTP" required />
    <input type="password" name="password" placeholder="New Password" required />
    <button type="submit">Reset Password</button>
</form>

</body>
</html>

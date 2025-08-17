<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookshop.model.User" %>
<%
    User user = (User) request.getAttribute("user");
    String error = (String) request.getAttribute("error");

    if (user == null) {
        user = new User(); // prevent null pointer
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Customer</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <style>
        /* Keep the same CSS as before */
        /* ... your existing CSS here ... */
    </style>
</head>
<body>
<div class="container">
    <h2>Edit Customer Details</h2>

    <% if (error != null) { %>
        <div class="error-message"><%= error %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/admin/customers" method="post">
        <input type="hidden" name="action" value="update" />
        <input type="hidden" name="id" value="<%= user.getId() %>" />

        <label>Full Name</label>
        <input type="text" name="fullname" value="<%= user.getFullname() %>" required />

        <label>Email</label>
        <input type="email" name="email" value="<%= user.getEmail() %>" required />

        <label>Mobile</label>
        <input type="text" name="mobile" value="<%= user.getMobile() %>" required />

        <label>Account Number</label>
        <input type="text" name="accountNumber" value="<%= user.getAccountNumber() %>" readonly />

        <label>Password</label>
        <input type="password" name="password" value="<%= user.getPassword() %>" required />

        <button type="submit">Update</button>
    </form>

    <a href="<%= request.getContextPath() %>/admin/customers" class="back-link">← Back to Customer List</a>
</div>
</body>
</html>

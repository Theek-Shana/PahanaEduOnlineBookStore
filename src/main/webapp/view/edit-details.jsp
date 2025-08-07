<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookshop.model.User" %>
<%
    User user = (User) request.getAttribute("user");
    String error = (String) request.getAttribute("error");

    if (user == null) {
        user = new User(); // prevent null pointer
    }

    // Determine form action and back link based on user role
    String formAction;
    String backLink;
    if ("staff".equals(user.getRole())) {
        formAction = request.getContextPath() + "/login";
        backLink = request.getContextPath() + "/login?action=listStaff";
    } else {
        formAction = request.getContextPath() + "/admin/customers";
        backLink = request.getContextPath() + "/admin/customers";
    }
%>
<% String success = (String) request.getAttribute("success"); %>
<% if (success != null) { %>
    <div class="alert alert-success"><%= success %></div>
<% } %>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Details </title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <style>
        /* Your existing styles unchanged */
        body {
            font-family: 'Montserrat', sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: #eee;
        }
         <style>
        body {
            font-family: 'Montserrat', sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: #eee;
        }

        .container {
            background-color: rgba(30, 30, 30, 0.95);
            padding: 40px 30px;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.5);
            max-width: 450px;
            width: 100%;
        }

        h2 {
            text-align: center;
            color: #00e6e6;
            margin-bottom: 25px;
            font-weight: 600;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
            color: #ccc;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 18px;
            border: none;
            border-radius: 10px;
            background-color: #2b2b2b;
            color: #fff;
            outline: none;
            transition: 0.3s;
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus {
            background-color: #333;
            box-shadow: 0 0 5px #00e6e6;
        }

        input[readonly] {
            background-color: #444;
            color: #aaa;
        }

        button {
            width: 100%;
            padding: 12px;
            background: #00e6e6;
            border: none;
            border-radius: 10px;
            font-weight: bold;
            font-size: 16px;
            color: #111;
            cursor: pointer;
            transition: 0.3s;
        }

        button:hover {
            background: #00c4c4;
        }

        .error-message {
            color: #ff4c4c;
            text-align: center;
            margin-bottom: 15px;
        }

        a.back-link {
            display: block;
            text-align: center;
            color: #00e6e6;
            margin-top: 18px;
            text-decoration: none;
            font-size: 14px;
        }

        a.back-link:hover {
            text-decoration: underline;
        }
    </style>
    </style>
</head>
<body>
<div class="container">
    <h2>Edit User Details</h2>

    <% if (error != null) { %>
        <div class="error-message"><%= error %></div>
    <% } %>

    <form action="<%= formAction %>" method="post">

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

   <a href="<%= backLink %>" class="back-link">← Back to List</a>

</div>
</body>
</html>

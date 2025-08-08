<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    com.bookshop.model.User user = (com.bookshop.model.User) session.getAttribute("user");
    if (user == null || !"customer".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/view/login.jsp");
        return;
    }
%>


<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
        }
        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #0f0f0f, #1f1f1f);
            color: #fff;
        }
        .profile-card {
            max-width: 600px;
            margin: 60px auto;
            padding: 30px;
            background: rgba(255, 255, 255, 0.06);
            border-radius: 20px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(8px);
        }
        h2 {
            text-align: center;
            margin-bottom: 25px;
            font-weight: 600;
            color: #00bfff;
        }
        label {
            display: block;
            margin-top: 15px;
            font-weight: 500;
        }
        input, textarea {
            width: 100%;
            padding: 12px;
            margin-top: 5px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            color: white;
            font-size: 14px;
        }
        input::placeholder {
            color: rgba(255, 255, 255, 0.5);
        }
        input[readonly] {
            background: rgba(255, 255, 255, 0.03);
            color: #ccc;
            cursor: not-allowed;
        }
        input[type="file"] {
            padding: 5px;
        }
        img {
            width: 110px;
            height: 110px;
            border-radius: 50%;
            object-fit: cover;
            display: block;
            margin: 0 auto 20px auto;
            border: 2px solid #00bfff;
        }
        .button-row {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-top: 25px;
        }
        button {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 8px;
            background: #00bfff;
            color: white;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        button.btn-back {
            background: #444;
        }
        button:hover {
            background: #008fcc;
        }
        button.btn-back:hover {
            background: #666;
        }

        @media screen and (max-width: 480px) {
            .profile-card {
                margin: 20px;
                padding: 20px;
            }
            h2 {
                font-size: 22px;
            }
        }
    </style>
</head>
<body>
<div class="profile-card">
    <h2>My Profile </h2>
    
    <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/profile">
        
        <c:choose>
            <c:when test="${not empty profile.profilePhoto}">
                <img src="${pageContext.request.contextPath}/uploads/${profile.profilePhoto}" alt="Profile Photo">
            </c:when>
            <c:otherwise>
                <img src="${pageContext.request.contextPath}/view/uploads/default.png" alt="Default Photo">
            </c:otherwise>
        </c:choose>

        <label>Account Number</label>
        <input type="text" value="${profile.accountNumber}" readonly>

        <label>Full Name</label>
        <input type="text" name="fullname" value="${profile.fullname}" required>

        <label>Email</label>
        <input type="email" value="${profile.email}" readonly>

        <label>Username</label>
        <input type="text" name="username" value="${profile.username}">


        <label>Password</label>
        <input type="password" name="password" value="${profile.password}" required>

        <label>Address</label>
        <input type="text" name="address" value="${profile.address}">

        <label>Phone</label>
        <input type="text" name="telephone" value="${profile.telephone}">

        <label>Profile Photo</label>
        <input type="file" name="profile_photo">

        <div class="button-row">
            <button class="btn-back" type="button" onclick="window.location.href='${pageContext.request.contextPath}/view/customerDashboard.jsp'">Back</button>
            <button type="submit">Update</button>
        </div>
    </form>
</div>
</body>
</html>

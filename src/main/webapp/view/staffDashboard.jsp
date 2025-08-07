<%@ page session="true" contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check userType from session; if not staff, redirect to login
    String userType = (String) session.getAttribute("userType");
    if (userType == null || !"staff".equals(userType)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Get staff user object from session (assuming you stored it as "user")
    com.bookshop.model.User staff = (com.bookshop.model.User) session.getAttribute("user");
    if (staff == null) {
        // If no staff found in session, redirect to login
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Staff Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            display: flex;
            height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #2c3e50, #4ca1af);
            color: #fff;
        }
        .sidebar {
            width: 250px;
            background: rgba(0, 0, 0, 0.25);
            backdrop-filter: blur(10px);
            padding: 30px 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 2px 0 8px rgba(0,0,0,0.4);
        }
        .sidebar h2 {
            color: #ffd966;
            margin-bottom: 40px;
        }
        .nav-links a {
            color: #fff;
            text-decoration: none;
            display: block;
            margin-bottom: 20px;
            font-weight: 500;
            padding: 10px 15px;
            border-radius: 8px;
            transition: background 0.3s;
        }
        .nav-links a:hover {
            background: rgba(255, 255, 255, 0.15);
        }
        .logout-btn {
            background-color: #e74c3c;
            color: #fff;
            padding: 10px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .logout-btn:hover {
            background-color: #c0392b;
        }
        .main-content {
            flex: 1;
            padding: 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        .main-content h1 {
            font-size: 2.5rem;
            color: #ffd966;
        }
        .main-content p {
            font-size: 1.2rem;
            margin-top: 10px;
            max-width: 600px;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <div>
            <h2>📘 Staff Panel</h2>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/item?action=new">➕ Add Item</a>
                <a href="<%= request.getContextPath() %>/item?action=list">📚 View Items</a>
                <a href="<%= request.getContextPath() %>/admin/customers">👥 Manage Customers</a>
                <a href="<%= request.getContextPath() %>/staff/orders">📦 Manage Orders</a>
                 <a href="${pageContext.request.contextPath}/staff/private-chat-list">Customer Chat List</a>
                 <a href="${pageContext.request.contextPath}/reports">View Sales Reports</a>
                 
                 
<section class="new-order-section" aria-label="Create new order section">
        <a href="${pageContext.request.contextPath}/staff/createOrder" role="button" tabindex="0">
            ➕ Create New Order
        </a>
    </section>
                
            </div>
        </div>
        <form action="<%= request.getContextPath() %>/logout" method="get">
            <button class="logout-btn" type="submit">🚪 Logout</button>
        </form>
    </div>

    <div class="main-content">
        <h1>Welcome, <%= staff.getFullname() %>!</h1>
        <p>Manage all bookshop operations using the menu on the left.</p>
    </div>
</body>
</html>

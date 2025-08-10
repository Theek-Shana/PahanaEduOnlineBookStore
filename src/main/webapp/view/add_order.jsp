<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookshop.model.User" %>
<%@ page import="java.util.List" %>
<%
    List<User> customers = (List<User>) request.getAttribute("customers");
%>
<html>
<head>
    <title>Select Customer</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #ece9e6, #ffffff);
            padding: 40px;
        }

        h2 {
            text-align: center;
            color: #333;
            font-size: 28px;
            margin-bottom: 30px;
        }

        .customer-container {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .customer-card {
            width: 90%;
            max-width: 600px;
            background-color: #ffffff;
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 20px;
            margin: 10px 0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .customer-info {
            color: #555;
        }

        .customer-info h3 {
            margin: 0 0 5px;
            color: #222;
        }

        .btn {
            background-color: #007bff;
            color: #fff;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .btn:hover {
            background-color: #0056b3;
        }

        .empty-message {
            text-align: center;
            margin-top: 50px;
            color: #888;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <h2>Select a Customer to Add Order</h2>

    <div class="customer-container">
        <%
            if (customers != null && !customers.isEmpty()) {
                for (User u : customers) {
                    if ("customer".equalsIgnoreCase(u.getRole())) {
        %>
        <div class="customer-card">
            <div class="customer-info">
                <h3><%= u.getFullname() %></h3>
                <p>Email: <%= u.getEmail() %></p>
            </div>
            <form action="<%= request.getContextPath() %>/staff/addOrderItems" method="post">
                <input type="hidden" name="customerId" value="<%= u.getId() %>" />
                <button class="btn" type="submit">Add Order</button>
            </form>
        </div>
        <% 
                    }
                }
            } else {
        %>
        <div class="empty-message">
            🚫 No customers found to place an order.
        </div>
        <%
            }
        %>
    </div>
</body>
</html>

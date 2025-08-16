<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bookshop.model.User" %>

<%
    List<User> customers = (List<User>) request.getAttribute("customers");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Chat List - Staff</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #eaeaea;
            margin: 0;
            padding: 20px;
        }

        h1 {
            color: #333;
            margin-bottom: 20px;
        }

        .chat-list-container {
            max-width: 800px;
            margin: auto;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }

        .customer-card {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px;
            border-bottom: 1px solid #ddd;
            transition: background 0.3s;
        }

        .customer-card:hover {
            background-color: #f1f1f1;
        }

        .customer-info {
            display: flex;
            flex-direction: column;
        }

        .customer-info span {
            margin-bottom: 4px;
        }

        .customer-name {
            font-weight: bold;
            font-size: 16px;
            color: #333;
        }

        .customer-email {
            color: #555;
            font-size: 14px;
        }

        .customer-mobile {
            color: #888;
            font-size: 13px;
        }

        .chat-button {
            background-color: #25D366;
            color: white;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 20px;
            font-weight: bold;
            transition: background 0.3s;
        }

        .chat-button:hover {
            background-color: #128C7E;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #007bff;
            text-decoration: none;
            font-weight: bold;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="chat-list-container">
    <h1>📋 Customer Chat List</h1>

    <% if (customers != null && !customers.isEmpty()) {
        for (User customer : customers) {
    %>
        <div class="customer-card">
            <div class="customer-info">
                <span class="customer-name"><%= customer.getFullname() %></span>
                <span class="customer-email"><%= customer.getEmail() %></span>
                <span class="customer-mobile">📞 <%= customer.getMobile() %></span>
            </div>
            <a class="chat-button" href="<%= contextPath %>/private-chat?customerId=<%= customer.getId() %>">
                💬 Chat
            </a>
        </div>
    <%  }
    } else { %>
        <p>No customers found.</p>
    <% } %>

    <a class="back-link" href="<%= contextPath %>/staff/dashboard">← Back to Staff Dashboard</a>
</div>

</body>
</html>

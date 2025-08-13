<%@ page import="com.bookshop.dao.OrderDAO, com.bookshop.model.Order, com.bookshop.model.OrderItem, com.bookshop.dao.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.util.List" %>
<%
    String orderIdParam = request.getParameter("orderId");
    if (orderIdParam == null) {
%>
        <h2 style="color: red;">Order ID is missing!</h2>
<%
        return;
    }

    int orderId = Integer.parseInt(orderIdParam);
    Connection conn = DBConnection.getInstance().getConnection();
    OrderDAO orderDAO = new OrderDAO(conn);
    Order order = orderDAO.getOrderById(orderId);

    if (order == null) {
%>
        <h2 style="color: red;">Invalid Order ID!</h2>
<%
        return;
    }

    List<OrderItem> items = order.getItems();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Invoice - Order #<%= order.getOrderId() %></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 30px;
            background: #fff;
        }
        h1, h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .info {
            margin-bottom: 30px;
        }
        .info strong {
            display: inline-block;
            width: 150px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }
        th, td {
            border: 1px solid #999;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #007BFF;
            color: white;
        }
        .total {
            text-align: right;
            font-size: 18px;
            font-weight: bold;
        }
        .print-btn {
            margin-top: 20px;
            display: block;
            text-align: center;
        }
        .print-btn button {
            padding: 10px 25px;
            background-color: #28a745;
            color: white;
            border: none;
            font-size: 16px;
            cursor: pointer;
        }
    </style>
</head>
<body>

<h1>Pahana Online Bookstore</h1>
<h2>Invoice - Order #<%= order.getOrderId() %></h2>

<div class="info">
    <p><strong>Customer:</strong> <%= order.getCustomerName() %></p>
    <p><strong>Order Date:</strong> <%= order.getOrderDate() %></p>
    <p><strong>Status:</strong> <%= order.getStatus() %></p>
</div>

<table>
    <thead>
        <tr>
            <th>Book Title</th>
            <th>Price (Rs.)</th>
            <th>Quantity</th>
            <th>Subtotal (Rs.)</th>
        </tr>
    </thead>
    <tbody>
    <%
        double grandTotal = 0;
        for (OrderItem item : items) {
            double subtotal = item.getPrice() * item.getQuantity();
            grandTotal += subtotal;
    %>
        <tr>
            <td><%= item.getBookTitle() %></td>
            <td><%= String.format("%.2f", item.getPrice()) %></td>
            <td><%= item.getQuantity() %></td>
            <td><%= String.format("%.2f", subtotal) %></td>
        </tr>
    <%
        }
    %>
    </tbody>
</table>

<div class="total">Total Amount: Rs. <%= String.format("%.2f", grandTotal) %></div>

<div class="print-btn">
    <button onclick="window.print()">Print / Save as PDF</button>
</div>

</body>
</html>

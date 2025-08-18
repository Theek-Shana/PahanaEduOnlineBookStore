<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.bookshop.model.Item, com.bookshop.dao.ItemDAO, com.bookshop.dao.DBConnection, java.sql.Connection" %>
<%
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    if (cart == null || cart.isEmpty()) {
%>
    <h2>Your cart is empty!</h2>
<%
        return;
    }

    double total = 0;
    ItemDAO itemDAO = new ItemDAO(); 
    List<Item> cartItems = new ArrayList<>();
    for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
        Item item = itemDAO.getItemById(entry.getKey());
        if (item != null) {
            item.setStockQuantity(entry.getValue());
            cartItems.add(item);
        }
    }

%>


<html>
<head>
    <title>Confirm Order</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 30px;
            background: #f5f5f5;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            margin-bottom: 30px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #007BFF;
            color: white;
        }
        .total {
            font-size: 18px;
            text-align: right;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .btn-proceed, .btn-download {
            padding: 10px 20px;
            background-color: #28a745;
            border: none;
            color: white;
            cursor: pointer;
            margin-right: 10px;
        }
        .btn-download {
            background-color: #17a2b8;
        }
    </style>
</head>
<body>

<h2>Confirm Your Order</h2>

<table>
    <thead>
        <tr>
            <th>Book</th>
            <th>Author</th>
            <th>Price (Rs.)</th>
            <th>Qty</th>
            <th>Subtotal (Rs.)</th>
        </tr>
    </thead>
    <tbody>
    <%
        for (Item item : cartItems) {
            double subtotal = item.getPrice() * item.getStockQuantity();
            total += subtotal;
    %>
        <tr>
            <td><%= item.getTitle() %></td>
            <td><%= item.getAuthor() %></td>
            <td><%= String.format("%.2f", item.getPrice()) %></td>
            <td><%= item.getStockQuantity() %></td>
            <td><%= String.format("%.2f", subtotal) %></td>
        </tr>
    <%
        }
    %>
    </tbody>
</table>
 
<div class="total">Total Payment: Rs. <%= String.format("%.2f", total) %></div>

<!-- Proceed to Order Form -->
<form method="post" action="<%= request.getContextPath() %>/order">
    <button type="submit" class="btn-proceed">Proceed to Order</button>
</form>



</body>
</html>

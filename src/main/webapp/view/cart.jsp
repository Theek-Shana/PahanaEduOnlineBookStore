<%@ page import="java.util.*, com.bookshop.dao.ItemDAO, com.bookshop.model.Item, com.bookshop.dao.DBConnection, java.sql.Connection, com.bookshop.model.User" %>
<%
    String message = request.getParameter("message");
    String error = request.getParameter("error");
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    User user = (User) session.getAttribute("user"); // Assuming customer is stored in session
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Your Cart - Pahana EDU Bookshop</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f2f2f2;
            margin: 0; padding: 0;
            color: #333;
        }
        .container {
            width: 90%;
            max-width: 1000px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        h1 {
            text-align: center;
            color: #00796b;
            margin-bottom: 10px;
        }
        .user-info {
            text-align: center;
            font-size: 1.1rem;
            margin-bottom: 20px;
            color: #555;
        }
        .message {
            padding: 10px 20px;
            margin-bottom: 20px;
            border-radius: 5px;
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
        }
        .error {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 25px;
        }
        th, td {
            padding: 15px 12px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }
        th {
            background: #00796b;
            color: white;
        }
        td img {
            max-width: 70px;
            height: auto;
            border-radius: 5px;
        }
        .btn-remove {
            background-color: #e53935;
            color: white;
            padding: 8px 14px;
            border: none;
            border-radius: 5px;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-remove:hover {
            background-color: #b71c1c;
        }
        .btn-proceed {
            background-color: #00796b;
            color: white;
            font-size: 1.1rem;
            padding: 12px 25px;
            margin: 20px auto;
            display: block;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }
        .btn-proceed:hover {
            background-color: #004d40;
        }
        .total-row td {
            font-weight: bold;
            font-size: 1.2rem;
            background: #e0f2f1;
        }
        .summary {
            text-align: right;
            margin-top: 20px;
            font-size: 1.1rem;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Your Shopping Cart</h1>

    <% if (user != null) { %>
        <div class="user-info">
            Logged in as: <strong><%= user.getFullname() %>
</strong> (<%= user.getEmail() %>)
        </div>
    <% } %>

    <% if (message != null) { %>
        <div class="message"><%= message.equals("removed") ? "Item removed from cart." : message %></div>
    <% } else if (error != null) { %>
        <div class="message error"><%= error.equals("invalid_remove") ? "Invalid item to remove." : error %></div>
    <% } %>

    <%
        if (cart == null || cart.isEmpty()) {
    %>
        <p style="text-align:center; font-size:1.2rem;">Your cart is empty.</p><%
    } else {
        ItemDAO itemDAO = null;
        double total = 0;
        try {
            itemDAO = new ItemDAO(); // Uses DBConnection singleton internally
%>

    <table>
        <thead>
            <tr>
                <th>Book</th>
                <th>Image</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Subtotal</th>
                <th>Remove</th>
            </tr>
        </thead>
        <tbody>
        <%
            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                int itemId = entry.getKey();
                int qty = entry.getValue();
                Item item = itemDAO.getItemById(itemId);
                if (item != null) {
                    double subtotal = item.getPrice() * qty;
                    total += subtotal;
        %>
            <tr>
                <td><%= item.getTitle() %></td>
                <td><img src="<%= request.getContextPath() + "/" + ((item.getImage() != null && !item.getImage().trim().isEmpty()) ? item.getImage() : "uploads/default.jpg") %>" alt="<%= item.getTitle() %>"></td>
                <td>LKR <%= String.format("%.2f", item.getPrice()) %></td>
                <td><%= qty %></td>
                <td>LKR <%= String.format("%.2f", subtotal) %></td>
                <td>
                    <form method="get" action="<%= request.getContextPath() %>/cart" onsubmit="return confirm('Remove this item?');">
                        <input type="hidden" name="removeItemId" value="<%= itemId %>"/>
                        <button type="submit" class="btn-remove">Remove</button>
                    </form>
                </td>
            </tr>
        <%
                }
            }
        %>
        </tbody>
        <tfoot>
            <tr class="total-row">
                <td colspan="4" style="text-align:right;">Total:</td>
                <td colspan="2">LKR <%= String.format("%.2f", total) %></td>
            </tr>
        </tfoot>
    </table>

    <div class="summary">
        <p><strong>Final Amount to Pay:</strong> LKR <%= String.format("%.2f", total) %></p>
    </div>

   <form method="post" action="confirm_order.jsp">
    <button type="submit" class="btn-proceed">Confirm Order</button>
</form>


    <%
            } catch(Exception e) {
                out.println("<p style='color:red;'>Error loading cart items: " + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                // no manual connection closing needed
            }

        }
    %>
</div>
</body>
</html>

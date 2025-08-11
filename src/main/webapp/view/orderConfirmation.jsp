<%@ page import="java.sql.*, com.bookshop.dao.DBConnection, com.bookshop.model.Item, com.bookshop.dao.ItemDAO" %>
<%
    String orderIdStr = request.getParameter("orderId");
    if (orderIdStr == null) {
        response.sendRedirect("/view/customerDashboard.jsp");
        return;
    }

    int orderId = Integer.parseInt(orderIdStr);
    Connection conn = null;

    try {
        conn = DBConnection.getInstance().getConnection();

        // Get order details
        PreparedStatement orderStmt = conn.prepareStatement("SELECT * FROM orders WHERE order_id = ?");
        orderStmt.setInt(1, orderId);
        ResultSet orderRs = orderStmt.executeQuery();

        if (!orderRs.next()) {
            out.println("<p>Order not found.</p>");
            return;
        }

        int userId = orderRs.getInt("user_id");
        Timestamp orderDate = orderRs.getTimestamp("order_date");
        double totalAmount = orderRs.getDouble("total_amount");
        String status = orderRs.getString("status");

        // Get ordered items
        PreparedStatement itemsStmt = conn.prepareStatement(
            "SELECT oi.item_id, oi.quantity, oi.price, i.title FROM order_items oi JOIN item i ON oi.item_id = i.item_id WHERE oi.order_id = ?");
        itemsStmt.setInt(1, orderId);
        ResultSet itemsRs = itemsStmt.executeQuery();
 
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Order Confirmation</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f9f9f9; padding: 30px; }
        .container { max-width: 700px; margin: auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 0 10px #ccc;}
        h2 { color: #2e7d32; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px;}
        th, td { padding: 10px; border-bottom: 1px solid #ccc; text-align: center;}
        th { background-color: #388e3c; color: white;}
    </style>
</head>
<body>
    <div class="container">
        <h2>Thank you for your order!</h2>
        <p><strong>Order ID:</strong> <%= orderId %></p>
        <p><strong>Order Date:</strong> <%= orderDate %></p>
        <p><strong>Status:</strong> <%= status %></p>

        <table>
            <thead>
                <tr>
                    <th>Book</th>
                    <th>Quantity</th>
                    <th>Price per Unit</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (itemsRs.next()) {
                        String title = itemsRs.getString("title");
                        int quantity = itemsRs.getInt("quantity");
                        double price = itemsRs.getDouble("price");
                        double subtotal = price * quantity;
                %>
                <tr>
                    <td><%= title %></td>
                    <td><%= quantity %></td>
                    <td>LKR <%= String.format("%.2f", price) %></td>
                    <td>LKR <%= String.format("%.2f", subtotal) %></td>
                </tr>
                <% } %>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="3" style="text-align:right;">Total:</th>
                    <th>LKR <%= String.format("%.2f", totalAmount) %></th>
                </tr>
            </tfoot>
        </table>

        <p><a href="<%= request.getContextPath() %>/view/customerDashboard.jsp">Back to Dashboard</a></p>
    </div>
</body>
</html>
<%
        itemsRs.close();
        itemsStmt.close();
        orderRs.close();
        orderStmt.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error loading order details.</p>");
    } finally {
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>

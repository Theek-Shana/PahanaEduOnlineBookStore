<%@ page import="java.util.*" %>
<%
    String orderId = request.getParameter("orderId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Order Successful</title>
    <style>
        body { font-family: Arial, sans-serif; background: #e0f7fa; text-align: center; padding: 50px; }
        .success { background: #00796b; color: white; padding: 30px; border-radius: 10px; display: inline-block; }
        a { color: #004d40; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>
    <div class="success">
        <h1>Thank you for your order!</h1>
        <p>Your order ID is <strong><%= orderId %></strong>.</p>
        <p>We will process your order shortly.</p>
        <a href="<%= request.getContextPath() %>/view/customerDashboard.jsp">Back to Dashboard</a>
    </div>
    
    <form method="post" action="<%= request.getContextPath() %>/view/generate_invoice.jsp" target="_blank">
    <input type="hidden" name="orderId" value="<%= orderId %>"/>
    <button type="submit" class="btn-download">Download Invoice</button>
</form>
    
    
</body>
</html>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        <p><strong>Order ID:</strong> ${order.id}</p>
        <p><strong>Order Date:</strong> ${order.orderDate}</p>
        <p><strong>Status:</strong> ${order.status}</p>

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
                <c:forEach var="item" items="${order.items}">
                    <tr>
                        <td>${item.title}</td>
                        <td>${item.quantity}</td>
                        <td>LKR ${item.price}</td>
                        <td>LKR ${item.price * item.quantity}</td>
                    </tr>
                </c:forEach>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="3" style="text-align:right;">Total:</th>
                    <th>LKR ${order.totalAmount}</th>
                </tr>
            </tfoot>
        </table>

        <p><a href="${pageContext.request.contextPath}/view/customerDashboard.jsp">Back to Dashboard</a></p>
    </div>
</body>
</html>

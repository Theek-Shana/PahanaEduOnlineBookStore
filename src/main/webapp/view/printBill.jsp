<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookshop.model.Order" %>
<%@ page import="com.bookshop.model.OrderItem" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    Order order = (Order) request.getAttribute("order");
    if (order == null) {
%>
    <p>No order data to display.</p>
<%
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Pahana Edu Bookshop - Order Bill #<c:out value="${order.orderId}"/></title>
    <style>
        /* Reset & base */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            color: #444;
            margin: 30px auto;
            max-width: 720px;
            padding: 20px 40px;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }
        h1 {
            text-align: center;
            color: #1d3557;
            margin-bottom: 0;
            font-weight: 700;
            letter-spacing: 1.5px;
        }
        h2 {
            text-align: center;
            margin-top: 4px;
            margin-bottom: 30px;
            font-weight: 600;
            color: #457b9d;
        }

        .header-section {
            border-bottom: 2px solid #a8dadc;
            padding-bottom: 10px;
            margin-bottom: 30px;
        }
        .order-info p {
            margin: 6px 0;
            font-size: 1rem;
        }
        .order-info strong {
            width: 150px;
            display: inline-block;
            color: #1d3557;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            background: white;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 30px;
        }
        th, td {
            padding: 14px 20px;
            text-align: left;
        }
        th {
            background-color: #1d3557;
            color: #f1faee;
            font-weight: 600;
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }
        tbody tr:nth-child(even) {
            background-color: #f1f1f1;
        }
        tfoot td {
            font-weight: 700;
            font-size: 1.2rem;
            color: #e63946;
            border-top: 2px solid #1d3557;
        }

        .staff-message {
            background: #a8dadc;
            border-left: 6px solid #457b9d;
            padding: 15px 20px;
            border-radius: 6px;
            font-style: italic;
            color: #1d3557;
            max-width: 720px;
            margin: 0 auto 40px auto;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        .print-btn {
            background-color: #1d3557;
            color: white;
            padding: 14px 0;
            border: none;
            border-radius: 25px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            display: block;
            width: 250px;
            margin: 0 auto;
            box-shadow: 0 6px 18px rgba(29, 53, 87, 0.6);
            transition: background-color 0.3s ease;
            user-select: none;
        }
        .print-btn:hover {
            background-color: #457b9d;
        }
        @media print {
            .print-btn {
                display: none;
            }
            body {
                box-shadow: none;
                margin: 0;
                padding: 0;
            }
        }
         .btn {
            padding: 14px 0;
            border: none;
            border-radius: 25px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            display: block;
            width: 250px;
            margin: 15px auto;
            box-shadow: 0 6px 18px rgba(0,0,0,0.1);
            user-select: none;
            transition: background-color 0.3s ease;
        }

        .btn-back {
            background-color: #6c757d; /* muted gray */
            color: white;
        }
        .btn-back:hover {
            background-color: #5a6268;
        }

        .print-btn {
            background-color: #1d3557;
            color: white;
            margin-bottom: 40px;
            box-shadow: 0 6px 18px rgba(29, 53, 87, 0.6);
        }
        .print-btn:hover {
            background-color: #457b9d;
        }
        @media print {
            .print-btn, .btn-back {
                display: none;
            }
        }
    </style>
</head>
<body>
    <div class="header-section">
        <h1>Pahana Edu Bookshop</h1>
        <h2>Order Bill #<c:out value="${order.orderId}"/></h2>
    </div>

    <div class="order-info">
        <p><strong>Customer Name:</strong> <c:out value="${order.customerName}" /></p>
        <p><strong>Order Date:</strong> <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
        <p><strong>Status:</strong> <c:out value="${order.status}" /></p>
        <c:if test="${order.placedByStaff}">
            <p><strong>Placed By Staff:</strong> <c:out value="${order.staffName}" /></p>
        </c:if>
    </div>

    <table>
        <thead>
            <tr>
                <th>Item Name</th>
                <th>Qty</th>
                <th>Unit Price (LKR)</th>
                <th>Subtotal (LKR)</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${order.items}">
                <tr>
                    <td><c:out value="${item.bookTitle}" /></td>
                    <td><c:out value="${item.quantity}" /></td>
                    <td><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="LKR " /></td>
                    <td><fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="LKR " /></td>
                </tr>
            </c:forEach>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="3" style="text-align:right">Total:</td>
                <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="LKR " /></td>
            </tr>
        </tfoot>
    </table>

    <c:if test="${not empty order.staffMessage}">
        <div class="staff-message">
            <strong>Staff Message:</strong> <c:out value="${order.staffMessage}" />
        </div>
    </c:if>
    
    
    
    
    <button class="print-btn" onclick="window.print()">🖨️ Print Bill</button>
    
<form action="${pageContext.request.contextPath}/sendOrderEmail" method="post" style="text-align:center; margin-top:20px;">
    <input type="hidden" name="orderId" value="${order.orderId}" />
    <button type="submit" class="btn" style="background-color:#1d3557; color:#fff; width:250px; border-radius:25px; padding:14px 0; font-weight:700; cursor:pointer;">
        📧 Send Bill to Customer Email
    </button>
</form>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bookshop.model.Order" %>
<%@ page import="com.bookshop.model.OrderItem" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Staff - Manage Orders</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f9fafb;
            color: #2d3a45;
            margin: 0;
            padding: 40px 15px;
            min-height: 100vh;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        h2 {
            text-align: center;
            font-size: 2.25rem;
            font-weight: 700;
            margin-bottom: 40px;
            color: #1a2b47;
            letter-spacing: 0.03em;
        }
        .orders-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
            gap: 24px;
            margin-bottom: 50px;
        }
        .order-card {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.06);
            padding: 24px 28px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            border: 1px solid transparent;
        }
        .order-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 28px rgba(0,0,0,0.12);
            border-color: #2980b9;
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            font-weight: 700;
            font-size: 1.2rem;
            color: #34495e;
            margin-bottom: 14px;
        }
        .order-customer {
            font-size: 1.05rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 18px;
        }
        .order-info {
            font-weight: 600;
            color: #555;
            margin-bottom: 10px;
            font-size: 0.95rem;
        }
        .order-info span {
            font-weight: 700;
            color: #2980b9;
        }
        .order-items {
            font-family: 'Courier New', Courier, monospace;
            color: #6b7280;
            white-space: pre-line;
            max-height: 140px;
            overflow-y: auto;
            border-left: 3px solid #3498db;
            padding-left: 14px;
            margin-bottom: 16px;
            line-height: 1.45;
            font-size: 0.95rem;
        }
        /* Scrollbar for order items */
        .order-items::-webkit-scrollbar {
            width: 8px;
        }
        .order-items::-webkit-scrollbar-thumb {
            background: #3498db;
            border-radius: 4px;
        }
        .form-container {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        select, input[type="text"] {
            padding: 12px 14px;
            font-size: 1rem;
            border: 2px solid #cbd5e1;
            border-radius: 8px;
            transition: border-color 0.3s ease;
            width: 100%;
            color: #1a202c;
        }
        select:focus, input[type="text"]:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 6px rgba(52, 152, 219, 0.4);
        }
        button {
            background-color: #3498db;
            color: white;
            font-weight: 700;
            padding: 14px 0;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }
        button:hover {
            background-color: #1d6fa5;
            box-shadow: 0 6px 18px rgba(26, 99, 167, 0.55);
        }
        .chat-button {
            display: inline-block;
            background: #2d87c7;
            color: white;
            padding: 10px 18px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            position: relative;
            font-size: 0.9rem;
            transition: background-color 0.3s ease;
        }
        .chat-button:hover {
            background-color: #1c5d8a;
        }
        .red-dot {
            position: absolute;
            top: -4px;
            right: -5px;
            background: #e74c3c;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            box-shadow: 0 0 6px rgba(231, 76, 60, 0.7);
        }
        .message {
            background-color: #d4edda;
            color: #155724;
            border: 1.5px solid #c3e6cb;
            padding: 14px 20px;
            margin-bottom: 25px;
            border-radius: 10px;
            font-weight: 600;
            text-align: center;
            box-shadow: 0 3px 10px rgba(40, 167, 69, 0.3);
        }
        .error {
            background-color: #f8d7da;
            color: #842029;
            border: 1.5px solid #f5c2c7;
            padding: 14px 20px;
            margin-bottom: 25px;
            border-radius: 10px;
            font-weight: 600;
            text-align: center;
            box-shadow: 0 3px 10px rgba(220, 53, 69, 0.3);
        }

        /* New Order section styles */
        .new-order-section {
            max-width: 400px;
            margin: 40px auto 80px;
            padding: 28px 30px;
            background: #ffffff;
            border-radius: 14px;
            box-shadow: 0 6px 25px rgba(41, 128, 185, 0.15);
            text-align: center;
            border: 2px solid #2980b9;
            transition: box-shadow 0.3s ease;
        }
        .new-order-section:hover {
            box-shadow: 0 8px 30px rgba(41, 128, 185, 0.3);
        }
        .new-order-section a {
            display: inline-block;
            background-color: #2980b9;
            color: white;
            padding: 15px 40px;
            font-size: 1.3rem;
            font-weight: 700;
            border-radius: 12px;
            text-decoration: none;
            box-shadow: 0 6px 20px rgba(41, 128, 185, 0.4);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }
        .new-order-section a:hover {
            background-color: #1c5a8a;
            box-shadow: 0 8px 28px rgba(28, 90, 138, 0.7);
        }
        @media (max-width: 480px) {
            .orders-grid {
                grid-template-columns: 1fr;
            }
            .new-order-section {
                max-width: 90%;
                margin: 30px auto 60px;
                padding: 20px 18px;
            }
            .new-order-section a {
                padding: 14px 28px;
                font-size: 1.1rem;
            }
        }
        .print-link {
    display: inline-block;
    padding: 12px 28px;
    background-color: #2980b9;
    color: white;
    font-weight: 600;
    font-size: 1rem;
    text-decoration: none;
    border-radius: 8px;
    box-shadow: 0 6px 18px rgba(41, 128, 185, 0.5);
    transition: background-color 0.3s ease;
    cursor: pointer;
    user-select: none;
}

.print-link:hover,
.print-link:focus {
    background-color: #1c5a8a;
    outline: none;
}

.print-link:active {
    background-color: #154a6a;
}
        
    </style>
</head>
<body>
<div class="container">
    <h2>📦 Staff Panel - Manage Orders</h2>

    <c:if test="${not empty success}">
        <p class="message"><c:out value="${success}" /></p>
    </c:if>

    <c:if test="${not empty error}">
        <p class="error"><c:out value="${error}" /></p>
    </c:if>

    <!-- Customer Orders Section -->
    <section aria-label="Customer Orders">
        <h3 style="margin-bottom: 20px; font-size: 1.75rem; color: #2c3e50; font-weight: 700;">
            🧑‍🤝‍🧑 Customer Orders
        </h3>
        <div class="orders-grid">
            <c:forEach var="order" items="${orders}">
                <c:if test="${!order.placedByStaff}">
                    <div class="order-card">
                        <div class="order-header">
                            <div>Order #<span><c:out value="${order.orderId}" /></span></div>
                           <div style="position: relative;">
    <strong>Status:</strong> <c:out value="${order.status}" />
    <c:if test="${order.status == 'Pending'}">
        <span class="red-dot" style="top: -6px; right: -10px;"></span>
    </c:if>
</div>

                        </div>

                        <div class="order-customer">Customer: <strong><c:out value="${order.customerName}" /></strong></div>

                        <div class="order-items" title="Order Items">
                            <c:forEach var="item" items="${order.items}">
                                Item ID: <c:out value="${item.itemId}" /> (Qty: <c:out value="${item.quantity}" />)<br/>
                            </c:forEach>
                        </div>

                        <div class="order-info">Total Amount: <span>LKR <c:out value="${order.totalAmount}" /></span></div>
                        <div class="order-info">Message: <span>
                            <c:out value="${order.staffMessage != null ? order.staffMessage : '-'}" />
                        </span></div>

                        <!-- Process/update form -->
                        <form method="post" action="${pageContext.request.contextPath}/staff/orders" class="form-container" autocomplete="off">
                            <input type="hidden" name="order_id" value="<c:out value='${order.orderId}'/>" />
                            <select name="status" required aria-label="Update order status">
                                <option value="Pending" <c:if test="${order.status == 'Pending'}">selected</c:if>>Pending</option>
                                <option value="Shipped" <c:if test="${order.status == 'Shipped'}">selected</c:if>>Shipped</option>
                                <option value="Delivered" <c:if test="${order.status == 'Delivered'}">selected</c:if>>Delivered</option>
                            </select>
                            <input type="text" name="message" placeholder="Message to customer"
                                   value="<c:out value='${order.staffMessage}'/>" aria-label="Message to customer" />
                            <button type="submit" aria-label="Update order #${order.orderId}">Update Order</button>
                        </form>

                        <div style="margin-top: 16px; text-align: right;">
                            <a href="${pageContext.request.contextPath}/chat?orderId=${order.orderId}" class="chat-button" aria-label="Open chat for order #${order.orderId}">
                                💬 Chat
                                <c:if test="${unreadMap[order.orderId]}">
                                    <span class="red-dot"></span>
                                </c:if>
                            </a>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </section>

    <!-- Staff Added Orders Section -->
    <section aria-label="Staff Created Orders" style="margin-top: 60px;">
        <h3 style="margin-bottom: 20px; font-size: 1.75rem; color: #2c3e50; font-weight: 700;">
            🧑‍💼 Staff Added Orders
        </h3>
        <div class="orders-grid">
            <c:forEach var="order" items="${orders}">
                <c:if test="${order.placedByStaff}">
                    <div class="order-card">
                        <div class="order-header">
                            <div>Order #<span><c:out value="${order.orderId}" /></span></div>
                            <div><strong>Status:</strong> <c:out value="${order.status}" /></div>
                        </div>

                        <div class="order-customer">Customer: <strong><c:out value="${order.customerName}" /></strong></div>

                        <div class="order-info">Placed By Staff: <strong><c:out value="${order.staffName}" /></strong></div>

                        <div class="order-items" title="Order Items">
                            <c:forEach var="item" items="${order.items}">
                                Item ID: <c:out value="${item.itemId}" /> (Qty: <c:out value="${item.quantity}" />)<br/>
                            </c:forEach>
                        </div>

                        <div class="order-info">Total Amount: <span>LKR <c:out value="${order.totalAmount}" /></span></div>
                        <div class="order-info">Message: <span>
                            <c:out value="${order.staffMessage != null ? order.staffMessage : '-'}" />
                        </span></div>

                        <!-- Process/update form -->
                        <form method="post" action="${pageContext.request.contextPath}/staff/orders" class="form-container" autocomplete="off">
                            <input type="hidden" name="order_id" value="<c:out value='${order.orderId}'/>" />
                            <select name="status" required aria-label="Update order status">
                                <option value="Pending" <c:if test="${order.status == 'Pending'}">selected</c:if>>Pending</option>
                                <option value="Shipped" <c:if test="${order.status == 'Shipped'}">selected</c:if>>Shipped</option>
                                <option value="Delivered" <c:if test="${order.status == 'Delivered'}">selected</c:if>>Delivered</option>
                            </select>
                            <input type="text" name="message" placeholder="Message to customer"
                                   value="<c:out value='${order.staffMessage}'/>" aria-label="Message to customer" />
                            <button type="submit" aria-label="Update order #${order.orderId}">Update Order</button>
                        </form>

                        <div style="margin-top: 16px; text-align: right;">
                            <a href="${pageContext.request.contextPath}/chat?orderId=${order.orderId}" class="chat-button" aria-label="Open chat for order #${order.orderId}">
                                💬 Chat
                                <c:if test="${unreadMap[order.orderId]}">
                                    <span class="red-dot"></span>
                                </c:if>
                            </a>
                        </div>
                        <div style="margin-top: 16px; text-align: right; display: flex; gap: 10px; justify-content: flex-end; flex-wrap: wrap;">
<a href="${pageContext.request.contextPath}/staff/printBill?orderId=${order.orderId}" target="_blank" rel="noopener noreferrer" class="print-link">
    🧾 Print Bill
</a>


</div>
                        
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </section>

    <!-- Create New Order button -->
    <section class="new-order-section" aria-label="Create new order section">
        <a href="${pageContext.request.contextPath}/staff/createOrder" role="button" tabindex="0">
            ➕ Create New Order
        </a>
    </section>
</div>

</body>
</html>

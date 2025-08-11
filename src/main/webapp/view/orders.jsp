<%@ page import="java.util.*, com.bookshop.dao.OrderDAO, com.bookshop.model.Order, com.bookshop.model.OrderItem, com.bookshop.dao.DBConnection" %>
<%
    String type = (String) session.getAttribute("userType");
    if (type == null || !"customer".equals(type)) {
        response.sendRedirect(request.getContextPath() + "/view/login.jsp");
        return;
    }

    com.bookshop.model.User user = (com.bookshop.model.User) session.getAttribute("user");
    int userId = (user != null) ? user.getId() : 0;
    List<Order> orders = new ArrayList<>();

    try {
        OrderDAO orderDAO = new OrderDAO(DBConnection.getInstance().getConnection());
        orders = orderDAO.getOrdersByUserId(userId);
    } catch (Exception e) {
        out.println("Error loading orders: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders - Pahana Edu</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
   <style>
        :root {
            --silver-primary: #c0c0c0;
            --silver-light: #e8e8e8;
            --silver-dark: #a0a0a0;
            --silver-bright: #f5f5f5;
            --silver-muted: #b8b8b8;
            
            --black-primary: #0f0f0f;
            --black-secondary: #1a1a1a;
            --black-tertiary: #2a2a2a;
            --black-light: #3a3a3a;
            --black-muted: #4a4a4a;
            
            --glass-silver: rgba(192, 192, 192, 0.08);
            --glass-black: rgba(0, 0, 0, 0.7);
            --glass-border: rgba(192, 192, 192, 0.15);
            
            --shadow-soft: 0 4px 20px rgba(0, 0, 0, 0.15);
            --shadow-medium: 0 8px 30px rgba(0, 0, 0, 0.2);
            --shadow-strong: 0 15px 40px rgba(0, 0, 0, 0.3);
            
            --accent-blue: #4a90e2;
            --success: #22c55e;
            --warning: #f59e0b;
            --danger: #ef4444;
            --info: #06b6d4;
            
            --transition-smooth: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            --border-radius: 12px;
            --border-radius-large: 20px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #0f0f0f 0%, #1a1a1a 50%, #000000 100%);
            background-attachment: fixed;
            color: var(--silver-light);
            overflow-x: hidden;
            min-height: 100vh;
            line-height: 1.6;
        }

        /* Subtle background pattern */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 20%, rgba(192, 192, 192, 0.03) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(192, 192, 192, 0.02) 0%, transparent 50%);
            z-index: -1;
        }

        /* Header */
        .header {
            backdrop-filter: blur(20px);
            background: rgba(15, 15, 15, 0.95);
            border-bottom: 1px solid var(--glass-border);
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: var(--shadow-soft);
        }

        .header strong {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--silver-bright);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .header strong::before {
            content: '\f02d';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            color: var(--accent-blue);
            font-size: 1.2rem;
        }

        .header div:last-child {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }

        .header a {
            color: var(--silver-light);
            text-decoration: none;
            padding: 0.75rem 1.25rem;
            border-radius: var(--border-radius);
            background: rgba(42, 42, 42, 0.8);
            border: 1px solid var(--glass-border);
            transition: var(--transition-smooth);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 500;
            font-size: 0.9rem;
            backdrop-filter: blur(10px);
        }

        .header a:hover {
            background: rgba(74, 144, 226, 0.1);
            border-color: var(--accent-blue);
            color: var(--accent-blue);
            transform: translateY(-1px);
            box-shadow: var(--shadow-soft);
        }

        .header a i {
            font-size: 1rem;
        }

        /* Container */
        .container {
            padding: 3rem 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        h2 {
            text-align: center;
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 600;
            color: var(--silver-bright);
            margin-bottom: 3rem;
            position: relative;
        }

        h2::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: linear-gradient(90deg, transparent, var(--accent-blue), transparent);
            border-radius: 2px;
        }

        /* Table Styles */
        .table-container {
            background: rgba(26, 26, 26, 0.8);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: var(--border-radius-large);
            overflow: hidden;
            box-shadow: var(--shadow-medium);
            margin-bottom: 2rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: transparent;
        }

        th, td {
            padding: 1rem 1.25rem;
            text-align: left;
            vertical-align: top;
            border-bottom: 1px solid var(--glass-border);
        }

        th {
            background: rgba(42, 42, 42, 0.9);
            color: var(--silver-bright);
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        td {
            font-size: 0.9rem;
            color: var(--silver-light);
        }

        tbody tr {
            transition: var(--transition-smooth);
        }

        tbody tr:hover {
            background: rgba(192, 192, 192, 0.05);
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        /* Status Badges */
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            color: white;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        }

        .status-Pending {
            background: linear-gradient(135deg, var(--warning) 0%, #d97706 100%);
        }

        .status-Pending::before {
            content: '\f017';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
        }

        .status-Shipped {
            background: linear-gradient(135deg, var(--info) 0%, #0e7490 100%);
        }

        .status-Shipped::before {
            content: '\f0d1';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
        }

        .status-Delivered {
            background: linear-gradient(135deg, var(--success) 0%, #16a34a 100%);
        }

        .status-Delivered::before {
            content: '\f00c';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
        }

        .status-Cancelled {
            background: linear-gradient(135deg, var(--danger) 0%, #dc2626 100%);
        }

        .status-Cancelled::before {
            content: '\f00d';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
        }

        /* Buttons */
        .chat-btn, .clear-record-btn {
            border: none;
            padding: 0.6rem 1rem;
            cursor: pointer;
            border-radius: var(--border-radius);
            font-size: 0.8rem;
            font-weight: 600;
            transition: var(--transition-smooth);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            backdrop-filter: blur(10px);
        }

        .chat-btn {
            background: var(--accent-blue);
            color: white;
            box-shadow: 0 2px 8px rgba(74, 144, 226, 0.3);
        }

        .chat-btn:hover {
            background: #3a7bc8;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.4);
        }

        .clear-record-btn {
            background: var(--danger);
            color: white;
            margin-left: 0.5rem;
            box-shadow: 0 2px 8px rgba(239, 68, 68, 0.3);
        }

        .clear-record-btn:hover {
            background: #dc2626;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: rgba(26, 26, 26, 0.5);
            border: 1px solid var(--glass-border);
            border-radius: var(--border-radius-large);
            backdrop-filter: blur(20px);
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--silver-dark);
            margin-bottom: 1.5rem;
        }

        .empty-state h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            color: var(--silver-light);
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: var(--silver-muted);
            font-size: 1rem;
        }

        /* Footer */
        footer {
            background: rgba(15, 15, 15, 0.95);
            color: var(--silver-muted);
            text-align: center;
            padding: 2rem 0;
            margin-top: 3rem;
            border-top: 1px solid var(--glass-border);
            backdrop-filter: blur(20px);
        }

        footer::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--accent-blue), transparent);
        }

        /* Book titles styling */
        .book-titles {
            font-weight: 500;
            line-height: 1.4;
        }

        .book-titles strong {
            color: var(--silver-bright);
        }

        /* Staff message styling */
        .staff-message {
            font-style: italic;
            color: var(--silver-muted);
            max-width: 200px;
            word-wrap: break-word;
        }

        .staff-message.empty {
            opacity: 0.6;
        }

        /* Loading states */
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        .btn-loading {
            position: relative;
        }

        .btn-loading::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 16px;
            height: 16px;
            border: 2px solid transparent;
            border-top: 2px solid currentColor;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: translate(-50%, -50%) rotate(0deg); }
            100% { transform: translate(-50%, -50%) rotate(360deg); }
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .container {
                padding: 2rem 1rem;
            }
             
            table {
                font-size: 0.85rem;
            }
            
            th, td {
                padding: 0.75rem 0.5rem;
            }
        }

        @media (max-width: 768px) {
            .header {
                padding: 1rem;
                flex-direction: column;
                gap: 1rem;
            }

            .header div:last-child {
                flex-wrap: wrap;
                justify-content: center;
            }

            .header a span {
                display: none;
            }

            .header a {
                padding: 0.75rem;
            }

            h2 {
                font-size: 2rem;
            }

            /* Make table scrollable on mobile */
            .table-container {
                overflow-x: auto;
            }

            table {
                min-width: 800px;
            }

            th, td {
                padding: 0.5rem;
                font-size: 0.8rem;
            }

            .status-badge {
                font-size: 0.7rem;
                padding: 0.4rem 0.8rem;
            }

            .chat-btn, .clear-record-btn {
                font-size: 0.7rem;
                padding: 0.5rem 0.75rem;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 1rem 0.5rem;
            }

            h2 {
                font-size: 1.75rem;
            }
        }

        /* Animation for page load */
        .fade-in {
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { 
                opacity: 0; 
                transform: translateY(20px);
            }
            to { 
                opacity: 1; 
                transform: translateY(0);
            }
        }

        /* Hover effects for rows */
        .order-row {
            transition: var(--transition-smooth);
            position: relative;
        }

        .order-row::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            width: 3px;
            height: 100%;
            background: var(--accent-blue);
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }

        .order-row:hover::before {
            transform: scaleY(1);
        }
    </style>


    <script>
        function confirmClearOrder(orderId) {
            if (confirm("Are you sure you want to clear this order? This action cannot be undone.")) {
            	window.location.href = "<%=request.getContextPath()%>/order?orderId=" + orderId;

            }
        }

        function chatWithSeller(orderId) {
            alert('Starting chat for Order ID: ' + orderId);
            // Replace with real chat URL/navigation
            // window.location.href = '/chat?orderId=' + orderId;
        }
    </script>
</head>
<body>

<div class="header">
    <div><strong>Pahana EDU Bookshop</strong></div>
    <div>
        <a href="<%= request.getContextPath() %>/view/customerDashboard.jsp"><i class="fas fa-home"></i> Dashboard</a>
        <a href="<%= request.getContextPath() %>/profile"><i class="fas fa-user"></i> My Profile</a>
        <a href="<%= request.getContextPath() %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
</div>

<div class="container">
    <h2>My Orders</h2>

    <% if (!orders.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Book Titles & Quantities</th>
                    <th>Total (LKR)</th>
                    <th>Status</th>
                    <th>Staff Message</th>
                    <th>Chat</th>
                    <th>Clear</th>
                </tr>
            </thead>
            <tbody>
                <% for (Order o : orders) { %>
                    <tr>
                        <td><%= o.getOrderDate() %></td>
                        <td>
                            <%
                                List<OrderItem> items = o.getItems();
                                for (int i = 0; i < items.size(); i++) {
                                    OrderItem item = items.get(i);
                                    out.print(item.getBookTitle() + " (" + item.getQuantity() + ")");
                                    if (i < items.size() - 1) {
                                        out.print(", ");
                                    }
                                }
                            %>
                        </td>
                        <td><%= String.format("%.2f", o.getTotalAmount()) %></td>
                        <td>
                            <% String status = o.getStatus(); %>
                            <span class="status-badge status-<%=status.replaceAll("\\s+", "")%>">
                                <%= status %>
                            </span>
                        </td>
                        <td><%= (o.getStaffMessage() != null && !o.getStaffMessage().trim().isEmpty()) ? o.getStaffMessage() : "-" %></td>
                        <td>
                            <a href="<%= request.getContextPath() %>/chat?orderId=<%= o.getOrderId() %>" class="chat-btn">
    <i class="fas fa-comments"></i> Chat
</a>

                        </td>
                        <td>
                            <button class="clear-record-btn" onclick="confirmClearOrder(<%= o.getOrderId() %>)">
                                <i class="fas fa-trash"></i> Clear
                            </button>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } else { %>
        <p style="text-align:center;">You have not placed any orders yet.</p>
    <% } %>
</div>

<footer>&copy; 2025 Pahana Edu Bookshop</footer>

</body>
</html>

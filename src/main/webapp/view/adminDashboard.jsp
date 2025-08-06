<%@ page session="true" %>
<%
    String userType = (String) session.getAttribute("userType");
    if (userType == null || !userType.equals("admin")) {
        response.sendRedirect(request.getContextPath() + "/view/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Admin Dashboard</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css');

        /* Reset and box sizing */
        * {
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
            margin: 0;
            font-family: 'Inter', sans-serif;
            background: #0a0a0a;
            color: #ffffff;
            overflow: hidden;
        }

        body {
            display: flex;
        }

        /* Sidebar styling */
        .sidebar {
            width: 280px;
            background: linear-gradient(180deg, #111111 0%, #0d0d0d 100%);
            padding: 24px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            display: flex;
            flex-direction: column;
            color: white;
            border-right: 1px solid #1a1a1a;
            box-shadow: 4px 0 20px rgba(0, 0, 0, 0.3);
        }

        .sidebar h2 {
            margin-bottom: 8px;
            color: #ffffff;
            font-weight: 700;
            font-size: 28px;
            letter-spacing: -0.5px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .sidebar h2 i {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .sidebar p {
            margin-bottom: 16px;
            font-size: 14px;
            font-weight: 400;
            color: #9ca3af;
        }

        /* Digital Clock */
        .digital-clock {
            background: linear-gradient(135deg, #1a1a1a 0%, #0f0f0f 100%);
            border: 1px solid #2a2a2a;
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 24px;
            text-align: center;
        }

        .digital-clock .time {
            font-size: 24px;
            font-weight: 700;
            color: #667eea;
            font-family: 'Courier New', monospace;
            letter-spacing: 2px;
        }

        .digital-clock .date {
            font-size: 12px;
            color: #9ca3af;
            margin-top: 4px;
        }

        /* Navigation menu */
        .nav-menu {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 24px;
        }

        .nav-item {
            position: relative;
        }

        /* Sidebar buttons and forms */
        .sidebar button, 
        .sidebar form button {
            width: 100%;
            padding: 16px 20px;
            background: linear-gradient(135deg, #1a1a1a 0%, #0f0f0f 100%);
            border: 1px solid #2a2a2a;
            color: #e5e7eb;
            font-size: 14px;
            font-weight: 500;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-align: left;
            position: relative;
            overflow: hidden;
            font-family: 'Inter', sans-serif;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .sidebar button i {
            width: 18px;
            text-align: center;
            color: #667eea;
            transition: color 0.3s ease;
        }

        .sidebar button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.5s;
        }

        .sidebar button:hover::before {
            left: 100%;
        }

        .sidebar button:hover, 
        .sidebar form button:hover {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            border-color: #3b82f6;
            color: #ffffff;
            transform: translateY(-1px);
            box-shadow: 0 8px 25px rgba(37, 99, 235, 0.3);
        }

        .sidebar button:hover i {
            color: #ffffff;
        }

        .sidebar button:active,
        .sidebar form button:active {
            transform: translateY(0);
        }

        .sidebar form {
            margin: 0;
        }

        /* Special styling for action buttons */
        .action-buttons {
            border-top: 1px solid #1a1a1a;
            padding-top: 16px;
            margin-top: 16px;
        }

        .action-buttons button {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            border-color: #10b981;
        }

        .action-buttons button:hover {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            box-shadow: 0 8px 25px rgba(16, 185, 129, 0.3);
        }

        /* Push logout button to bottom */
        .sidebar form.logout-form {
            margin-top: auto;
        }

        .logout-form button {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%) !important;
            border-color: #ef4444 !important;
        }

        .logout-form button:hover {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%) !important;
            box-shadow: 0 8px 25px rgba(239, 68, 68, 0.3) !important;
        }

        /* Main content area */
        .main-content {
            margin-left: 280px;
            padding: 32px 40px;
            flex: 1;
            height: 100vh;
            overflow-y: auto;
            background: radial-gradient(ellipse at top, #0f0f0f 0%, #0a0a0a 50%, #000000 100%);
        }

        .main-content h1 {
            margin-top: 0;
            margin-bottom: 32px;
            font-weight: 700;
            font-size: 36px;
            text-align: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: -1px;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 16px;
        }

        .main-content h1 i {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .main-content h1::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 2px;
        }

        /* Sections container */
        .section {
            display: none;
            background: linear-gradient(135deg, rgba(17, 17, 17, 0.8) 0%, rgba(13, 13, 13, 0.9) 100%);
            padding: 24px;
            border-radius: 20px;
            box-shadow: 
                0 20px 40px rgba(0, 0, 0, 0.4),
                0 0 0 1px rgba(255, 255, 255, 0.05),
                inset 0 1px 0 rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.1);
            height: calc(100vh - 160px);
            box-sizing: border-box;
            position: relative;
            overflow: hidden;
        }

        .section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
        }

        .section h2 {
            margin: 0 0 20px 0;
            font-size: 24px;
            font-weight: 600;
            color: #ffffff;
            padding-bottom: 12px;
            border-bottom: 2px solid rgba(102, 126, 234, 0.3);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section h2 i {
            color: #667eea;
        }

        /* Make iframe fill the section fully */
        iframe {
            width: 100%;
            height: calc(100% - 60px);
            border: none;
            border-radius: 12px;
            background: #ffffff;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }

        /* Welcome section styling */
        .welcome-section {
            display: block;
            text-align: center;
            padding: 60px 40px;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
        }

        .welcome-section h2 {
            font-size: 32px;
            margin-bottom: 16px;
            color: #ffffff;
            border: none;
            padding: 0;
            justify-content: center;
        }

        .welcome-section p {
            font-size: 18px;
            color: #9ca3af;
            max-width: 500px;
            margin: 0 auto 40px;
            line-height: 1.6;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 24px;
            margin-top: 40px;
        }

        .feature-card {
            background: rgba(255, 255, 255, 0.05);
            padding: 24px;
            border-radius: 16px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            text-align: center;
            transition: transform 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-4px);
            background: rgba(255, 255, 255, 0.08);
        }

        .feature-card i {
            font-size: 32px;
            color: #667eea;
            margin-bottom: 16px;
        }

        .feature-card h3 {
            color: #ffffff;
            margin-bottom: 12px;
            font-size: 20px;
        }

        .feature-card p {
            color: #9ca3af;
            font-size: 14px;
            margin: 0;
        }

        /* Scrollbar styling */
        .main-content::-webkit-scrollbar {
            width: 8px;
        }

        .main-content::-webkit-scrollbar-track {
            background: #0a0a0a;
        }

        .main-content::-webkit-scrollbar-thumb {
            background: linear-gradient(180deg, #667eea, #764ba2);
            border-radius: 4px;
        }

        .main-content::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(180deg, #764ba2, #667eea);
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }
            
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
            
            .main-content h1 {
                font-size: 28px;
            }
        }
    </style>
    <script>
        function showSection(id) {
            const sections = document.querySelectorAll('.section');
            sections.forEach(s => s.style.display = 'none');

            if (id) {
                const target = document.getElementById(id);
                if (target) target.style.display = 'block';
            } else {
                // Show welcome section if no specific section is selected
                const welcomeSection = document.getElementById('welcome-section');
                if (welcomeSection) welcomeSection.style.display = 'block';
            }
        }

        function updateClock() {
            const now = new Date();
            const timeString = now.toLocaleTimeString('en-US', {
                hour12: false,
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            });
            const dateString = now.toLocaleDateString('en-US', {
                weekday: 'short',
                year: 'numeric',
                month: 'short',
                day: 'numeric'
            });
            
            document.getElementById('clock-time').textContent = timeString;
            document.getElementById('clock-date').textContent = dateString;
        }

        window.onload = function() {
            // Show welcome section initially
            showSection(null);
            
            // Start the clock
            updateClock();
            setInterval(updateClock, 1000);
        };
    </script>
</head>
<body>
   <div class="sidebar">
    <h2><i class="fas fa-crown"></i>Admin Panel</h2>
    <p>Welcome, <%= session.getAttribute("fullname") != null ? session.getAttribute("fullname") : "Admin" %></p>

    <!-- Digital Clock -->
    <div class="digital-clock">
        <div class="time" id="clock-time">00:00:00</div>
        <div class="date" id="clock-date">Loading...</div>
    </div>

    <!-- Navigation Menu -->
    <div class="nav-menu">
        <div class="nav-item">
            <button onclick="showSection('add-staff-section')">
                <i class="fas fa-user-plus"></i>Add Staff
            </button>
        </div>
        <div class="nav-item">
            <button onclick="showSection('view-staff-section')">
                <i class="fas fa-users"></i>View Staff
            </button>
        </div>
        <div class="nav-item">
            <button onclick="showSection('customer-manage-section')">
                <i class="fas fa-user-friends"></i>Manage Customers
            </button>
        </div>
        <div class="nav-item">
            <button onclick="showSection('manage-orders-section')">
                <i class="fas fa-shopping-cart"></i>Manage Orders
            </button>
        </div>
        <div class="nav-item">
            <button onclick="showSection('sales-reports-section')">
                <i class="fas fa-chart-line"></i>Sales Reports
            </button>
        </div>
        <div class="nav-item">
            <button onclick="showSection('create-order-section')">
                <i class="fas fa-plus-circle"></i>Create New Order
            </button>
        </div>
    </div>

    <!-- Action Buttons -->
    <div class="action-buttons">
        <form action="<%= request.getContextPath() %>/item" method="get">
            <input type="hidden" name="action" value="new" />
            <button type="submit">
                <i class="fas fa-box"></i>Add Item
            </button>
        </form>

        <form action="<%= request.getContextPath() %>/item" method="get">
            <input type="hidden" name="action" value="list" />
            <button type="submit">
                <i class="fas fa-list"></i>View Items
            </button>
        </form>
    </div>

    <form action="<%= request.getContextPath() %>/logout" method="get" class="logout-form">
        <button type="submit">
            <i class="fas fa-sign-out-alt"></i>Logout
        </button>
    </form>
</div>

<div class="main-content">
    <h1><i class="fas fa-tachometer-alt"></i>Admin Dashboard</h1>

    <!-- Welcome Section -->
    <div class="section welcome-section" id="welcome-section">
        <h2><i class="fas fa-home"></i>Welcome to Your Admin Dashboard</h2>
        <p>Manage your business operations with ease using our comprehensive admin panel. Access all your tools and data from one centralized location.</p>
        
        <div class="feature-grid">
            <div class="feature-card">
                <i class="fas fa-users"></i>
                <h3>Staff Management</h3>
                <p>Add, view, and manage your staff members efficiently</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-heart"></i>
                <h3>Customer Relations</h3>
                <p>Keep track of your customers and their preferences</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-shopping-bag"></i>
                <h3>Order Processing</h3>
                <p>Create and manage orders with streamlined workflows</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-chart-bar"></i>
                <h3>Sales Analytics</h3>
                <p>Monitor your business performance with detailed reports</p>
            </div>
        </div>
    </div>

    <div class="section" id="add-staff-section" style="display: none;">
        <h2><i class="fas fa-user-plus"></i>Add Staff</h2>
        <iframe src="<%= request.getContextPath() %>/view/registerStaff.jsp"></iframe>
    </div>

    <div class="section" id="view-staff-section" style="display: none;">
        <h2><i class="fas fa-users"></i>Staff List</h2>
        <iframe src="<%= request.getContextPath() %>/login?action=listStaff"></iframe>
    </div>

    <div class="section" id="customer-manage-section" style="display: none;">
        <h2><i class="fas fa-user-friends"></i>Customer Management</h2>
        <iframe src="<%= request.getContextPath() %>/admin/customers"></iframe>
    </div>

    <div class="section" id="manage-orders-section" style="display: none;">
        <h2><i class="fas fa-shopping-cart"></i>Manage Orders</h2>
        <iframe src="<%= request.getContextPath() %>/staff/orders"></iframe>
    </div>

    <div class="section" id="sales-reports-section" style="display: none;">
        <h2><i class="fas fa-chart-line"></i>Sales Reports</h2>
        <iframe src="<%= request.getContextPath() %>/reports"></iframe>
    </div>

    <div class="section" id="create-order-section" style="display: none;">
        <h2><i class="fas fa-plus-circle"></i>Create New Order</h2>
        <iframe src="<%= request.getContextPath() %>/staff/createOrder"></iframe>
    </div>
</div>

</body>
</html>
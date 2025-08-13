<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Comprehensive Reports Dashboard</title>
    <style>
        :root {
            --bg-color-light: #f5f7fa;
            --text-color-light: #2c3e50;
            --card-bg-light: #fff;
            --table-header-bg-light: #2980b9;
            --table-row-even-light: #f9f9f9;
            --scrollbar-thumb-light: #2980b9;

            --bg-color-dark: #121212;
            --text-color-dark: #e0e0e0;
            --card-bg-dark: #1e1e1e;
            --table-header-bg-dark: #3498db;
            --table-row-even-dark: #2c2c2c;
            --scrollbar-thumb-dark: #3498db;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 20px;
            background: var(--bg-color-light);
            color: var(--text-color-light);
            transition: background 0.3s, color 0.3s;
        }
        body.dark {
            background: var(--bg-color-dark);
            color: var(--text-color-dark);
        }

        h1 {
            text-align: center;
            margin-bottom: 40px;
            color: inherit;
        }
        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(450px, 1fr));
            gap: 30px;
            max-width: 1400px;
            margin: 0 auto;
        }
        .card {
            background: var(--card-bg-light);
            border-radius: 10px;
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
            padding: 20px;
            display: flex;
            flex-direction: column;
            height: 520px; /* fixed height */
            transition: background 0.3s, color 0.3s;
            color: inherit;
        }
        body.dark .card {
            background: var(--card-bg-dark);
            box-shadow: 0 6px 15px rgba(0,0,0,0.6);
        }

        .card h2 {
            margin-top: 0;
            border-bottom: 3px solid var(--table-header-bg-light);
            padding-bottom: 8px;
            margin-bottom: 15px;
            font-weight: 600;
            color: inherit;
            transition: border-color 0.3s;
        }
        body.dark .card h2 {
            border-color: var(--table-header-bg-dark);
        }

        canvas {
            flex-shrink: 0;
            max-height: 250px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 6px;
            background: #fff;
            transition: background 0.3s;
        }
        body.dark canvas {
            background: #121212;
            border-color: #444;
        }

        .table-container {
            flex-grow: 1;
            overflow-y: auto;
            border: 1px solid #ddd;
            border-radius: 6px;
            background: #fff;
            transition: background 0.3s, border-color 0.3s;
        }
        body.dark .table-container {
            background: #1e1e1e;
            border-color: #444;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
            color: inherit;
        }
        th, td {
            padding: 8px 12px;
            border-bottom: 1px solid #ddd;
            text-align: left;
            transition: background 0.3s;
        }
        body.dark th, body.dark td {
            border-color: #444;
        }

        th {
            background-color: var(--table-header-bg-light);
            color: white;
            position: sticky;
            top: 0;
            z-index: 1;
        }
        body.dark th {
            background-color: var(--table-header-bg-dark);
        }

        tr:nth-child(even) {
            background-color: var(--table-row-even-light);
            transition: background 0.3s;
        }
        body.dark tr:nth-child(even) {
            background-color: var(--table-row-even-dark);
        }

        /* Scrollbar styling */
        .table-container::-webkit-scrollbar {
            width: 8px;
        }
        .table-container::-webkit-scrollbar-track {
            background: var(--bg-color-light);
        }
        .table-container::-webkit-scrollbar-thumb {
            background: var(--scrollbar-thumb-light);
            border-radius: 4px;
        }
        body.dark .table-container::-webkit-scrollbar-track {
            background: var(--bg-color-dark);
        }
        body.dark .table-container::-webkit-scrollbar-thumb {
            background: var(--scrollbar-thumb-dark);
        }

        /* Responsive tweaks */
        @media (max-width: 500px) {
            .card {
                height: auto;
            }
            canvas {
                max-height: 200px;
            }
        }

        /* Toggle & Download Buttons */
        .top-bar {
            max-width: 1400px;
            margin: 0 auto 30px;
            display: flex;
            justify-content: flex-end;
            gap: 15px;
        }
        button {
            padding: 10px 18px;
            font-size: 1rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            background-color: #2980b9;
            color: white;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #1c5980;
        }
        body.dark button {
            background-color: #3498db;
        }
        body.dark button:hover {
            background-color: #5dade2;
        }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

</head>
<body>

    <div class="top-bar">
        <button id="toggleThemeBtn">Switch to Dark Mode</button>
        <button id="downloadPdfBtn">Download PDF</button>
    </div>

    <h1>Shop Reports PahanaEdu Bookshop</h1>

    <div class="dashboard" id="reportArea">

        <!-- Sales Report Card -->
        <div class="card">
            <h2>Sales Reports (by Period)</h2>
            <canvas id="salesChart"></canvas>
            <div class="table-container">
                <table>
                    <thead>
                        <tr><th>Period</th><th>Total Sales (Rs)</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="sales" items="${report.salesReports}">
                            <tr><td>${sales.period}</td><td>${sales.totalSales}</td></tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Order Summary Card -->
        <div class="card">
            <h2>Order Summary by Status</h2>
            <canvas id="orderStatusChart"></canvas>
            <div class="table-container">
                <table>
                    <thead>
                        <tr><th>Status</th><th>Number of Orders</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="summary" items="${report.orderSummaries}">
                            <tr><td>${summary.status}</td><td>${summary.count}</td></tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Top Selling Items Card -->
        <div class="card">
            <h2>Top Selling Items</h2>
            <canvas id="topItemsChart"></canvas>
            <div class="table-container">
                <table>
                    <thead>
                        <tr><th>Item ID</th><th>Title</th><th>Quantity Sold</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${report.topSellingItems}">
                            <tr><td>${item.itemId}</td><td>${item.title}</td><td>${item.totalQuantitySold}</td></tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Staff Performance Card -->
        <div class="card">
            <h2>Staff Performance</h2>
            <canvas id="staffPerformanceChart"></canvas>
            <div class="table-container">
                <table>
                    <thead>
                        <tr><th>Staff ID</th><th>Staff Name</th><th>Orders Handled</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="staff" items="${report.staffPerformances}">
                            <tr><td>${staff.staffId}</td><td>${staff.staffName}</td><td>${staff.ordersHandled}</td></tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- New User Order Counts Card -->
        <div class="card">
            <h2>Customer Order Statistics</h2>
            <canvas id="userOrderChart"></canvas>
            <div class="table-container">
                <table>
                    <thead>
                        <tr><th>User ID</th><th>User Name</th><th>Total Orders</th><th>Total Spent (Rs)</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="userOrder" items="${report.userOrderCounts}">
                            <tr>
                                <td>${userOrder.userId}</td>
                                <td>${userOrder.userName}</td>
                                <td>${userOrder.totalOrders}</td>
                                <td>${userOrder.totalSpent}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

<script>
    // Dark mode toggle logic
    const toggleBtn = document.getElementById('toggleThemeBtn');
    toggleBtn.addEventListener('click', () => {
        document.body.classList.toggle('dark');
        if (document.body.classList.contains('dark')) {
            toggleBtn.textContent = 'Switch to Light Mode';
        } else {
            toggleBtn.textContent = 'Switch to Dark Mode';
        }
    });

    // Prepare data arrays from JSP variables for charts

    const salesLabels = [
        <c:forEach var="sales" items="${report.salesReports}" varStatus="status">
            '${sales.period}'<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    const salesData = [
        <c:forEach var="sales" items="${report.salesReports}" varStatus="status">
            ${sales.totalSales}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    const orderStatusLabels = [
        <c:forEach var="summary" items="${report.orderSummaries}" varStatus="status">
            '${summary.status}'<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    const orderStatusData = [
        <c:forEach var="summary" items="${report.orderSummaries}" varStatus="status">
            ${summary.count}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    const topItemsLabels = [
        <c:forEach var="item" items="${report.topSellingItems}" varStatus="status">
            '${item.title}'<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    const topItemsData = [
        <c:forEach var="item" items="${report.topSellingItems}" varStatus="status">
            ${item.totalQuantitySold}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    const staffLabels = [
        <c:forEach var="staff" items="${report.staffPerformances}" varStatus="status">
            '${staff.staffName}'<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    const staffData = [
        <c:forEach var="staff" items="${report.staffPerformances}" varStatus="status">
            ${staff.ordersHandled}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    // New User Order data
    const userLabels = [
        <c:forEach var="userOrder" items="${report.userOrderCounts}" varStatus="status">
            '${userOrder.userName}'<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    const userOrderData = [
        <c:forEach var="userOrder" items="${report.userOrderCounts}" varStatus="status">
            ${userOrder.totalOrders}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    const userSpentData = [
        <c:forEach var="userOrder" items="${report.userOrderCounts}" varStatus="status">
            ${userOrder.totalSpent}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    // Charts initialization

    new Chart(document.getElementById('salesChart').getContext('2d'), {
        type: 'bar',
        data: {
            labels: salesLabels,
            datasets: [{
                label: 'Total Sales (Rs)',
                data: salesData,
                backgroundColor: 'rgba(41, 128, 185, 0.7)'
            }]
        },
        options: {
            responsive: true,
            scales: { y: { beginAtZero: true } },
            plugins: { legend: { display: false } }
        }
    });

    new Chart(document.getElementById('orderStatusChart').getContext('2d'), {
        type: 'pie',
        data: {
            labels: orderStatusLabels,
            datasets: [{
                label: 'Number of Orders',
                data: orderStatusData,
                backgroundColor: ['#2980b9', '#27ae60', '#c0392b', '#f39c12', '#8e44ad']
            }]
        },
        options: { responsive: true }
    });

    new Chart(document.getElementById('topItemsChart').getContext('2d'), {
        type: 'bar',
        data: {
            labels: topItemsLabels,
            datasets: [{
                label: 'Quantity Sold',
                data: topItemsData,
                backgroundColor: 'rgba(231, 76, 60, 0.7)'
            }]
        },
        options: {
            responsive: true,
            scales: { y: { beginAtZero: true } },
            plugins: { legend: { display: false } }
        }
    });

    new Chart(document.getElementById('staffPerformanceChart').getContext('2d'), {
        type: 'bar',
        data: {
            labels: staffLabels,
            datasets: [{
                label: 'Orders Handled',
                data: staffData,
                backgroundColor: 'rgba(39, 174, 96, 0.7)'
            }]
        },
        options: {
            responsive: true,
            scales: { y: { beginAtZero: true } },
            plugins: { legend: { display: false } }
        }
    });

    // New User Order Chart
    new Chart(document.getElementById('userOrderChart').getContext('2d'), {
        type: 'bar',
        data: {
            labels: userLabels,
            datasets: [{
                label: 'Total Orders',
                data: userOrderData,
                backgroundColor: 'rgba(155, 89, 182, 0.7)',
                yAxisID: 'y'
            }, {
                label: 'Total Spent (Rs)',
                data: userSpentData,
                backgroundColor: 'rgba(230, 126, 34, 0.7)',
                yAxisID: 'y1'
            }]
        },
        options: {
            responsive: true,
            interaction: {
                mode: 'index',
                intersect: false,
            },
            scales: {
                y: {
                    type: 'linear',
                    display: true,
                    position: 'left',
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Number of Orders'
                    }
                },
                y1: {
                    type: 'linear',
                    display: true,
                    position: 'right',
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Amount Spent (Rs)'
                    },
                    grid: {
                        drawOnChartArea: false,
                    },
                }
            }
        }
    });

    // PDF Download logic using jsPDF + html2canvas

    document.getElementById('downloadPdfBtn').addEventListener('click', () => {
        // Dynamically import html2canvas since jspdf doesn't bundle it
        if (!window.html2canvas) {
            const script = document.createElement('script');
            script.src = 'https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js';
            script.onload = generatePDF;
            document.body.appendChild(script);
        } else {
            generatePDF();
        }
    });

    function generatePDF() {
        const { jsPDF } = window.jspdf;
        const pdf = new jsPDF('p', 'pt', 'a4');
        const reportArea = document.getElementById('reportArea');

        // Use html2canvas to capture the report area as canvas
        html2canvas(reportArea, { scale: 2, backgroundColor: document.body.classList.contains('dark') ? '#121212' : '#f5f7fa' }).then(canvas => {
            const imgData = canvas.toDataURL('image/png');

            const imgProps = pdf.getImageProperties(imgData);
            const pdfWidth = pdf.internal.pageSize.getWidth();
            const pdfHeight = (imgProps.height * pdfWidth) / imgProps.width;

            pdf.addImage(imgData, 'PNG', 0, 0, pdfWidth, pdfHeight);
            pdf.save('shop_reports.pdf');
        });
    }
</script>

</body>
</html>
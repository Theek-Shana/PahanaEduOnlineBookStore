<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookshop.model.Item" %>
<%@ page import="java.util.List" %>

<%
    int customerId = (Integer) request.getAttribute("customerId");
    List<Item> items = (List<Item>) request.getAttribute("items");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Order - Add Items (Customer ID: <%= customerId %>)</title>
    <style>
        /* Modern CSS Reset & Variables */
        :root {
            --primary-color: #2563eb;
            --primary-hover: #1d4ed8;
            --success-color: #059669;
            --success-hover: #047857;
            --danger-color: #dc2626;
            --warning-color: #d97706;
            --gray-50: #f9fafb;
            --gray-100: #f3f4f6;
            --gray-200: #e5e7eb;
            --gray-300: #d1d5db;
            --gray-400: #9ca3af;
            --gray-500: #6b7280;
            --gray-600: #4b5563;
            --gray-700: #374151;
            --gray-800: #1f2937;
            --gray-900: #111827;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
            --border-radius: 0.75rem;
            --border-radius-sm: 0.5rem;
            --transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: var(--gray-800);
            line-height: 1.6;
            padding: 1rem;
        }

        .page-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 0;
        }

        .main-card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-xl);
            overflow: hidden;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-hover) 100%);
            color: white;
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="10" r="0.5" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
        }

        .breadcrumb {
            position: relative;
            z-index: 1;
            font-size: 0.875rem;
            margin-bottom: 1rem;
            opacity: 0.9;
        }

        .breadcrumb a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .breadcrumb a:hover {
            color: white;
            text-decoration: underline;
        }

        .header h1 {
            position: relative;
            z-index: 1;
            font-size: 2.25rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .customer-badge {
            position: relative;
            z-index: 1;
            display: inline-block;
            background: rgba(255, 255, 255, 0.2);
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-weight: 600;
            backdrop-filter: blur(10px);
        }

        .content {
            padding: 2rem;
        }

        .search-container {
            margin-bottom: 2rem;
            position: relative;
        }

        .search-input {
            width: 100%;
            max-width: 400px;
            padding: 0.875rem 1rem 0.875rem 3rem;
            font-size: 1rem;
            border: 2px solid var(--gray-200);
            border-radius: var(--border-radius-sm);
            background: var(--gray-50);
            transition: var(--transition);
            box-shadow: var(--shadow-sm);
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
            background: white;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            pointer-events: none;
        }

        .table-container {
            background: white;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--gray-200);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: linear-gradient(135deg, var(--gray-700) 0%, var(--gray-800) 100%);
        }

        thead th {
            color: white;
            font-weight: 600;
            padding: 1.25rem 1rem;
            text-align: center;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        tbody tr {
            transition: var(--transition);
            border-bottom: 1px solid var(--gray-100);
        }

        tbody tr:hover {
            background: var(--gray-50);
            transform: translateY(-1px);
            box-shadow: var(--shadow-sm);
        }

        tbody tr:last-child {
            border-bottom: none;
        }

        tbody td {
            padding: 1.25rem 1rem;
            text-align: center;
            vertical-align: middle;
            font-size: 0.9375rem;
        }

        .item-title {
            font-weight: 600;
            color: var(--gray-800);
            text-align: left;
        }

        .price-cell {
            font-weight: 600;
            color: var(--success-color);
            font-family: 'Courier New', monospace;
        }

        .input-field {
            width: 80px;
            padding: 0.625rem;
            font-size: 0.875rem;
            border: 2px solid var(--gray-200);
            border-radius: var(--border-radius-sm);
            text-align: center;
            transition: var(--transition);
            background: white;
        }

        .input-field:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .discount-input {
            width: 90px;
        }

        .quantity-input {
            width: 90px;
        }

        .subtotal-cell {
            font-weight: 700;
            font-size: 1rem;
            color: var(--gray-800);
            font-family: 'Courier New', monospace;
        }

        tfoot {
            background: var(--gray-50);
            border-top: 2px solid var(--primary-color);
        }

        tfoot td {
            padding: 1.5rem 1rem;
            font-weight: 700;
            font-size: 1.125rem;
            color: var(--gray-800);
            text-align: right;
        }

        .total-label {
            color: var(--primary-color);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .total-amount {
            font-family: 'Courier New', monospace;
            font-size: 1.5rem;
            color: var(--success-color);
        }

        .order-summary {
            background: linear-gradient(135deg, var(--gray-50) 0%, var(--gray-100) 100%);
            border-radius: var(--border-radius);
            padding: 2rem;
            margin: 2rem 0;
            text-align: center;
            border: 1px solid var(--gray-200);
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 1rem;
        }

        .summary-item {
            background: white;
            padding: 1.5rem;
            border-radius: var(--border-radius-sm);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
        }

        .summary-label {
            font-size: 0.875rem;
            color: var(--gray-600);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
        }

        .summary-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--gray-800);
        }

        .summary-total {
            background: linear-gradient(135deg, var(--success-color) 0%, var(--success-hover) 100%);
            color: white;
            border: none;
        }

        .summary-total .summary-label {
            color: rgba(255, 255, 255, 0.8);
        }

        .summary-total .summary-value {
            color: white;
            font-size: 2rem;
        }

        .submit-btn {
            background: linear-gradient(135deg, var(--success-color) 0%, var(--success-hover) 100%);
            color: white;
            font-size: 1.125rem;
            font-weight: 600;
            padding: 1rem 2.5rem;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            transition: var(--transition);
            box-shadow: var(--shadow-lg);
            display: block;
            margin: 2rem auto 0;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            position: relative;
            overflow: hidden;
        }

        .submit-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .submit-btn:hover::before {
            left: 100%;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-xl);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        .note {
            background: rgba(37, 99, 235, 0.1);
            border: 1px solid rgba(37, 99, 235, 0.2);
            border-radius: var(--border-radius-sm);
            padding: 1rem;
            margin-top: 2rem;
            font-size: 0.875rem;
            color: var(--gray-700);
            text-align: center;
        }

        .note strong {
            color: var(--primary-color);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .page-container {
                padding: 1rem 0;
            }

            .header {
                padding: 1.5rem;
            }

            .header h1 {
                font-size: 1.875rem;
            }

            .content {
                padding: 1.5rem;
            }

            .table-container {
                overflow-x: auto;
            }

            table {
                min-width: 600px;
            }

            .summary-grid {
                grid-template-columns: 1fr;
            }

            .submit-btn {
                width: 100%;
                padding: 1.25rem;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 1rem;
            }

            .header h1 {
                font-size: 1.5rem;
            }

            .content {
                padding: 1rem;
            }

            .search-input {
                max-width: 100%;
            }
        }

        /* Loading Animation */
        .loading {
            opacity: 0.7;
            pointer-events: none;
        }

        /* Success Animation */
        @keyframes successPulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .success-animation {
            animation: successPulse 0.3s ease-in-out;
        }
    </style>
</head>
<body>
    <div class="page-container">
        <div class="main-card">
            <div class="header">
                <div class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/staff/createOrder">
                        ← Back to Select Customer
                    </a>
                    <span style="margin: 0 0.5rem; opacity: 0.6;">•</span>
                    <span>Add Items to Order</span>
                </div>
                <h1>Create New Order</h1>
                <div class="customer-badge">
                    Customer ID: <%= customerId %>
                </div>
            </div>

            <div class="content">
                <div class="search-container">
                    <div style="position: relative;">
                        <svg class="search-icon" width="20" height="20" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd"></path>
                        </svg>
                        <input type="text" id="searchInput" class="search-input" placeholder="Search items by title...">
                    </div>
                </div>

                <form action="<%= request.getContextPath() %>/staff/addOrderItems" method="post" id="orderForm">
                    <input type="hidden" name="customerId" value="<%= customerId %>" />

                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th style="text-align: left;">Item</th>
                                    <th>Price (Rs.)</th>
                                    <th>Discount (%)</th>
                                    <th>Quantity</th>
                                    <th>Subtotal (Rs.)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Item item : items) { %>
                                    <tr>
                                        <td class="item-title" data-label="Item"><%= item.getTitle() %></td>
                                        <td class="price-cell price" data-label="Price"><%= String.format("%.2f", item.getPrice()) %></td>
                                        <td data-label="Discount">
                                            <input type="number" min="0" max="100" value="0" name="discount[]" 
                                                   class="input-field discount-input discount" data-price="<%= item.getPrice() %>" />
                                        </td>
                                        <td data-label="Quantity">
                                            <input type="hidden" name="itemId[]" value="<%= item.getItemId() %>" />
                                            <input type="number" name="quantity[]" min="0" value="0" 
                                                   class="input-field quantity-input quantity" />
                                        </td>
                                        <td class="subtotal-cell subtotal" data-label="Subtotal">0.00</td>
                                    </tr>
                                <% } %>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="4" class="total-label">Total Amount:</td>
                                    <td id="totalAmount" class="total-amount">0.00</td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>

                    <div class="order-summary">
                        <div class="summary-grid">
                            <div class="summary-item">
                                <div class="summary-label">Total Items</div>
                                <div class="summary-value" id="totalItems">0</div>
                            </div>
                            <div class="summary-item">
                                <div class="summary-label">Items Selected</div>
                                <div class="summary-value" id="selectedItems">0</div>
                            </div>
                            <div class="summary-item summary-total">
                                <div class="summary-label">Grand Total</div>
                                <div class="summary-value">Rs. <span id="totalAmountSummary">0.00</span></div>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="submit-btn" id="submitBtn">
                        Place Order
                    </button>
                </form>

                <div class="note">
                    <strong>Instructions:</strong> Set the discount percentage and quantity for each item you want to include. 
                    Items with quantity 0 will not be added to the order. Use the search box above to quickly find specific items.
                </div>
            </div>
        </div>
    </div>

    <script>
        // Enhanced calculation with animations
        function calculateTotals() {
            let total = 0;
            let totalQuantity = 0;
            let selectedItems = 0;
            
            const rows = document.querySelectorAll('tbody tr');
            
            rows.forEach(row => {
                const price = parseFloat(row.querySelector('.price').innerText);
                const discountInput = row.querySelector('input.discount');
                const discount = parseFloat(discountInput.value) || 0;
                const qtyInput = row.querySelector('input.quantity');
                const quantity = parseInt(qtyInput.value) || 0;

                // Calculate price after discount
                const discountedPrice = price * (1 - discount / 100);
                
                // Calculate subtotal
                const subtotal = discountedPrice * quantity;
                const subtotalCell = row.querySelector('.subtotal');
                
                // Animate subtotal change
                if (subtotalCell.innerText !== subtotal.toFixed(2)) {
                    subtotalCell.classList.add('success-animation');
                    setTimeout(() => subtotalCell.classList.remove('success-animation'), 300);
                }
                
                subtotalCell.innerText = subtotal.toFixed(2);

                total += subtotal;
                totalQuantity += quantity;
                if (quantity > 0) selectedItems++;

                // Visual feedback for row selection
                if (quantity > 0) {
                    row.style.background = 'rgba(37, 99, 235, 0.05)';
                    row.style.borderLeft = '4px solid var(--primary-color)';
                } else {
                    row.style.background = '';
                    row.style.borderLeft = '';
                }
            });

            // Update totals with animation
            const totalAmountEl = document.getElementById('totalAmount');
            const totalAmountSummaryEl = document.getElementById('totalAmountSummary');
            const totalItemsEl = document.getElementById('totalItems');
            const selectedItemsEl = document.getElementById('selectedItems');

            if (totalAmountEl.innerText !== total.toFixed(2)) {
                totalAmountEl.classList.add('success-animation');
                totalAmountSummaryEl.classList.add('success-animation');
                setTimeout(() => {
                    totalAmountEl.classList.remove('success-animation');
                    totalAmountSummaryEl.classList.remove('success-animation');
                }, 300);
            }

            totalAmountEl.innerText = total.toFixed(2);
            totalAmountSummaryEl.innerText = total.toFixed(2);
            totalItemsEl.innerText = totalQuantity;
            selectedItemsEl.innerText = selectedItems;

            // Update submit button state
            const submitBtn = document.getElementById('submitBtn');
            if (selectedItems > 0) {
                submitBtn.style.opacity = '1';
                submitBtn.style.pointerEvents = 'auto';
            } else {
                submitBtn.style.opacity = '0.6';
                submitBtn.style.pointerEvents = 'none';
            }
        }

        // Event listeners for inputs
        document.querySelectorAll('input.discount, input.quantity').forEach(input => {
            input.addEventListener('input', calculateTotals);
            
            // Add visual feedback on focus
            input.addEventListener('focus', function() {
                this.parentElement.style.transform = 'scale(1.02)';
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'scale(1)';
            });
        });

        // Enhanced search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const rows = document.querySelectorAll('tbody tr');
            let visibleCount = 0;
            
            rows.forEach(row => {
                const itemTitle = row.querySelector('td[data-label="Item"]').innerText.toLowerCase();
                if (itemTitle.includes(searchTerm)) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });

            // Show search results count
            if (searchTerm.length > 0) {
                this.style.borderColor = visibleCount > 0 ? 'var(--success-color)' : 'var(--danger-color)';
            } else {
                this.style.borderColor = 'var(--gray-200)';
            }
        });

        // Form submission with validation and loading state
        document.getElementById('orderForm').addEventListener('submit', function(event) {
            let hasItems = false;
            let totalAmount = 0;
            
            document.querySelectorAll('input.quantity').forEach(input => {
                const quantity = parseInt(input.value);
                if (quantity > 0) {
                    hasItems = true;
                    const row = input.closest('tr');
                    const price = parseFloat(row.querySelector('.price').innerText);
                    const discount = parseFloat(row.querySelector('.discount').value) || 0;
                    const discountedPrice = price * (1 - discount / 100);
                    totalAmount += discountedPrice * quantity;
                }
            });
            
            if (!hasItems) {
                alert('Please select at least one item with quantity greater than 0 to place an order.');
                event.preventDefault();
                return;
            }

            // Show loading state
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.classList.add('loading');
            submitBtn.innerHTML = 'Processing Order...';
            
            // Show confirmation
            const confirmed = confirm(`Confirm order placement?\n\nTotal Items: ${document.getElementById('selectedItems').innerText}\nTotal Amount: Rs. ${totalAmount.toFixed(2)}`);
            
            if (!confirmed) {
                event.preventDefault();
                submitBtn.classList.remove('loading');
                submitBtn.innerHTML = 'Place Order';
            }
        });

        // Initial calculation
        calculateTotals();

        // Add keyboard shortcuts
        document.addEventListener('keydown', function(event) {
            // Ctrl/Cmd + F to focus search
            if ((event.ctrlKey || event.metaKey) && event.key === 'f') {
                event.preventDefault();
                document.getElementById('searchInput').focus();
            }
            
            // Escape to clear search
            if (event.key === 'Escape') {
                const searchInput = document.getElementById('searchInput');
                if (searchInput === document.activeElement) {
                    searchInput.value = '';
                    searchInput.dispatchEvent(new Event('input'));
                    searchInput.blur();
                }
            }
        });

        // Add smooth scrolling for better UX
        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('focus', function() {
                this.scrollIntoView({ behavior: 'smooth', block: 'center' });
            });
        });
    </script>
</body>
</html>
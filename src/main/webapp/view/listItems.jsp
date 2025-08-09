<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.bookshop.model.Item" %>
<!DOCTYPE html>
<html>
<head>
    <title>📚 View Items</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #2c5364, #203a43, #0f2027);
            min-height: 100vh;
            color: #fff;
        }
        h2 {
            text-align: center;
            margin: 40px 0 20px;
            font-weight: 600;
            font-size: 2rem;
        }
        .filter-container {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin: 0 auto 20px;
            flex-wrap: wrap;
        }
        #searchInput, #categoryFilter {
            padding: 10px 16px;
            border-radius: 8px;
            border: none;
            font-size: 16px;
            background-color: rgba(255, 255, 255, 0.1);
            color: #fff;
            outline: none;
        }
        #searchInput {
            width: 300px;
        }
        #categoryFilter {
            width: 200px;
        }
        #categoryFilter option {
            background-color: #2c5364;
            color: #fff;
        }
        table {
            width: 95%;
            margin: 0 auto 60px;
            border-collapse: collapse;
            backdrop-filter: blur(8px);
            background: rgba(255, 255, 255, 0.05);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
            border-radius: 12px;
            overflow: hidden;
        }
        th, td {
            padding: 14px 16px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            text-align: left;
            color: #f5f5f5;
        }
        th {
            background: rgba(255, 255, 255, 0.1);
            font-weight: 600;
        }
        tr:hover {
            background: rgba(255, 255, 255, 0.06);
        }
        .low-stock-row {
            background-color: rgba(231, 76, 60, 0.15);
        }
        .low-stock {
            background-color: #e74c3c;
            color: #fff;
            font-size: 0.75rem;
            font-weight: bold;
            padding: 2px 6px;
            border-radius: 4px;
            margin-left: 8px;
            display: inline-block;
        }
        .button {
            display: inline-block;
            background-color: #1abc9c;
            color: #fff;
            padding: 6px 14px;
            margin: 3px 0;
            text-decoration: none;
            border-radius: 6px;
            font-size: 0.9rem;
            transition: background 0.3s ease;
        }
        .button:hover {
            background-color: #16a085;
        }
        .actions {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        img.book-image {
            width: 70px;
            height: 90px;
            object-fit: cover;
            border-radius: 6px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
        }
        td[colspan="9"] {
            text-align: center;
            color: #ccc;
            padding: 20px;
        }
        @media (max-width: 768px) {
            table {
                font-size: 0.85rem;
            }
            .actions {
                flex-direction: row;
                flex-wrap: wrap;
                gap: 4px;
            }
            .filter-container {
                flex-direction: column;
                align-items: center;
            }
            #searchInput, #categoryFilter {
                width: 280px;
            }
        }
    </style>
</head>
<body>

<h2>📚 Book List</h2>

<div class="filter-container">
    <input type="text" id="searchInput" placeholder="🔍 Search by Title...">
    <select id="categoryFilter">
        <option value="">📚 All Categories</option>
        <!-- Categories will be populated dynamically -->
    </select>
</div>

<table id="itemsTable">
    <thead>
        <tr>
            <th>ID</th>
            <th>Image</th>
            <th>Title</th>
            <th>Author</th>
            <th>Price</th>
            <th>Stock</th>
            <th>Category</th>
            <th>Added By</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
    <%
        List<Item> items = (List<Item>) request.getAttribute("items");
        Set<String> categories = new HashSet<>();
        
        if (items != null && !items.isEmpty()) {
            // Collect all unique categories
            for (Item item : items) {
                if (item.getCategory() != null && !item.getCategory().trim().isEmpty()) {
                    categories.add(item.getCategory().trim());
                }
            }
            
            for (Item item : items) {
                boolean lowStock = item.getStockQuantity() < 10;
    %>
        <tr class="<%= lowStock ? "low-stock-row" : "" %>" data-category="<%= item.getCategory() != null ? item.getCategory().trim() : "" %>">
            <td><%= item.getItemId() %></td>
            <td>
                <%
                    String imgPath = item.getImage();
                    if (imgPath != null && !imgPath.trim().isEmpty()) {
                %>
                    <img class="book-image" src="<%= request.getContextPath() + "/" + imgPath %>" alt="Book Image" />
                <%
                    } else {
                %>
                    No Image
                <%
                    }
                %>
            </td>
            <td><%= item.getTitle() %></td>
            <td><%= item.getAuthor() %></td>
            <td>Rs. <%= item.getPrice() %></td>
            <td>
                <%= item.getStockQuantity() %>
                <% if (lowStock) { %>
                    <span class="low-stock">⚠ Low Stock</span>
                <% } %>
            </td>
            <td><%= item.getCategory() %></td>
            <td><%= (item.getAddedBy() != null && !item.getAddedBy().trim().isEmpty()) ? item.getAddedBy() : "Unknown" %></td>
            <td class="actions">
                <a class="button" href="<%=request.getContextPath()%>/item?action=edit&id=<%= item.getItemId() %>">Edit</a>
                <a class="button" href="<%=request.getContextPath()%>/item?action=delete&id=<%= item.getItemId() %>" onclick="return confirm('Are you sure you want to delete this item?');">Delete</a>
            </td>
        </tr>
    <%
            }
        } else {
    %>
        <tr>
            <td colspan="9">No items found.</td>
        </tr>
    <%
        }
    %>
    </tbody>
</table>

<script>
    // Populate category dropdown
    const categoryFilter = document.getElementById('categoryFilter');
    const categories = [
        <% 
        boolean first = true;
        for (String category : categories) { 
            if (!first) out.print(", ");
            out.print("'" + category.replace("'", "\\'") + "'");
            first = false;
        }
        %>
    ];
    
    // Sort categories alphabetically
    categories.sort();
    
    // Add categories to dropdown
    categories.forEach(category => {
        const option = document.createElement('option');
        option.value = category;
        option.textContent = category;
        categoryFilter.appendChild(option);
    });

    // Filter functionality
    function filterTable() {
        const searchFilter = document.getElementById('searchInput').value.toLowerCase();
        const categoryFilterValue = document.getElementById('categoryFilter').value;
        const rows = document.querySelectorAll('#itemsTable tbody tr');

        rows.forEach(row => {
            const titleCell = row.cells[2];
            const categoryData = row.getAttribute('data-category');
            
            if (titleCell) {
                const title = titleCell.textContent.toLowerCase();
                const titleMatch = title.includes(searchFilter);
                const categoryMatch = categoryFilterValue === '' || categoryData === categoryFilterValue;
                
                row.style.display = (titleMatch && categoryMatch) ? '' : 'none';
            }
        });
    }

    // Event listeners
    document.getElementById('searchInput').addEventListener('keyup', filterTable);
    document.getElementById('categoryFilter').addEventListener('change', filterTable);
</script>

</body>
</html>
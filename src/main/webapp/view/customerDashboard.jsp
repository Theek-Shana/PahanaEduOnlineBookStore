<%@ page import="java.sql.*, java.util.*, com.bookshop.dao.DBConnection, com.bookshop.dao.OrderDAO, com.bookshop.model.Order" %>
<%
    String type = (String) session.getAttribute("userType");
    if (type == null || !"customer".equals(type)) {
        response.sendRedirect(request.getContextPath() + "/view/login.jsp");
        return;
    }

    com.bookshop.model.User user = (com.bookshop.model.User) session.getAttribute("user");

    // Item class supports generic items, not just books
    class Item {
        int itemId;
        String title, author, image, description, category;
        double price;
        int stock;

        Item(int itemId, String title, String author, String image, String description, String category, double price, int stock) {
            this.itemId = itemId;
            this.title = title;
            this.author = author;
            this.image = image;
            this.description = description;
            this.category = category;
            this.price = price;
            this.stock = stock;
        }
    }

    // Get search parameters from request for filtering
    String searchTitle = request.getParameter("searchTitle") != null ? request.getParameter("searchTitle").trim() : "";
    String searchAuthor = request.getParameter("searchAuthor") != null ? request.getParameter("searchAuthor").trim() : "";
    String searchCategory = request.getParameter("searchCategory") != null ? request.getParameter("searchCategory").trim() : "";
    String priceMinStr = request.getParameter("priceMin");
    String priceMaxStr = request.getParameter("priceMax");

    double priceMin = 0;
    double priceMax = Double.MAX_VALUE;

    try {
        if (priceMinStr != null && !priceMinStr.isEmpty()) priceMin = Double.parseDouble(priceMinStr);
        if (priceMaxStr != null && !priceMaxStr.isEmpty()) priceMax = Double.parseDouble(priceMaxStr);
    } catch (NumberFormatException e) {
        // ignore invalid numbers, use defaults
    }

    List<Item> items = new ArrayList<>();
    try {
        Connection conn = DBConnection.getInstance().getConnection();

        StringBuilder sql = new StringBuilder("SELECT * FROM item WHERE price BETWEEN ? AND ? ");
        List<String> params = new ArrayList<>();
        params.add(Double.toString(priceMin));
        params.add(Double.toString(priceMax));

        if (!searchTitle.isEmpty()) sql.append(" AND title LIKE ? ");
        if (!searchAuthor.isEmpty()) sql.append(" AND author LIKE ? ");
        if (!searchCategory.isEmpty()) sql.append(" AND category LIKE ? ");

        sql.append(" ORDER BY created_at DESC");

        PreparedStatement ps = conn.prepareStatement(sql.toString());

        int idx = 1;
        ps.setDouble(idx++, priceMin);
        ps.setDouble(idx++, priceMax);
        if (!searchTitle.isEmpty()) ps.setString(idx++, "%" + searchTitle + "%");
        if (!searchAuthor.isEmpty()) ps.setString(idx++, "%" + searchAuthor + "%");
        if (!searchCategory.isEmpty()) ps.setString(idx++, "%" + searchCategory + "%");

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            items.add(new Item(
                rs.getInt("item_id"),
                rs.getString("title"),
                rs.getString("author"),
                rs.getString("image"),
                rs.getString("description"),
                rs.getString("category"),
                rs.getDouble("price"),
                rs.getInt("stock_quantity")
            ));
        }

    } catch (Exception e) {
        out.println("Error loading items: " + e.getMessage());
    }

    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    int cartCount = 0;
    if (cart != null) {
        for (int qty : cart.values()) cartCount += qty;
    }

    int userId = (user != null) ? user.getId() : 0;
    List<Order> userOrders = new ArrayList<>();
    if (userId > 0) {
        try {
            OrderDAO orderDAO = new OrderDAO(DBConnection.getInstance().getConnection());
            userOrders = orderDAO.getOrdersByUserId(userId);
        } catch (Exception e) {
            out.println("Error loading orders: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Customer Dashboard - Pahana Edu</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">

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
    padding: 1rem 2rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
    position: sticky;
    top: 0;
    z-index: 1000;
    box-shadow: var(--shadow-soft);
  }

  .logo {
    font-family: 'Playfair Display', serif;
    font-size: 1.8rem;
    font-weight: 600;
    color: var(--silver-bright);
    display: flex;
    align-items: center;
    gap: 0.5rem;
    text-decoration: none;
  }

  .logo i {
    color: var(--accent-blue);
    font-size: 1.5rem;
  }

  .nav-icons {
    display: flex;
    gap: 0.5rem;
    align-items: center;
  }

  .nav-icon {
    position: relative;
    padding: 0.75rem 1.25rem;
    border-radius: var(--border-radius);
    background: rgba(42, 42, 42, 0.8);
    border: 1px solid var(--glass-border);
    color: var(--silver-light);
    text-decoration: none;
    transition: var(--transition-smooth);
    backdrop-filter: blur(10px);
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-weight: 500;
    font-size: 0.9rem;
  }

  .nav-icon:hover {
    background: rgba(74, 144, 226, 0.1);
    border-color: var(--accent-blue);
    color: var(--accent-blue);
    transform: translateY(-1px);
    box-shadow: var(--shadow-soft);
  }

  .nav-icon i {
    font-size: 1.1rem;
  }

  .badge {
    position: absolute;
    top: -6px;
    right: -6px;
    background: var(--accent-blue);
    color: white;
    font-size: 0.75rem;
    padding: 0.25rem 0.5rem;
    border-radius: 10px;
    font-weight: 600;
    min-width: 20px;
    text-align: center;
    box-shadow: 0 2px 8px rgba(74, 144, 226, 0.3);
  }

  /* Main Navigation */
  .main-nav {
    background: rgba(26, 26, 26, 0.95);
    backdrop-filter: blur(15px);
    border-bottom: 1px solid var(--glass-border);
    padding: 1rem 0;
    text-align: center;
  }

  .nav-links {
    display: flex;
    justify-content: center;
    gap: 1rem;
    flex-wrap: wrap;
  }

  .nav-link {
    color: var(--silver-light);
    text-decoration: none;
    font-weight: 500;
    padding: 0.75rem 1.5rem;
    border-radius: var(--border-radius);
    transition: var(--transition-smooth);
    background: rgba(42, 42, 42, 0.5);
    border: 1px solid transparent;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .nav-link:hover {
    background: rgba(74, 144, 226, 0.1);
    border-color: var(--accent-blue);
    color: var(--accent-blue);
    transform: translateY(-1px);
  }

  .nav-link i {
    font-size: 1rem;
  }

  /* Welcome Section */
.welcome-section {
  position: relative;
  text-align: center;
  padding: 4rem 2rem;
  min-height: 300px;
background: 
  linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), 
  url('../uploads/book.jpg') no-repeat center center / cover;
}


  .welcome-title {
    font-family: 'Playfair Display', serif;
    font-size: 2.5rem;
    font-weight: 600;
    margin-bottom: 1rem;
    color: var(--silver-bright);
    letter-spacing: -0.02em;
  }

  .welcome-subtitle {
    font-size: 1.1rem;
    opacity: 0.8;
    margin-bottom: 2rem;
    color: var(--silver-muted);
  }

  /* Search Form */
  .search-container {
    max-width: 1200px;
    margin: 0 auto 3rem;
    padding: 0 2rem;
  }

  .search-form {
    background: rgba(26, 26, 26, 0.8);
    backdrop-filter: blur(20px);
    border: 1px solid var(--glass-border);
    border-radius: var(--border-radius-large);
    padding: 2rem;
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;
    box-shadow: var(--shadow-medium);
  }

  .form-group {
    position: relative;
  }

  .form-input, .form-select {
    width: 100%;
    padding: 0.875rem 1rem;
    border: 1px solid var(--glass-border);
    border-radius: var(--border-radius);
    background: rgba(42, 42, 42, 0.8);
    color: var(--silver-light);
    font-size: 0.9rem;
    font-weight: 400;
    transition: var(--transition-smooth);
    outline: none;
    font-family: 'Inter', sans-serif;
  }

  .form-input::placeholder {
    color: var(--silver-muted);
  }

  .form-input:focus, .form-select:focus {
    border-color: var(--accent-blue);
    background: rgba(58, 58, 58, 0.9);
    box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
  }

  .search-btn {
    background: var(--accent-blue);
    color: white;
    border: none;
    padding: 0.875rem 1.5rem;
    border-radius: var(--border-radius);
    font-weight: 600;
    font-size: 0.9rem;
    cursor: pointer;
    transition: var(--transition-smooth);
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    box-shadow: 0 2px 8px rgba(74, 144, 226, 0.3);
  }

  .search-btn:hover {
    background: #3a7bc8;
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(74, 144, 226, 0.4);
  }

  /* Items Container */
  .items-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 2rem 3rem;
  }

  .section-title {
    text-align: center;
    font-family: 'Playfair Display', serif;
    font-size: 2rem;
    font-weight: 600;
    color: var(--silver-bright);
    margin-bottom: 2.5rem;
  }

  .items-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: 1.5rem;
  }

  .item-card {
    background: rgba(26, 26, 26, 0.8);
    backdrop-filter: blur(20px);
    border: 1px solid var(--glass-border);
    border-radius: var(--border-radius-large);
    overflow: hidden;
    transition: var(--transition-smooth);
    box-shadow: var(--shadow-soft);
    cursor: pointer;
  }

  .item-card:hover {
    transform: translateY(-4px);
    box-shadow: var(--shadow-medium);
    border-color: var(--silver-dark);
  }

  .item-image-container {
    position: relative;
    overflow: hidden;
    height: 240px;
  }

  .item-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
  }

  .item-card:hover .item-image {
    transform: scale(1.05);
  }

  .item-details {
    padding: 1.5rem;
    color: var(--silver-light);
  }

  .item-title {
    font-family: 'Playfair Display', serif;
    font-size: 1.2rem;
    font-weight: 600;
    margin-bottom: 0.75rem;
    line-height: 1.3;
    color: var(--silver-bright);
  }

  .item-meta {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    margin-bottom: 1rem;
    font-size: 0.85rem;
    color: var(--silver-muted);
  }

  .meta-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .meta-item i {
    width: 16px;
    text-align: center;
    color: var(--accent-blue);
    font-size: 0.9rem;
  }

  .item-description {
    font-size: 0.9rem;
    line-height: 1.5;
    color: var(--silver-muted);
    margin-bottom: 1.5rem;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }

  .item-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 1rem;
    padding-top: 1rem;
    border-top: 1px solid var(--glass-border);
  }

  .price-container {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
  }

  .item-price {
    font-size: 1.3rem;
    font-weight: 700;
    color: var(--silver-bright);
    font-family: 'Inter', sans-serif;
  }

  .stock-info {
    font-size: 0.8rem;
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  .stock-available {
    color: var(--success);
  }

  .stock-low {
    color: var(--warning);
  }

  .stock-out {
    color: var(--danger);
  }

  .add-to-cart-btn {
    background: var(--accent-blue);
    color: white;
    border: none;
    padding: 0.75rem 1.25rem;
    border-radius: var(--border-radius);
    font-weight: 600;
    font-size: 0.85rem;
    cursor: pointer;
    transition: var(--transition-smooth);
    display: flex;
    align-items: center;
    gap: 0.5rem;
    box-shadow: 0 2px 8px rgba(74, 144, 226, 0.3);
    min-width: 140px;
    justify-content: center;
  }

  .add-to-cart-btn:hover:not(:disabled) {
    background: #3a7bc8;
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(74, 144, 226, 0.4);
  }

  .add-to-cart-btn:disabled {
    background: var(--black-muted);
    color: var(--silver-muted);
    cursor: not-allowed;
    box-shadow: none;
  }

  /* Empty State */
  .empty-state {
    text-align: center;
    padding: 4rem 2rem;
    color: var(--silver-muted);
    grid-column: 1 / -1;
    background: rgba(26, 26, 26, 0.5);
    border: 1px solid var(--glass-border);
    border-radius: var(--border-radius-large);
  }

  .empty-state i {
    font-size: 3rem;
    margin-bottom: 1rem;
    color: var(--silver-dark);
  }

  .empty-state h3 {
    font-family: 'Playfair Display', serif;
    font-size: 1.5rem;
    margin-bottom: 0.5rem;
    color: var(--silver-light);
  }

  /* Footer */
  .footer {
    background: rgba(15, 15, 15, 0.95);
    color: var(--silver-muted);
    text-align: center;
    padding: 2rem 0;
    margin-top: 3rem;
    border-top: 1px solid var(--glass-border);
  }

  .footer p {
    font-size: 0.9rem;
    margin-bottom: 0.25rem;
  }

  /* Floating Cart Button */
  .floating-cart-btn {
    position: fixed;
    bottom: 2rem;
    right: 2rem;
    z-index: 999;
  }

  .fab-link {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 60px;
    height: 60px;
    background: var(--accent-blue);
    border-radius: 50%;
    color: white;
    text-decoration: none;
    box-shadow: 0 4px 20px rgba(74, 144, 226, 0.4);
    transition: var(--transition-smooth);
    position: relative;
  }

  .fab-link:hover {
    transform: scale(1.1);
    box-shadow: 0 8px 25px rgba(74, 144, 226, 0.5);
  }

  .fab-link i {
    font-size: 1.3rem;
  }

  .fab-badge {
    position: absolute;
    top: -6px;
    right: -6px;
    background: var(--danger);
    color: white;
    font-size: 0.75rem;
    padding: 0.25rem 0.5rem;
    border-radius: 10px;
    font-weight: 600;
    min-width: 20px;
    text-align: center;
  }

  /* Scroll to Top Button */
  .scroll-to-top {
    position: fixed;
    bottom: 2rem;
    left: 2rem;
    width: 50px;
    height: 50px;
    background: rgba(26, 26, 26, 0.9);
    border: 1px solid var(--glass-border);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--silver-light);
    cursor: pointer;
    opacity: 0;
    transform: translateY(20px);
    transition: var(--transition-smooth);
    z-index: 998;
    backdrop-filter: blur(10px);
  }
  
  .btn-add-to-cart {
  background-color: #28a745;
  color: white;
  padding: 10px 20px;
  font-weight: bold;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.btn-add-to-cart:hover {
  background-color: #218838;
}

.btn-add-to-cart:disabled {
  background-color: #ccc;
  cursor: not-allowed;
  color: #666;
}
  

  .scroll-to-top:hover {
    background: var(--accent-blue);
    color: white;
    transform: scale(1.1) translateY(0);
  }

  .scroll-to-top i {
    font-size: 1.1rem;
  }

  /* Responsive Design */
  @media (max-width: 768px) {
    .header {
      padding: 1rem;
      flex-direction: column;
      gap: 1rem;
    }

    .logo {
      font-size: 1.5rem;
    }

    .nav-icons {
      gap: 0.5rem;
      flex-wrap: wrap;
    }

    .nav-icon span {
      display: none;
    }

    .nav-icon {
      padding: 0.75rem;
    }

    .welcome-title {
      font-size: 2rem;
    }

    .search-form {
      grid-template-columns: 1fr;
      padding: 1.5rem;
    }

    .items-grid {
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 1rem;
    }

    .nav-links {
      gap: 0.5rem;
    }

    .nav-link span {
      display: none;
    }

    .nav-link {
      padding: 0.75rem;
    }

    .section-title {
      font-size: 1.75rem;
    }

    .floating-cart-btn,
    .scroll-to-top {
      bottom: 1rem;
    }

    .floating-cart-btn {
      right: 1rem;
    }

    .scroll-to-top {
      left: 1rem;
    }
  }

  @media (max-width: 480px) {
    .welcome-title {
      font-size: 1.75rem;
    }

    .items-grid {
      grid-template-columns: 1fr;
    }

    .item-card,
    .search-form {
      margin: 0 0.5rem;
    }
  }

  /* Loading States */
  .loading {
    opacity: 0.6;
    pointer-events: none;
  }

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
</style>

</head>
<body>
  <!-- Header -->
  <header class="header">
    <a href="<%= request.getContextPath() %>/customer/dashboard" class="logo">
      <i class="fas fa-book-open"></i>
      <span>Pahana EDU</span>
    </a>
    <nav class="nav-icons">
      <a href="cart.jsp" class="nav-icon">
        <i class="fas fa-shopping-cart"></i>
        <span>Cart</span>
        <% if (cartCount > 0) { %>
          <span class="badge"><%= cartCount %></span>
        <% } %>
      </a>
      <a href="<%= request.getContextPath() %>/profile" class="nav-icon">
        <i class="fas fa-user-circle"></i>
        <span>Profile</span>
      </a>
      <a href="<%= request.getContextPath() %>/view/orders.jsp" class="nav-icon">
        <i class="fas fa-box-open"></i>
        <span>Orders</span>
        <% if (userOrders != null && !userOrders.isEmpty()) { %>
          <span class="badge"><%= userOrders.size() %></span>
        <% } %>
      </a>
      <form action="<%= request.getContextPath() %>/logout" method="get" style="display:inline;">
        <button type="submit" class="nav-icon" style="border: none; background: none;" title="Logout">
          <i class="fas fa-sign-out-alt"></i>
          <span>Logout</span>
        </button>
      </form>
    </nav>
  </header>

  <!-- Main Navigation -->
  <nav class="main-nav">
    <div class="nav-links">
      <a href="<%= request.getContextPath() %>/customer/dashboard" class="nav-link">
        <i class="fas fa-home"></i>
        <span>Home</span>
      </a>
      <a href="<%= request.getContextPath() %>/customer/items" class="nav-link">
        <i class="fas fa-book"></i>
        <span>Items</span>
      </a>
      <a href="<%= request.getContextPath() %>/customer/categories" class="nav-link">
        <i class="fas fa-tags"></i>
        <span>Categories</span>
      </a>
      <a href="<%= request.getContextPath() %>/private-chat?customerId=<%= ((com.bookshop.model.User) session.getAttribute("user")).getId() %>" class="nav-link">
        <i class="fas fa-comments"></i>
        <span>Chat with Staff</span>
      </a>
    </div>
  </nav>

  <!-- Welcome Section -->
  <section class="welcome-section">
    <h1 class="welcome-title">Welcome, <%= (user != null) ? user.getFullname() : "Guest" %>!</h1>
    <p class="welcome-subtitle">Discover knowledge, explore literature, and find your next great read</p>
  </section>

  <!-- Search Section -->
  <div class="search-container">
    <form method="get" action="customerDashboard.jsp" class="search-form" autocomplete="off">
      <div class="form-group">
        <input type="text" name="searchTitle" placeholder="Search by title..." value="<%= searchTitle %>" class="form-input" />
      </div>
      <div class="form-group">
        <input type="text" name="searchAuthor" placeholder="Author name..." value="<%= searchAuthor %>" class="form-input" />
      </div>
      <div class="form-group">
        <select name="searchCategory" class="form-select">
          <option value="">All Categories</option>
          <%
              Set<String> categories = new TreeSet<>();
              for (Item item : items) {
                  if (item.category != null && !item.category.trim().isEmpty()) {
                      categories.add(item.category.trim());
                  }
              }
              for (String cat : categories) {
                  boolean selected = cat.equalsIgnoreCase(searchCategory);
          %>
              <option value="<%= cat %>" <%= selected ? "selected" : "" %>><%= cat.substring(0,1).toUpperCase() + cat.substring(1).toLowerCase() %></option>
          <%
              }
          %>
        </select>
      </div>
      <div class="form-group">
        <input type="number" name="priceMin" min="0" step="0.01" placeholder="Min Price (LKR)" value="<%= (priceMin > 0) ? priceMin : "" %>" class="form-input" />
      </div>
      <div class="form-group">
        <input type="number" name="priceMax" min="0" step="0.01" placeholder="Max Price (LKR)" value="<%= (priceMax != Double.MAX_VALUE) ? priceMax : "" %>" class="form-input" />
      </div>
      <div class="form-group">
        <button type="submit" class="search-btn">
          <i class="fas fa-search"></i>
          <span>Search Items</span>
        </button>
      </div>
    </form>
  </div>

  <!-- Items Section -->
  <div class="items-container">
    <h2 class="section-title">Our Collection</h2>

    <div class="items-grid">
      <% if (items.isEmpty()) { %>
        <div class="empty-state">
          <i class="fas fa-book-open"></i>
          <h3>No Books Found</h3>
          <p>Try adjusting your search criteria to discover more books</p>
        </div>
      <% } else { %>
        <% for (Item item : items) { %>
          <div class="item-card fade-in">
            <div class="item-image-container">
              <img 
                src="<%= request.getContextPath() + "/" + ((item.image != null && !item.image.trim().isEmpty()) ? item.image : "uploads/default.jpg") %>" 
                alt="<%= item.title %>" 
                class="item-image"
                loading="lazy"
              />
            </div>

            <div class="item-details">
              <h3 class="item-title"><%= item.title %></h3>

              <div class="item-meta">
                <div class="meta-item">
                  <i class="fas fa-user"></i>
                  <span><%= item.author != null && !item.author.trim().isEmpty() ? item.author : "Unknown Author" %></span>
                </div>
                <div class="meta-item">
                  <i class="fas fa-tag"></i>
                  <span><%= item.category != null && !item.category.trim().isEmpty() ? item.category : "General" %></span>
                </div>
              </div>

              <p class="item-description"><%= item.description != null ? item.description : "A great addition to your library." %></p>

              <div class="item-footer">
                <div class="price-container">
                  <span class="item-price">LKR <%= String.format("%.2f", item.price) %></span>
                  <span class="stock-info 
                    <%= item.stock > 10 ? "stock-available" : (item.stock > 0 ? "stock-low" : "stock-out") %>">
                    <%= item.stock > 0 ? (item.stock > 10 ? "In Stock" : "Low Stock") : "Out of Stock" %>
                  </span>
                </div>
        <form method="post" action="<%= request.getContextPath() %>/cart">
  <input type="hidden" name="bookId" value="<%= item.itemId %>" />
  <button class="btn-add-to-cart" <% if (item.stock <= 0) { %> disabled <% } %> >
    <%= item.stock <= 0 ? "Out of Stock" : "Add to Cart" %>
  </button>
</form>

              </div>
            </div>
          </div>
        <% } %>
      <% } %>
    </div>
  </div>

  <!-- Footer -->
  <footer class="footer">
    <div>
      <p>&copy; 2025 Pahana Edu Bookshop | Quality Literature for Every Reader</p>
      <p>Connecting readers with knowledge since day one</p>
    </div>
  </footer>

  <!-- Floating Cart Button -->
  <% if (cartCount > 0) { %>
  <div class="floating-cart-btn">
    <a href="cart.jsp" class="fab-link">
      <i class="fas fa-shopping-cart"></i>
      <span class="fab-badge"><%= cartCount %></span>
    </a>
  </div>
  <% } %>

  <!-- Scroll to Top Button -->
  <div class="scroll-to-top">
    <i class="fas fa-arrow-up"></i>
  </div>

  <script>
    // Smooth scroll functionality
    function setupScrollToTop() {
      const scrollBtn = document.querySelector('.scroll-to-top');
      
      window.addEventListener('scroll', () => {
        if (window.pageYOffset > 300) {
          scrollBtn.style.opacity = '1';
          scrollBtn.style.transform = 'translateY(0)';
        } else {
          scrollBtn.style.opacity = '0';
          scrollBtn.style.transform = 'translateY(20px)';
        }
      });
      
      scrollBtn.addEventListener('click', () => {
        window.scrollTo({
          top: 0,
          behavior: 'smooth'
        });
      });
    }

    // Enhanced button interactions
    function setupButtonInteractions() {
      const buttons = document.querySelectorAll('.add-to-cart-btn:not(:disabled)');
      buttons.forEach(button => {
        button.addEventListener('click', function(e) {
          if (!this.disabled) {
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i><span>Adding...</span>';
            this.disabled = true;
            
            // Re-enable button after form submission attempt
            setTimeout(() => {
              if (this.disabled) {
                this.innerHTML = '<i class="fas fa-plus"></i><span>Add to Cart</span>';
                this.disabled = false;
              }
            }, 2000);
          }
        });
      });
    }

    // Form enhancements
    function enhanceSearchForm() {
      const form = document.querySelector('.search-form');
      const inputs = form.querySelectorAll('input, select');
      
      inputs.forEach(input => {
        input.addEventListener('focus', () => {
          input.closest('.form-group').style.transform = 'translateY(-1px)';
        });

        input.addEventListener('blur', () => {
          input.closest('.form-group').style.transform = 'translateY(0)';
        });
      });

      // Auto-submit on Enter key
      inputs.forEach(input => {
        if (input.type !== 'submit') {
          input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
              form.submit();
            }
          });
        }
      });
    }

    // Card animations on scroll
    function setupScrollAnimations() {
      const cards = document.querySelectorAll('.item-card');
      
      const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry, index) => {
          if (entry.isIntersecting) {
            setTimeout(() => {
              entry.target.style.opacity = '1';
              entry.target.style.transform = 'translateY(0)';
            }, index * 50);
          }
        });
      }, {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
      });

      cards.forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        card.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
        observer.observe(card);
      });
    }

    // Mobile menu enhancement
    function setupMobileEnhancements() {
      if (window.innerWidth <= 768) {
        // Add mobile-specific interactions
        const navIcons = document.querySelectorAll('.nav-icon');
        navIcons.forEach(icon => {
          icon.addEventListener('touchstart', () => {
            icon.style.transform = 'scale(0.95)';
          });
          
          icon.addEventListener('touchend', () => {
            icon.style.transform = 'scale(1)';
          });
        });
      }
    }

    // Performance optimizations
    function optimizeImages() {
      const images = document.querySelectorAll('.item-image');
      images.forEach(img => {
        img.addEventListener('load', () => {
          img.style.opacity = '1';
        });
        
        img.addEventListener('error', () => {
          img.src = '<%= request.getContextPath() %>/uploads/default.jpg';
        });
      });
    }

    // Initialize all functionality
    document.addEventListener('DOMContentLoaded', function() {
      setupScrollToTop();
      setupButtonInteractions();
      enhanceSearchForm();
      setupScrollAnimations();
      setupMobileEnhancements();
      optimizeImages();

      // Add smooth page transitions
      document.body.style.opacity = '0';
      document.body.style.transition = 'opacity 0.3s ease-in-out';
      
      setTimeout(() => {
        document.body.style.opacity = '1';
      }, 100);
    });

    // Handle form submissions with loading states
    document.querySelector('.search-form').addEventListener('submit', function(e) {
      const submitBtn = this.querySelector('.search-btn');
      submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i><span>Searching...</span>';
      submitBtn.disabled = true;
    });

    // Prevent double submissions
    let isSubmitting = false;
    document.querySelectorAll('form').forEach(form => {
      form.addEventListener('submit', function(e) {
        if (isSubmitting) {
          e.preventDefault();
          return false;
        }
        isSubmitting = true;
        
        setTimeout(() => {
          isSubmitting = false;
        }, 2000);
      });
    });
  </script>

</body>
</html>
<%@ page import="java.util.*" %>
<%
    String type = (String) session.getAttribute("userType");
    if (type == null || !"customer".equals(type)) {
        response.sendRedirect(request.getContextPath() + "/view/login.jsp");
        return;
    }

    com.bookshop.model.User user = (com.bookshop.model.User) session.getAttribute("user");
    
    // Get cart count for header
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    int cartCount = 0;
    if (cart != null) {
        for (int qty : cart.values()) cartCount += qty;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Help & Support - Pahana Edu</title>
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

  /* Header - Same as dashboard */
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

  .nav-link:hover, .nav-link.active {
    background: rgba(74, 144, 226, 0.1);
    border-color: var(--accent-blue);
    color: var(--accent-blue);
    transform: translateY(-1px);
  }

  /* Main Content */
  .main-content {
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem;
  }

  /* Hero Section */
  .hero-section {
    text-align: center;
    padding: 4rem 0;
    margin-bottom: 3rem;
  }

  .hero-title {
    font-family: 'Playfair Display', serif;
    font-size: 3rem;
    font-weight: 700;
    margin-bottom: 1rem;
    color: var(--silver-bright);
    background: linear-gradient(135deg, var(--silver-bright), var(--accent-blue));
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }

  .hero-subtitle {
    font-size: 1.2rem;
    color: var(--silver-muted);
    margin-bottom: 2rem;
  }

  .search-help {
    max-width: 600px;
    margin: 0 auto;
    position: relative;
  }

  .search-input {
    width: 100%;
    padding: 1rem 1.5rem;
    padding-right: 4rem;
    border: 1px solid var(--glass-border);
    border-radius: var(--border-radius-large);
    background: rgba(26, 26, 26, 0.8);
    backdrop-filter: blur(20px);
    color: var(--silver-light);
    font-size: 1rem;
    outline: none;
    transition: var(--transition-smooth);
  }

  .search-input:focus {
    border-color: var(--accent-blue);
    box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
  }

  .search-btn {
    position: absolute;
    right: 0.5rem;
    top: 50%;
    transform: translateY(-50%);
    background: var(--accent-blue);
    border: none;
    padding: 0.75rem 1rem;
    border-radius: var(--border-radius);
    color: white;
    cursor: pointer;
    transition: var(--transition-smooth);
  }

  .search-btn:hover {
    background: #3a7bc8;
  }

  /* Quick Links */
  .quick-links {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 1.5rem;
    margin-bottom: 4rem;
  }

  .quick-link-card {
    background: rgba(26, 26, 26, 0.8);
    backdrop-filter: blur(20px);
    border: 1px solid var(--glass-border);
    border-radius: var(--border-radius-large);
    padding: 2rem;
    text-align: center;
    transition: var(--transition-smooth);
    cursor: pointer;
    text-decoration: none;
    color: var(--silver-light);
  }

  .quick-link-card:hover {
    transform: translateY(-4px);
    box-shadow: var(--shadow-medium);
    border-color: var(--accent-blue);
    color: var(--silver-light);
  }

  .quick-link-icon {
    font-size: 2.5rem;
    margin-bottom: 1rem;
    color: var(--accent-blue);
  }

  .quick-link-title {
    font-family: 'Playfair Display', serif;
    font-size: 1.3rem;
    font-weight: 600;
    margin-bottom: 0.5rem;
    color: var(--silver-bright);
  }

  .quick-link-desc {
    color: var(--silver-muted);
    font-size: 0.9rem;
  }

  /* Help Categories */
  .help-categories {
    margin-bottom: 4rem;
  }

  .category-title {
    font-family: 'Playfair Display', serif;
    font-size: 2rem;
    font-weight: 600;
    color: var(--silver-bright);
    margin-bottom: 2rem;
    text-align: center;
  }

  .category-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
    gap: 2rem;
  }

  .category-card {
    background: rgba(26, 26, 26, 0.8);
    backdrop-filter: blur(20px);
    border: 1px solid var(--glass-border);
    border-radius: var(--border-radius-large);
    padding: 2rem;
    transition: var(--transition-smooth);
  }

  .category-card:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-soft);
  }

  .category-header {
    display: flex;
    align-items: center;
    gap: 1rem;
    margin-bottom: 1.5rem;
  }

  .category-icon {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--accent-blue), #3a7bc8);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.5rem;
    color: white;
  }

  .category-name {
    font-family: 'Playfair Display', serif;
    font-size: 1.5rem;
    font-weight: 600;
    color: var(--silver-bright);
  }

  .faq-list {
    list-style: none;
  }

  .faq-item {
    margin-bottom: 1rem;
    border: 1px solid var(--glass-border);
    border-radius: var(--border-radius);
    overflow: hidden;
    background: rgba(42, 42, 42, 0.3);
  }

  .faq-question {
    padding: 1rem;
    cursor: pointer;
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-weight: 500;
    color: var(--silver-bright);
    transition: var(--transition-smooth);
  }

  .faq-question:hover {
    background: rgba(74, 144, 226, 0.1);
  }

  .faq-answer {
    padding: 0 1rem;
    max-height: 0;
    overflow: hidden;
    transition: max-height 0.3s ease, padding 0.3s ease;
    color: var(--silver-muted);
    line-height: 1.6;
  }

  .faq-answer.active {
    padding: 1rem;
    max-height: 200px;
  }

  .faq-toggle {
    transition: transform 0.3s ease;
    color: var(--accent-blue);
  }

  .faq-toggle.active {
    transform: rotate(180deg);
  }

  /* Contact Section */
  .contact-section {
    background: rgba(26, 26, 26, 0.8);
    backdrop-filter: blur(20px);
    border: 1px solid var(--glass-border);
    border-radius: var(--border-radius-large);
    padding: 3rem;
    text-align: center;
    margin-bottom: 3rem;
  }

  .contact-title {
    font-family: 'Playfair Display', serif;
    font-size: 2rem;
    font-weight: 600;
    color: var(--silver-bright);
    margin-bottom: 1rem;
  }

  .contact-subtitle {
    color: var(--silver-muted);
    margin-bottom: 2rem;
    font-size: 1.1rem;
  }

  .contact-methods {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 2rem;
    margin-bottom: 2rem;
  }

  .contact-method {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 1rem;
    padding: 1.5rem;
    background: rgba(42, 42, 42, 0.5);
    border: 1px solid var(--glass-border);
    border-radius: var(--border-radius);
    text-decoration: none;
    color: var(--silver-light);
    transition: var(--transition-smooth);
  }

  .contact-method:hover {
    background: rgba(74, 144, 226, 0.1);
    border-color: var(--accent-blue);
    transform: translateY(-2px);
  }

  .contact-icon {
    font-size: 1.5rem;
    color: var(--accent-blue);
  }

  .contact-info h4 {
    font-weight: 600;
    margin-bottom: 0.25rem;
    color: var(--silver-bright);
  }

  .contact-info p {
    color: var(--silver-muted);
    font-size: 0.9rem;
  }

  /* Footer - Same as dashboard */
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

    .hero-title {
      font-size: 2rem;
    }

    .quick-links {
      grid-template-columns: 1fr;
    }

    .category-grid {
      grid-template-columns: 1fr;
    }

    .contact-methods {
      grid-template-columns: 1fr;
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
  <!-- Header - Same structure as dashboard -->
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
      <a href="#" class="nav-link active">
        <i class="fas fa-question-circle"></i>
        <span>Help</span>
      </a>
    </div>
  </nav>

  <!-- Main Content -->
  <div class="main-content">
    <!-- Hero Section -->
    <section class="hero-section">
      <h1 class="hero-title">Help & Support</h1>
      <p class="hero-subtitle">Find answers to your questions and get the help you need</p>
      
      <div class="search-help">
        <input type="text" class="search-input" placeholder="Search for help topics..." id="helpSearch">
        <button class="search-btn" onclick="searchHelp()">
          <i class="fas fa-search"></i>
        </button>
      </div>
    </section>

    <!-- Quick Links -->
    <section class="quick-links">
      <a href="#getting-started" class="quick-link-card">
        <div class="quick-link-icon">
          <i class="fas fa-rocket"></i>
        </div>
        <h3 class="quick-link-title">Getting Started</h3>
        <p class="quick-link-desc">Learn how to browse, search, and purchase books on our platform</p>
      </a>

      <a href="#account-orders" class="quick-link-card">
        <div class="quick-link-icon">
          <i class="fas fa-user-cog"></i>
        </div>
        <h3 class="quick-link-title">Account & Orders</h3>
        <p class="quick-link-desc">Manage your account settings and track your order history</p>
      </a>

      <a href="#payment-shipping" class="quick-link-card">
        <div class="quick-link-icon">
          <i class="fas fa-credit-card"></i>
        </div>
        <h3 class="quick-link-title">Payment & Shipping</h3>
        <p class="quick-link-desc">Information about payment methods and delivery options</p>
      </a>

      <a href="#technical-support" class="quick-link-card">
        <div class="quick-link-icon">
          <i class="fas fa-tools"></i>
        </div>
        <h3 class="quick-link-title">Technical Support</h3>
        <p class="quick-link-desc">Troubleshoot website issues and technical problems</p>
      </a>
    </section>

    <!-- Help Categories -->
    <section class="help-categories">
      <h2 class="category-title">Frequently Asked Questions</h2>
      
      <div class="category-grid">
        <!-- Getting Started -->
        <div class="category-card" id="getting-started">
          <div class="category-header">
            <div class="category-icon">
              <i class="fas fa-rocket"></i>
            </div>
            <h3 class="category-name">Getting Started</h3>
          </div>
          
          <ul class="faq-list">
            <li class="faq-item">
              <div class="faq-question" onclick="toggleFAQ(this)">
                <span>I can't log into my account</span>
                <i class="fas fa-chevron-down faq-toggle"></i>
              </div>
              <div class="faq-answer">
                <p>First, make sure you're using the correct email and password. If you've forgotten your password, use the "Forgot Password" link on the login page. Clear your browser cache and cookies if the problem persists.</p>
              </div>
            </li>
            
            <li class="faq-item">
              <div class="faq-question" onclick="toggleFAQ(this)">
                <span>The website is loading slowly</span>
                <i class="fas fa-chevron-down faq-toggle"></i>
              </div>
              <div class="faq-answer">
                <p>Slow loading can be due to internet connection or browser issues. Try refreshing the page, clearing your browser cache, or switching to a different browser. Check your internet connection speed.</p>
              </div>
            </li>
            
            <li class="faq-item">
              <div class="faq-question" onclick="toggleFAQ(this)">
                <span>I'm having trouble adding items to cart</span>
                <i class="fas fa-chevron-down faq-toggle"></i>
              </div>
              <div class="faq-answer">
                <p>Make sure you're logged into your account and the item is in stock. Try refreshing the page and attempting again. If the problem continues, contact our support team through the chat feature.</p>
              </div>
            </li>
          </ul>
        </div>
      </div>
    </section>

    <!-- Contact Section -->
    <section class="contact-section">
      <h2 class="contact-title">Still Need Help?</h2>
      <p class="contact-subtitle">Our support team is here to assist you with any questions or concerns</p>
      
      <div class="contact-methods">
        <a href="<%= request.getContextPath() %>/private-chat?customerId=<%= user.getId() %>" class="contact-method">
          <div class="contact-icon">
            <i class="fas fa-comments"></i>
          </div>
          <div class="contact-info">
            <h4>Live Chat</h4>
            <p>Chat with our support staff</p>
          </div>
        </a>
        
        <a href="mailto:support@pahanaedu.lk" class="contact-method">
          <div class="contact-icon">
            <i class="fas fa-envelope"></i>
          </div>
          <div class="contact-info">
            <h4>Email Support</h4>
            <p>Theekshana@pahanaedu.lk</p>
          </div>
        </a>
        
        <a href="tel:+94112345678" class="contact-method">
          <div class="contact-icon">
            <i class="fas fa-phone"></i>
          </div>
          <div class="contact-info">
            <h4>Phone Support</h4>
            <p>+94 701112999</p>
          </div>
        </a>
        
        <div class="contact-method">
          <div class="contact-icon">
            <i class="fas fa-clock"></i>
          </div>
          <div class="contact-info">
            <h4>Support Hours</h4>
            <p>Mon-Fri: 8AM-5PM</p>
          </div>
        </div>
      </div>
      
      <div style="margin-top: 2rem;">
        <a href="<%= request.getContextPath() %>/customer/dashboard" class="quick-link-card" style="display: inline-block; max-width: 300px;">
          <div class="quick-link-icon">
            <i class="fas fa-arrow-left"></i>
          </div>
          <h3 class="quick-link-title">Back to Dashboard</h3>
          <p class="quick-link-desc">Return to browsing our book collection</p>
        </a>
      </div>
    </section>
  </div>

  <!-- Footer -->
  <footer class="footer">
    <div>
      <p>&copy; 2025 Pahana Edu Bookshop | Quality Literature for Every Reader</p>
      <p>Connecting readers with knowledge since day one</p>
    </div>
  </footer>

  <script>
    // FAQ Toggle Functionality
    function toggleFAQ(element) {
      const answer = element.nextElementSibling;
      const toggle = element.querySelector('.faq-toggle');
      const allAnswers = document.querySelectorAll('.faq-answer');
      const allToggles = document.querySelectorAll('.faq-toggle');
      
      // Close all other FAQs
      allAnswers.forEach(ans => {
        if (ans !== answer) {
          ans.classList.remove('active');
        }
      });
      
      allToggles.forEach(tog => {
        if (tog !== toggle) {
          tog.classList.remove('active');
        }
      });
      
      // Toggle current FAQ
      answer.classList.toggle('active');
      toggle.classList.toggle('active');
    }

    // Search Help Functionality
    function searchHelp() {
      const searchTerm = document.getElementById('helpSearch').value.toLowerCase().trim();
      if (!searchTerm) return;
      
      const faqItems = document.querySelectorAll('.faq-item');
      const categoryCards = document.querySelectorAll('.category-card');
      let found = false;
      
      // Reset all visibility
      faqItems.forEach(item => item.style.display = 'block');
      categoryCards.forEach(card => card.style.display = 'block');
      
      if (searchTerm) {
        faqItems.forEach(item => {
          const question = item.querySelector('.faq-question span').textContent.toLowerCase();
          const answer = item.querySelector('.faq-answer p').textContent.toLowerCase();
          
          if (!question.includes(searchTerm) && !answer.includes(searchTerm)) {
            item.style.display = 'none';
          } else {
            found = true;
            // Auto-expand matching FAQs
            const answerEl = item.querySelector('.faq-answer');
            const toggleEl = item.querySelector('.faq-toggle');
            answerEl.classList.add('active');
            toggleEl.classList.add('active');
          }
        });
        
        // Hide empty categories
        categoryCards.forEach(card => {
          const visibleFAQs = card.querySelectorAll('.faq-item[style*="block"], .faq-item:not([style])');
          const actuallyVisible = Array.from(visibleFAQs).filter(item => 
            item.style.display !== 'none'
          );
          if (actuallyVisible.length === 0) {
            card.style.display = 'none';
          }
        });
        
        if (!found) {
          showNoResults(searchTerm);
        }
      }
    }
    
    function showNoResults(searchTerm) {
      const categoryGrid = document.querySelector('.category-grid');
      const noResultsHTML = `
        <div class="category-card" id="no-results" style="grid-column: 1 / -1; text-align: center; padding: 3rem;">
          <div class="category-icon" style="margin: 0 auto 1rem; background: var(--danger);">
            <i class="fas fa-search"></i>
          </div>
          <h3 class="category-name" style="margin-bottom: 1rem;">No Results Found</h3>
          <p style="color: var(--silver-muted); margin-bottom: 2rem;">
            We couldn't find any help topics matching "<strong>${searchTerm}</strong>"
          </p>
          <button onclick="clearSearch()" style="background: var(--accent-blue); color: white; border: none; padding: 0.75rem 1.5rem; border-radius: var(--border-radius); cursor: pointer;">
            Clear Search
          </button>
        </div>
      `;
      
      // Remove existing no-results if any
      const existing = document.getElementById('no-results');
      if (existing) existing.remove();
      
      categoryGrid.insertAdjacentHTML('afterbegin', noResultsHTML);
    }
    
    function clearSearch() {
      document.getElementById('helpSearch').value = '';
      const faqItems = document.querySelectorAll('.faq-item');
      const categoryCards = document.querySelectorAll('.category-card');
      const noResults = document.getElementById('no-results');
      
      if (noResults) noResults.remove();
      
      faqItems.forEach(item => item.style.display = 'block');
      categoryCards.forEach(card => card.style.display = 'block');
      
      // Close all FAQs
      document.querySelectorAll('.faq-answer').forEach(ans => ans.classList.remove('active'));
      document.querySelectorAll('.faq-toggle').forEach(toggle => toggle.classList.remove('active'));
    }

    // Search on Enter key
    document.getElementById('helpSearch').addEventListener('keypress', function(e) {
      if (e.key === 'Enter') {
        searchHelp();
      }
    });

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
      anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const targetId = this.getAttribute('href');
        const targetElement = document.querySelector(targetId);
        if (targetElement) {
          targetElement.scrollIntoView({
            behavior: 'smooth',
            block: 'start'
          });
        }
      });
    });

    // Initialize page animations
    document.addEventListener('DOMContentLoaded', function() {
      // Add fade-in animation to cards
      const cards = document.querySelectorAll('.category-card, .quick-link-card');
      cards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        card.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
        
        setTimeout(() => {
          card.style.opacity = '1';
          card.style.transform = 'translateY(0)';
        }, index * 100);
      });

      // Auto-focus search input
      document.getElementById('helpSearch').focus();
    });
    
    // URL hash handling for direct links to sections
    if (window.location.hash) {
      const targetElement = document.querySelector(window.location.hash);
      if (targetElement) {
        setTimeout(() => {
          targetElement.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }, 500);
      }
    }
  </script>

</body>
</html>How do I create an account?</span>
                <i class="fas fa-chevron-down faq-toggle"></i>
              </div>
              <div class="faq-answer">
                <p>To create an account, click the "Register" button on the login page. Fill in your personal information including full name, email, and password. Your account will be created immediately and you can start browsing our book collection.</p>
              </div>
            </li>
            
            <li class="faq-item">
              <div class="faq-question" onclick="toggleFAQ(this)">
                <span>How do I search for books?</span>
                <i class="fas fa-chevron-down faq-toggle"></i>
              </div>
              <div class="faq-answer">
                <p>Use the search form on the dashboard to find books by title, author, category, or price range. You can also browse all available books or filter by specific categories using the navigation menu.</p>
              </div>
            </li>
            
            <li class="faq-item">
              <div class="faq-question" onclick="toggleFAQ(this)">
                <span>How do I add books to my cart?</span>
                <i class="fas fa-chevron-down faq-toggle"></i>
              </div>
              <div class="faq-answer">
                <p>Simply click the "Add to Cart" button on any book card. The item will be added to your shopping cart, and you'll see the cart count update in the header navigation.</p>
              </div>
            </li>
          </ul>
        </div>

        <!-- Account & Orders -->
        <div class="category-card" id="account-orders">
          <div class="category-header">
            <div class="category-icon">
              <i class="fas fa-user-cog"></i>
            </div>
            <h3 class="category-name">Account & Orders</h3>
          </div>
          
          <ul class="faq-list">
            <li class="faq-item">
              <div class="faq-question" onclick="toggleFAQ(this)">
                <span>How do I view my order history?</span>
                <i class="fas fa-chevron-down faq-toggle"></i>
              </div>
              <div class="faq-answer">
                <p>Click on the "Orders" button in the header navigation to view all your past and current orders. You can see order status, items purchased, and delivery information.</p>
              </div>
            </li>
            
            <li class="faq-item">
              <div class="faq-question" onclick="toggleFAQ(this)">
                <span>How do I update my profile information?</span>
                <i class="fas fa-chevron-down faq-toggle"></i>
              </div>
              <div class="faq-answer">
                <p>Click the "Profile" button in the header to access your account settings. You can update your personal information, change your password, and manage your preferences.</p>
              </div>
            </li>
            
            <li class="faq-item">
              <div class="faq-question" onclick="toggleFAQ(this)">
                <span>Can I cancel my order?</span>
                <i class="fas fa-chevron-down faq-toggle"></i>
              </div>
              <div class="faq-answer">
                <p>Orders can be cancelled within 24 hours of placement if they haven't been shipped yet. Contact our support team or use the chat feature to request order cancellation.</p>
              </div>
            </li>
          </ul>
        </div>

        <!-- Payment & Shipping -->
        <div class="category-card" id="payment-shipping">
          <div class="category-header">
            <div class="category-icon">
              <i class="fas fa-credit-card"></i>
            </div>
            <h3 class="category-name">Payment & Shipping</h3>
          </div>
          
          <ul class="faq-list">
            <li class="faq-item">
              <div class="faq-question" onclick="toggleFAQ(this)">
                <span>What payment methods do you accept?</span>
                <i class="fas fa-chevron-down faq-toggle"></i>
              </div>
              <div class="faq-answer">
                <p>We accept all major credit cards (Visa, Mastercard, American Express), bank transfers, and mobile payment solutions. All transactions are secure and encrypted.</p>
              </div>
            </li>
            
            <li class="faq-item">
              <div class="faq-question" onclick="toggleFAQ(this)">
                <span>How long does delivery take?</span>
                <i class="fas fa-chevron-down faq-toggle"></i>
              </div>
              <div class="faq-answer">
                <p>Standard delivery takes 3-5 business days.</p>
              </div>
            </li>
            
            <li class="faq-item">
              <div class="faq-question" onclick="toggleFAQ(this)">
                <span>Are there any shipping charges?</span>
                <i class="fas fa-chevron-down faq-toggle"></i>
              </div>
              <div class="faq-answer">
                <p>Free delivery is available for orders above LKR 2,000. For smaller orders, standard shipping charges of LKR 200-300 apply depending on your location.</p>
              </div>
            </li>
          </ul>
        </div>

        <!-- Technical Support -->
        <div class="category-card" id="technical-support">
          <div class="category-header">
            <div class="category-icon">
              <i class="fas fa-tools"></i>
            </div>
            <h3 class="category-name">Technical Support</h3>
          </div>
          
          <ul class="faq-list">
            <li class="faq-item">
              <div class="faq-question" onclick="toggleFAQ(this)">
                <span>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pahana Edu - Smart Bookshop Management</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 50%, #1a1a1a 100%);
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* Animated background particles */
        .particles {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
        }

        .particle {
            position: absolute;
            background: linear-gradient(45deg, rgba(255, 215, 0, 0.3), rgba(192, 192, 192, 0.2));
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        /* Header */
        .header {
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 215, 0, 0.3);
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 2rem;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: white;
            font-size: 1.5rem;
            font-weight: bold;
        }

        .logo i {
            background: linear-gradient(45deg, #ffd700, #c0c0c0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 2rem;
        }

        .nav-menu {
            display: flex;
            gap: 2rem;
        }

        .nav-link {
            color: white;
            text-decoration: none;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .nav-link:hover {
            background: rgba(255, 215, 0, 0.2);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.3);
        }

        .login-btn {
            background: linear-gradient(45deg, #ffd700, #c0c0c0) !important;
            color: #1a1a1a !important;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.4);
        }

        .login-btn:hover {
            background: linear-gradient(45deg, #ffed4e, #e6e6e6) !important;
            color: #000 !important;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(255, 215, 0, 0.6);
        }

        /* Main Content */
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 4rem 2rem;
            text-align: center;
        }

        .hero-section {
            margin-bottom: 4rem;
        }

        .hero-title {
            font-size: 4rem;
            font-weight: 800;
            color: white;
            margin-bottom: 1rem;
            background: linear-gradient(45deg, #ffd700, #c0c0c0, #ffd700);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: gradient 3s ease-in-out infinite;
            background-size: 200% 200%;
            text-shadow: 0 0 30px rgba(255, 215, 0, 0.5);
        }

        @keyframes gradient {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }

        .hero-subtitle {
            font-size: 1.3rem;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .cta-button {
            display: inline-block;
            background: linear-gradient(45deg, #ffd700, #c0c0c0);
            color: #1a1a1a;
            padding: 1rem 2.5rem;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 10px 30px rgba(255, 215, 0, 0.3);
            position: relative;
            overflow: hidden;
        }

        .cta-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(255, 215, 0, 0.5);
            background: linear-gradient(45deg, #ffed4e, #e6e6e6);
        }

        .cta-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
            transition: left 0.5s;
        }

        .cta-button:hover::before {
            left: 100%;
        }

        /* Features Grid */
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 4rem;
        }

        .feature-card {
            background: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 215, 0, 0.3);
            border-radius: 20px;
            padding: 2rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            background: rgba(0, 0, 0, 0.8);
            box-shadow: 0 20px 40px rgba(255, 215, 0, 0.2);
            border-color: rgba(255, 215, 0, 0.5);
        }

        .feature-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            background: linear-gradient(45deg, #ffd700, #c0c0c0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            filter: drop-shadow(0 0 10px rgba(255, 215, 0, 0.3));
        }

        .feature-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: white;
            margin-bottom: 1rem;
        }

        .feature-description {
            color: rgba(255, 255, 255, 0.8);
            line-height: 1.6;
        }

        /* Stats Section */
        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
            margin: 4rem 0;
        }

        .stat-item {
            text-align: center;
            padding: 1.5rem;
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 800;
            background: linear-gradient(45deg, #ffd700, #c0c0c0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: block;
            filter: drop-shadow(0 0 15px rgba(255, 215, 0, 0.4));
        }

        .stat-label {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.1rem;
            margin-top: 0.5rem;
        }

        /* Footer */
        .footer {
            background: rgba(0, 0, 0, 0.8);
            backdrop-filter: blur(10px);
            border-top: 1px solid rgba(255, 215, 0, 0.3);
            padding: 2rem 0;
            text-align: center;
            color: rgba(255, 255, 255, 0.9);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero-title { font-size: 2.5rem; }
            .nav-menu { display: none; }
            .main-container { padding: 2rem 1rem; }
            .features-grid { grid-template-columns: 1fr; }
            
            /* Mobile login button */
            .mobile-login {
                display: block;
                position: fixed;
                bottom: 20px;
                right: 20px;
                background: linear-gradient(45deg, #ffd700, #c0c0c0);
                color: #1a1a1a;
                padding: 15px;
                border-radius: 50px;
                text-decoration: none;
                font-weight: 600;
                box-shadow: 0 8px 25px rgba(255, 215, 0, 0.4);
                z-index: 1000;
                transition: all 0.3s ease;
            }
            
            .mobile-login:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 35px rgba(255, 215, 0, 0.6);
                background: linear-gradient(45deg, #ffed4e, #e6e6e6);
            }
        }
        
        .mobile-login {
            display: none;
        }

        /* Loading Animation */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 50%, #1a1a1a 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 10000;
            opacity: 1;
            transition: opacity 0.5s ease;
        }

        .loading-spinner {
            width: 60px;
            height: 60px;
            border: 4px solid rgba(255, 215, 0, 0.3);
            border-top: 4px solid #ffd700;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner"></div>
    </div>

    <!-- Animated Background -->
    <div class="particles" id="particles"></div>

    <!-- Header -->
    <header class="header">
        <div class="nav-container">
            <div class="logo">
                <i class="fas fa-book-open"></i>
                <span>Pahana Edu</span>
            </div>
            <nav class="nav-menu">
                <a href="#" class="nav-link">Dashboard</a>
                <a href="#" class="nav-link">Inventory</a>
                <a href="#" class="nav-link">Sales</a>
                <a href="#" class="nav-link">Reports</a>
                <a href="#" class="nav-link">Settings</a>
                <a href="view/login.jsp" class="nav-link login-btn">
                    <i class="fas fa-sign-in-alt"></i> Login
                </a>
            </nav>
        </div>
    </header>

    <!-- Main Content -->
    <main class="main-container">
        <section class="hero-section">
            <h1 class="hero-title">Pahana Edu Bookshop </h1>
            <p class="hero-subtitle">
                Transform your bookshop with intelligent management solutions.<br>
                Streamline inventory, boost sales, and enhance customer experience.
            </p>
            <a href="#" class="cta-button">
                <i class="fas fa-rocket"></i> Get Started Today
            </a>
        </section>

        <!-- Stats Section -->
        <section class="stats-section">
            <div class="stat-item">
                <span class="stat-number" data-target="10000">0</span>
                <div class="stat-label">Books Managed</div>
            </div>
            <div class="stat-item">
                <span class="stat-number" data-target="500">0</span>
                <div class="stat-label">Happy Customers</div>
            </div>
            <div class="stat-item">
                <span class="stat-number" data-target="99">0</span>
                <div class="stat-label">Uptime %</div>
            </div>
            <div class="stat-item">
                <span class="stat-number" data-target="24">0</span>
                <div class="stat-label">Support Hours</div>
            </div>
        </section>

        <!-- Features Grid -->
        <section class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-warehouse"></i>
                </div>
                <h3 class="feature-title">Smart Inventory</h3>
                <p class="feature-description">
                    Real-time inventory tracking with automated reorder alerts and intelligent stock predictions.
                </p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <h3 class="feature-title">Analytics Dashboard</h3>
                <p class="feature-description">
                    Comprehensive sales analytics and performance insights to drive your business forward.
                </p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-users"></i>
                </div>
                <h3 class="feature-title">Customer Management</h3>
                <p class="feature-description">
                    Build lasting relationships with integrated CRM and personalized customer experiences.
                </p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-mobile-alt"></i>
                </div>
                <h3 class="feature-title">Mobile Ready</h3>
                <p class="feature-description">
                    Access your bookshop management system anywhere with our responsive mobile interface.
                </p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <h3 class="feature-title">Secure & Reliable</h3>
                <p class="feature-description">
                    Bank-level security with automated backups and 99.9% uptime guarantee.
                </p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-headset"></i>
                </div>
                <h3 class="feature-title">24/7 Support</h3>
                <p class="feature-description">
                    Round-the-clock technical support and training to ensure your success.
                </p>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2025 Pahana Edu. Empowering bookshops worldwide with smart technology.</p>
    </footer>

    <!-- Mobile Login Button -->
    <a href="login.jsp" class="mobile-login">
        <i class="fas fa-sign-in-alt"></i> Login
    </a>

    <script>
        // Loading animation
        window.addEventListener('load', function() {
            setTimeout(() => {
                document.getElementById('loadingOverlay').style.opacity = '0';
                setTimeout(() => {
                    document.getElementById('loadingOverlay').style.display = 'none';
                }, 500);
            }, 1000);
        });

        // Create floating particles
        function createParticles() {
            const particlesContainer = document.getElementById('particles');
            const particleCount = 50;

            for (let i = 0; i < particleCount; i++) {
                const particle = document.createElement('div');
                particle.className = 'particle';
                
                const size = Math.random() * 4 + 2;
                const x = Math.random() * window.innerWidth;
                const y = Math.random() * window.innerHeight;
                const delay = Math.random() * 6;
                
                particle.style.width = size + 'px';
                particle.style.height = size + 'px';
                particle.style.left = x + 'px';
                particle.style.top = y + 'px';
                particle.style.animationDelay = delay + 's';
                
                particlesContainer.appendChild(particle);
            }
        }

        // Animate statistics counter
        function animateStats() {
            const stats = document.querySelectorAll('.stat-number');
            
            stats.forEach(stat => {
                const target = parseInt(stat.getAttribute('data-target'));
                let current = 0;
                const increment = target / 100;
                
                const updateCounter = () => {
                    if (current < target) {
                        current += increment;
                        stat.textContent = Math.ceil(current);
                        requestAnimationFrame(updateCounter);
                    } else {
                        stat.textContent = target;
                    }
                };
                
                updateCounter();
            });
        }

        // Intersection Observer for animations
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        });

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            createParticles();
            
            // Start stats animation when visible
            const statsSection = document.querySelector('.stats-section');
            const statsObserver = new IntersectionObserver((entries) => {
                if (entries[0].isIntersecting) {
                    animateStats();
                    statsObserver.unobserve(statsSection);
                }
            });
            statsObserver.observe(statsSection);

            // Add smooth scrolling
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });
        });

        // Handle window resize for particles
        window.addEventListener('resize', function() {
            const particles = document.getElementById('particles');
            particles.innerHTML = '';
            createParticles();
        });
    </script>
</body>
</html>
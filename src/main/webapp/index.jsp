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
      background: #000;
      background-image: url("uploads/index.jpg");
      background-size: cover;
      background-position: center;
      background-attachment: fixed;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      text-align: center;
      position: relative;
    }

    body::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.7);
      z-index: -1;
    }

    header {
      width: 100%;
      display: flex;
      justify-content: flex-end;
      padding: 20px 40px;
      position: absolute;
      top: 0;
      left: 0;
    }

    h1 {
      font-size: 4rem;
      font-weight: 800;
      color: white;
      margin-bottom: 0.4rem;
      background: linear-gradient(45deg, #ffd700, #c0c0c0);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    p {
      font-size: 1.2rem;
      color: rgba(255, 255, 255, 0.85);
      margin-bottom: 2rem;
    }

    .login-btn {
      background: linear-gradient(45deg, #ffd700, #c0c0c0);
      color: #1a1a1a;
      font-weight: 700;
      padding: 0.7rem 1.8rem;
      border-radius: 30px;
      text-decoration: none;
      font-size: 1rem;
      transition: all 0.3s ease;
      box-shadow: 0 8px 20px rgba(255, 215, 0, 0.4);
    }

    .login-btn:hover {
      background: linear-gradient(45deg, #ffed4e, #e6e6e6);
      transform: translateY(-3px);
      box-shadow: 0 12px 30px rgba(255, 215, 0, 0.6);
      color: #000;
    }
  </style>
</head>
<body>
  <!-- Top header with login -->
  <header>
    <a href="view/login.jsp" class="login-btn">
      <i class="fas fa-sign-in-alt"></i> Login
    </a>
  </header>

  <!-- Main content -->
  <h1>Pahana Edu Bookshop</h1>
  <p>Where the journey of knowledge begins</p>
</body>
</html>

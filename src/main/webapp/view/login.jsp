<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Login | PahanaBookshop</title>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap');
    * { box-sizing: border-box; }
    body {
      margin: 0;
      height: 100vh;
      font-family: 'Montserrat', sans-serif;
      background: #121212;
      color: #eee;
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 1rem;
      background-image:
        radial-gradient(circle at top left, #3a0ca3 15%, transparent 40%),
        radial-gradient(circle at bottom right, #4361ee 15%, transparent 50%);
      background-repeat: no-repeat;
      background-size: cover;
    }
    .login-container {
      background: rgba(30, 30, 30, 0.9);
      border-radius: 15px;
      box-shadow: 0 8px 32px rgba(70, 70, 70, 0.7), inset 0 0 40px 2px rgba(255, 255, 255, 0.05);
      padding: 3rem 2.5rem;
      max-width: 400px;
      width: 100%;
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.1);
      text-align: center;
    }
    .login-container h2 {
      font-weight: 700;
      font-size: 2.3rem;
      margin-bottom: 2rem;
      letter-spacing: 2px;
      color: #8ab4f8;
      user-select: none;
    }
    form {
      display: flex;
      flex-direction: column;
      gap: 1.5rem;
    }
    input {
      background: #1f1f1f;
      border: 2px solid #3a0ca3;
      border-radius: 10px;
      padding: 1.1rem 1.5rem;
      font-size: 1.1rem;
      color: #eee;
      transition: border-color 0.3s ease, box-shadow 0.3s ease;
      outline: none;
      font-weight: 500;
      letter-spacing: 0.03em;
    }
    input::placeholder { color: #6c6c6c; font-weight: 400; }
    input:focus {
      border-color: #8ab4f8;
      box-shadow: 0 0 8px #8ab4f8;
      background: #2a2a2a;
    }
    button {
      padding: 1.2rem;
      background: linear-gradient(45deg, #3a0ca3, #4361ee);
      border: none;
      border-radius: 12px;
      color: white;
      font-size: 1.15rem;
      font-weight: 700;
      cursor: pointer;
      letter-spacing: 1.2px;
      box-shadow: 0 6px 20px rgba(67, 97, 238, 0.7);
      transition: background 0.4s ease, box-shadow 0.3s ease;
      user-select: none;
    }
    button:hover {
      background: linear-gradient(45deg, #5c29d1, #72aaff);
      box-shadow: 0 10px 30px rgba(114, 170, 255, 0.9);
      transform: translateY(-3px);
    }
    button:active {
      transform: translateY(1px);
      box-shadow: none;
    }
    .forgot {
      font-size: 0.9rem;
      color: #6c6c6c;
      margin-top: -1rem;
      margin-bottom: 1.5rem;
      user-select: none;
      display: flex;
      justify-content: space-between;
      gap: 1rem;
    }
    .forgot a {
      color: red;
      text-decoration: none;
      font-weight: 600;
      transition: color 0.3s ease;
    }
    .forgot a:hover {
      color: #4361ee;
      text-decoration: underline; 
    }
    .error-message {
      color: #e74c3c;
      font-weight: 600;
      min-height: 1.2em; 
      margin-top: 0.6rem;
      user-select: none;
    }  
    
    @media (max-width: 420px) {
      .login-container {
        padding: 2.5rem 2rem;
        max-width: 100%;
      }
      button { font-size: 1.05rem; }
      input { font-size: 1rem; }
      .forgot {
        flex-direction: column;
        align-items: center;
      }
    }
  </style>
</head>
<body>
  <main class="login-container" role="main" aria-label="User login form">
    <h2>Welcome Again..</h2>
    <form method="post" action="<%= request.getContextPath() %>/login" autocomplete="off" novalidate>
      <input
        type="email"
        name="email"
        placeholder="Email"
        required
        autocomplete="username"
      />
      <input
        type="password"
        name="password"
        placeholder="Password"
        required
        autocomplete="current-password"
      />
      <div class="forgot">
       <a href="<%= request.getContextPath() %>/view/forgot_password.jsp">Forgot password?</a>
        <a href="<%= request.getContextPath() %>/customer-register">Register Here</a>
      </div>
      <button type="submit">Log In</button>
    </form>
    <p class="error-message" role="alert" aria-live="assertive">
      <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %>
    </p>
  </main>
</body>
</html>

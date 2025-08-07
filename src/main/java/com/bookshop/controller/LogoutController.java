package com.bookshop.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);  // Get existing session, don't create new
        
        if (session != null) {
            session.invalidate();  // Invalidate session to log out user
        }
        
       
        response.sendRedirect(request.getContextPath() + "/view/login.jsp");
    }
}

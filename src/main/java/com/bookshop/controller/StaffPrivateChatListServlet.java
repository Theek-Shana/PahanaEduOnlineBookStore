package com.bookshop.controller;

import com.bookshop.model.User;
import com.bookshop.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/staff/private-chat-list")
public class StaffPrivateChatListServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check if logged in user is staff
        HttpSession session = req.getSession(false);
        System.out.println("Session: " + session); // Debug

        if (session == null || !"staff".equals(session.getAttribute("userType"))) {
            System.out.println("Not authorized. Redirecting...");
            resp.sendRedirect(req.getContextPath() + "/view/login.jsp");
            return;
        }

        try {
            List<User> customers = userService.getAllCustomers();
            req.setAttribute("customers", customers);
            req.getRequestDispatcher("/view/private-chat-list.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(500, "Unable to load customers.");
        }
    }
}

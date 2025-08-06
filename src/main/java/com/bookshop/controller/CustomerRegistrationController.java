package com.bookshop.controller;

import com.bookshop.model.User;
import com.bookshop.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.UUID;

@WebServlet("/customer/register")
public class CustomerRegistrationController extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/customer_register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String password = request.getParameter("password");

        if (fullname == null || fullname.isEmpty() ||
            email == null || email.isEmpty() ||
            mobile == null || mobile.isEmpty() ||
            password == null || password.isEmpty()) {

            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/view/customer_register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setFullname(fullname);
        user.setEmail(email);
        user.setMobile(mobile);
        user.setPassword(password);

        // THIS is where you generate the account number and set it!
        String accountNumber = "ACC" + System.currentTimeMillis();
        user.setAccountNumber(accountNumber);

        user.setRole("customer");

        boolean success = false;
        try {
            success = userService.registerUser(user);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (success) {
            request.setAttribute("success", "Registration successful! Please log in.");
        } else {
            request.setAttribute("error", "Registration failed. Email might already be used.");
        }

        request.getRequestDispatcher("/view/customer_register.jsp").forward(request, response);
    }

}

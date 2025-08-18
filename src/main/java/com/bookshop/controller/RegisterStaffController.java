package com.bookshop.controller;

import com.bookshop.model.User;
import com.bookshop.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

@WebServlet("/staff-register")  // add URL mapping annotation
public class RegisterStaffController extends HttpServlet {

	private final UserService userService = UserService.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/registerStaff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String fullname = request.getParameter("name");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String password = request.getParameter("password");

        // Basic validation
        if (fullname == null || fullname.isEmpty() ||
            email == null || email.isEmpty() ||
            mobile == null || mobile.isEmpty() ||
            password == null || password.isEmpty()) {
            
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/view/registerStaff.jsp").forward(request, response);
            return;
        }

        User staff = new User();
        staff.setFullname(fullname);
        staff.setEmail(email);
        staff.setMobile(mobile);
        staff.setPassword(password);
        staff.setAccountNumber("STAFF-" + UUID.randomUUID().toString().substring(0, 8));
        staff.setRole("staff");  // very important to set staff role!

        boolean success = false;
		try {
			success = userService.registerUser(staff);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        if (success) {
            // Redirect to admin dashboard or staff login page with success message
            response.sendRedirect(request.getContextPath() + "/view/adminDashboard.jsp?msg=staff_registered");
        } else {
            // Registration failed, likely duplicate email
            request.setAttribute("error", "Registration failed. Email might already be in use.");
            request.getRequestDispatcher("/view/registerStaff.jsp").forward(request, response);
        }
    }
}
package com.bookshop.controller;

import com.bookshop.model.User;
import com.bookshop.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/customers")
public class AdminCustomerController extends HttpServlet {

	  private final UserService userService = UserService.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

     //  Handle edit request BEFORE loading customer list
        if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                User user = userService.getUserById(id);

                if (user != null) {
                    request.setAttribute("user", user);
                    request.getRequestDispatcher("/view/edit-details.jsp").forward(request, response);
                } else {
                    // Handle case where user is not found
                    request.setAttribute("error", "User not found with ID: " + id);
                    response.sendRedirect(request.getContextPath() + "/admin/customers");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                request.setAttribute("error", "Invalid user ID.");
                response.sendRedirect(request.getContextPath() + "/admin/customers");
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Database error while fetching user.");
                response.sendRedirect(request.getContextPath() + "/admin/customers");
            }
            return;
        }


        //  Default: Load all customers
        String searchQuery = request.getParameter("q");
        List<User> customers;

        try {
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                customers = userService.searchUsersByRoleAndNameOrEmail("customer", searchQuery.trim());
            } else {
                customers = userService.getUsersByRole("customer");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred while fetching customers.");
            customers = List.of();
        }

        request.setAttribute("customers", customers);
        request.getRequestDispatcher("/view/admin_customer_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    int id = Integer.parseInt(idStr);
                    userService.deleteUserById(id);
                }
                response.sendRedirect(request.getContextPath() + "/admin/customers");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String fullname = request.getParameter("fullname");
                String email = request.getParameter("email");
                String mobile = request.getParameter("mobile");
                String password = request.getParameter("password");
                String accountNumber = request.getParameter("accountNumber");

                User user = new User();
                user.setId(id);
                user.setFullname(fullname);
                user.setEmail(email);
                user.setMobile(mobile);
                user.setPassword(password); 
                user.setAccountNumber(accountNumber);
                user.setRole("customer");

                userService.updateUserByAdmin(user);
                response.sendRedirect(request.getContextPath() + "/admin/customers");

            } else if ("create".equals(action)) {
                String fullname = request.getParameter("fullname");
                String email = request.getParameter("email");
                String mobile = request.getParameter("mobile");
                String password = request.getParameter("password");

                User newUser = new User();
                newUser.setFullname(fullname);
                newUser.setEmail(email);
                newUser.setMobile(mobile);
                newUser.setPassword(password);
                newUser.setRole("customer");

                boolean success = userService.registerUser(newUser);
                if (!success) {
                    request.setAttribute("error", "Email already exists or registration failed.");

                    try {
                        List<User> customers = userService.getUsersByRole("customer");
                        request.setAttribute("customers", customers);
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("error", "Database error while loading customers.");
                        request.setAttribute("customers", List.of());
                    }

                    request.getRequestDispatcher("/view/admin_customer_list.jsp").forward(request, response);
                    return;
                }

                response.sendRedirect(request.getContextPath() + "/admin/customers");

            } else {
                response.sendRedirect(request.getContextPath() + "/admin/customers");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view/error.jsp?error=DatabaseError");
        }
    }
}

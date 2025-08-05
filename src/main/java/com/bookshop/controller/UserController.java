package com.bookshop.controller;

import com.bookshop.model.User;
import com.bookshop.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/login")
public class UserController extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            HttpSession session = req.getSession(false);
            String role = (session != null) ? (String) session.getAttribute("userType") : null;

            // Protect admin-only actions
            if (action != null && (action.equals("listStaff") || action.equals("edit") || action.equals("delete"))) {
                if (role == null || !role.equals("admin")) {
                    resp.sendRedirect(req.getContextPath() + "/view/login.jsp");
                    return;
                }
            }

            if ("listStaff".equals(action)) {
                List<User> staffList = userService.getUsersByRole("staff");
                req.setAttribute("staffList", staffList);
                req.getRequestDispatcher("/view/staff-list.jsp").forward(req, resp);

            } else if ("edit".equals(action)) {
                String idStr = req.getParameter("id");
                if (idStr != null) {
                    int id = Integer.parseInt(idStr);
                    User user = userService.getUserById(id);
                    if (user != null) {
                        req.setAttribute("user", user);
                        req.getRequestDispatcher("/view/edit-details.jsp").forward(req, resp);
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/login?action=listStaff&error=UserNotFound");
                    }
                } else {
                    resp.sendRedirect(req.getContextPath() + "/login?action=listStaff");
                }

            } else {
                // default fallback
                resp.sendRedirect(req.getContextPath() + "/view/login.jsp");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/view/error.jsp?error=DatabaseError");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            if ("delete".equals(action)) {
                HttpSession session = req.getSession(false);
                String role = (session != null) ? (String) session.getAttribute("userType") : null;
                if (role == null || !role.equals("admin")) {
                    resp.sendRedirect(req.getContextPath() + "/view/login.jsp");
                    return;
                }

                String idStr = req.getParameter("id");
                if (idStr != null) {
                    int id = Integer.parseInt(idStr);
                    userService.deleteUserById(id);
                }
                resp.sendRedirect(req.getContextPath() + "/login?action=listStaff");

            } else if ("update".equals(action)) {
                HttpSession session = req.getSession(false);
                String role = (session != null) ? (String) session.getAttribute("userType") : null;
                if (role == null || !role.equals("admin")) {
                    resp.sendRedirect(req.getContextPath() + "/view/login.jsp");
                    return;
                }

                int id = Integer.parseInt(req.getParameter("id"));
                String fullname = req.getParameter("fullname");
                String email = req.getParameter("email");
                String mobile = req.getParameter("mobile");
                String password = req.getParameter("password");

              
                User user = new User();
                user.setId(id);
                user.setFullname(fullname);
                user.setEmail(email);
                user.setMobile(mobile);
                user.setPassword(password);

                userService.updateUserByAdmin(user);
                resp.sendRedirect(req.getContextPath() + "/login?action=listStaff");

            } else {
                // LOGIN logic
                String email = req.getParameter("email");
                String password = req.getParameter("password");

                User user = userService.login(email, password);

                if (user != null) {
                    HttpSession session = req.getSession(true);
                    session.setAttribute("user", user);
                    session.setAttribute("userType", user.getRole());

                    switch (user.getRole()) {
                        case "admin":
                            resp.sendRedirect(req.getContextPath() + "/view/adminDashboard.jsp");
                            break;
                        case "staff":
                            resp.sendRedirect(req.getContextPath() + "/view/staffDashboard.jsp");
                            break;
                        case "customer":
                            // New customer check:
                            java.sql.Timestamp createdAt = user.getCreatedAt();
                            boolean isNewCustomer = false;
                            if (createdAt != null) {
                                long millisSinceCreated = System.currentTimeMillis() - createdAt.getTime();
                                long daysSinceCreated = millisSinceCreated / (1000 * 60 * 60 * 24);
                                isNewCustomer = daysSinceCreated <= 2; // 7 days = new
                            }
                            session.setAttribute("isNewCustomer", isNewCustomer);

                            resp.sendRedirect(req.getContextPath() + "/view/customerDashboard.jsp");
                            break;
                        default:
                            session.invalidate();
                            resp.sendRedirect(req.getContextPath() + "/view/login.jsp?error=InvalidRole");
                    }
                } else {
                    resp.sendRedirect(req.getContextPath() + "/view/login.jsp?error=InvalidCredentials");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/view/error.jsp?error=ServerError");
        }
    }

}

package com.bookshop.controller;

import com.bookshop.model.ProfileManage;
import com.bookshop.model.User;
import com.bookshop.service.ProfileService;

import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/profile")
@MultipartConfig
public class ProfileController extends HttpServlet {

    private ProfileService profileService;

    @Override
    public void init() throws ServletException {
        try {
            profileService = new ProfileService();
        } catch (SQLException e) {
            e.printStackTrace(); // Log the issue
            profileService = null;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int customerId = user.getId();

        try {
            ProfileManage profile = profileService.getProfile(customerId);
            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/view/profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view/error.jsp?error=DatabaseError");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int customerId = user.getId();

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");  // Note: email is read-only in your form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String address = request.getParameter("address");
        String telephone = request.getParameter("telephone");

        Part filePart = request.getPart("profile_photo");
        String fileName = (filePart != null) ? filePart.getSubmittedFileName() : null;

        try {
            if (fileName == null || fileName.isEmpty()) {
                ProfileManage existingProfile = profileService.getProfile(customerId);
                fileName = existingProfile.getProfilePhoto();
            } else {
                String uploadPath = getServletContext().getRealPath("/uploads");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                filePart.write(uploadPath + File.separator + fileName);
            }

            ProfileManage profile = new ProfileManage();
            profile.setId(customerId);
            profile.setFullname(fullname);
            profile.setEmail(email); // email stays same, no update in DB assumed
            profile.setUsername(username);
            profile.setPassword(password);
            profile.setAddress(address);
            profile.setTelephone(telephone);
            profile.setProfilePhoto(fileName);

            boolean updated = profileService.updateProfile(profile);

            if (updated) {
                // Update the user object in session to reflect changes immediately
                user.setFullname(fullname);
                user.setUsername(username);
                user.setPassword(password);
                user.setAddress(address);
                user.setTelephone(telephone);
                user.setProfilePhoto(fileName);
                session.setAttribute("user", user);

                response.sendRedirect(request.getContextPath() + "/profile");
            } else {
                // Handle failed update
                response.sendRedirect(request.getContextPath() + "/view/error.jsp?error=ProfileUpdateFailed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view/error.jsp?error=ProfileUpdateFailed");
        }
    }
}

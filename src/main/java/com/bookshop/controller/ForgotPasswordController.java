package com.bookshop.controller;

import com.bookshop.model.User;
import com.bookshop.service.UserService;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Properties;

@WebServlet("/forgot-password")
public class ForgotPasswordController extends HttpServlet {
	private final UserService userService = UserService.getInstance();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("reset".equals(action)) {
            // Handle OTP verification and password reset
            String otpInput = req.getParameter("otp");
            String newPassword = req.getParameter("password");
            HttpSession session = req.getSession(false);

            if (session == null) {
                resp.sendRedirect(req.getContextPath() + "/view/forgot-password.jsp?error=SessionExpired");
                return;
            }

            String realOtp = (String) session.getAttribute("otp");
            String email = (String) session.getAttribute("email");

            if (realOtp != null && realOtp.equals(otpInput)) {
                try {
                    userService.updatePasswordByEmail(email, newPassword);
                    session.removeAttribute("otp");
                    session.removeAttribute("email");
                    resp.sendRedirect(req.getContextPath() + "/view/login.jsp?msg=PasswordReset");
                } catch (SQLException e) {
                    e.printStackTrace();
                    resp.sendRedirect(req.getContextPath() + "/view/error.jsp?error=ResetError");
                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/view/enter-otp.jsp?error=InvalidOTP");
            }
        } else {
            // Handle OTP sending
            String email = req.getParameter("email");
            try {
                User user = userService.getUserByEmail(email);
                if (user != null) {
                    String otp = String.valueOf((int)(Math.random() * 900000) + 100000);

                    HttpSession session = req.getSession();
                    session.setAttribute("otp", otp);
                    session.setAttribute("email", email);

                    final String fromEmail = "theek9365@gmail.com";
                    final String password = "ofpprmjnteckkkdf"; 

                    Properties props = new Properties();
                    props.put("mail.smtp.host", "smtp.gmail.com");
                    props.put("mail.smtp.port", "587");
                    props.put("mail.smtp.auth", "true");
                    props.put("mail.smtp.starttls.enable", "true");

                    Session mailSession = Session.getInstance(props, new Authenticator() {
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(fromEmail, password);
                        }
                    });

                    Message message = new MimeMessage(mailSession);
                    message.setFrom(new InternetAddress(fromEmail, "BookShop Support"));
                    message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
                    message.setSubject("Your OTP Code");
                    message.setText("Your OTP is: " + otp);

                    Transport.send(message);

                    resp.sendRedirect(req.getContextPath() + "/view/enter-otp.jsp");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/view/forgot-password.jsp?error=EmailNotFound");
                }
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/view/error.jsp?error=OTPFailed");
            }
        }
    }
}



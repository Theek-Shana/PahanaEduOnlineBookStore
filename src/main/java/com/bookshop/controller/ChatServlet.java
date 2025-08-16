package com.bookshop.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet({"/chat", "/private-chat"})
public class ChatServlet extends HttpServlet {

    private ChatController chatController = new ChatController();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Map<String, Object> model = new HashMap<>();

        String servletPath = req.getServletPath();

        String view;
        if ("/private-chat".equals(servletPath)) {
            String customerIdStr = req.getParameter("customerId");

            if (customerIdStr == null && session != null) {
                String userType = (String) session.getAttribute("userType");
                if ("customer".equalsIgnoreCase(userType)) {
                    com.bookshop.model.User user = (com.bookshop.model.User) session.getAttribute("user");
                    if (user != null) {
                        customerIdStr = String.valueOf(user.getId());
                    }
                }
            }

            view = chatController.showPrivateChat(customerIdStr, session, model);
        } else {
            String orderId = req.getParameter("orderId");
            view = chatController.showChat(orderId, session, model);
        }

        for (Map.Entry<String, Object> entry : model.entrySet()) {
            req.setAttribute(entry.getKey(), entry.getValue());
        }

        if (view.startsWith("redirect:")) {
            resp.sendRedirect(req.getContextPath() + view.substring("redirect:".length()));
        } else {
            req.getRequestDispatcher(view).forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        String servletPath = req.getServletPath();

        String redirectUrl;
        if ("/private-chat".equals(servletPath)) {
            String customerId = req.getParameter("customerId");
            String message = req.getParameter("message");

            redirectUrl = chatController.sendPrivateMessage(customerId, message, session);
        } else {
            String orderId = req.getParameter("orderId");
            String message = req.getParameter("message");

            redirectUrl = chatController.postMessage(orderId, message, session);
        }

        if (redirectUrl.startsWith("redirect:")) {
            resp.sendRedirect(req.getContextPath() + redirectUrl.substring("redirect:".length()));
        } else {
            req.getRequestDispatcher(redirectUrl).forward(req, resp);
        }
    }
}

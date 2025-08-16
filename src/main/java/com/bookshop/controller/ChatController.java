package com.bookshop.controller;

import com.bookshop.model.ChatMessage;
import com.bookshop.model.User;
import com.bookshop.service.ChatService;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

public class ChatController {

    private ChatService chatService = new ChatService();

    public String showChat(String orderIdStr, HttpSession session, Map<String, Object> model) {
        if (session == null) return "redirect:/view/login.jsp";

        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/view/login.jsp";

        if (orderIdStr == null) return "redirect:/view/orders.jsp";

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr);
        } catch (NumberFormatException e) {
            return "redirect:/view/orders.jsp";
        }

        try {
            List<ChatMessage> messages = chatService.getMessagesByOrderId(orderId);
            model.put("orderId", orderId);
            model.put("messages", messages);
            return "/view/chat.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/view/orders.jsp";
        }
    }

    public String postMessage(String orderIdStr, String message, HttpSession session) {
        if (session == null) return "redirect:/view/login.jsp";

        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/view/login.jsp";

        if (orderIdStr == null || message == null || message.trim().isEmpty()) {
            return "redirect:/view/orders.jsp";
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr);
        } catch (NumberFormatException e) {
            return "redirect:/view/orders.jsp";
        }

        ChatMessage chatMsg = new ChatMessage();
        chatMsg.setOrderId(orderId);
        chatMsg.setSenderId(user.getId());
        chatMsg.setMessage(message.trim());
        chatMsg.setChatType("order");  // FIXED: set chatType for order chat
        String userType = (String) session.getAttribute("userType");
        chatMsg.setSenderType("staff".equalsIgnoreCase(userType) ? "staff" : "customer");

        try {
            chatService.addMessage(chatMsg);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/chat?orderId=" + orderId;
    }

    public String showPrivateChat(String customerIdStr, HttpSession session, Map<String, Object> model) {
        if (session == null) return "redirect:/view/login.jsp";

        User user = (User) session.getAttribute("user");
        String userType = (String) session.getAttribute("userType");

        if (user == null || userType == null) return "redirect:/view/login.jsp";

        int customerId;
        try {
            customerId = Integer.parseInt(customerIdStr);
        } catch (Exception e) {
            return "redirect:/dashboard.jsp";
        }

        try {
            List<ChatMessage> messages = chatService.getPrivateMessages(customerId, userType);
            model.put("chatCustomerId", customerId);
            model.put("messages", messages);
            return "/view/private-chat.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/dashboard.jsp";
        }
    }

    public String sendPrivateMessage(String customerIdStr, String message, HttpSession session) {
        if (session == null || message == null || message.trim().isEmpty()) {
            return "redirect:/dashboard.jsp";
        }

        User sender = (User) session.getAttribute("user");
        String userType = (String) session.getAttribute("userType");

        int customerId;
        try {
            customerId = Integer.parseInt(customerIdStr);
        } catch (Exception e) {
            return "redirect:/dashboard.jsp";
        }

        ChatMessage msg = new ChatMessage();
        msg.setSenderId(sender.getId());
        msg.setSenderType(userType);
        msg.setChatType("private");
        msg.setMessage(message.trim());

        if ("staff".equalsIgnoreCase(userType)) {
            msg.setReceiverId(customerId); // staff to customer
            msg.setOrderId(0);
        } else {
            msg.setReceiverId(2); // Assuming staff ID 2 for customer messages (adjust as needed)
            msg.setOrderId(0);
        }

        try {
            chatService.addMessage(msg);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/private-chat?customerId=" + customerId;
    }
}

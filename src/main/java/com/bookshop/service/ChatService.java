package com.bookshop.service;

import com.bookshop.dao.ChatDAO;
import com.bookshop.dao.DBConnection;
import com.bookshop.model.ChatMessage;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class ChatService {

    public List<ChatMessage> getMessagesByOrderId(int orderId) throws SQLException {
        try (Connection conn = DBConnection.getInstance().getConnection()) {
            ChatDAO chatDAO = new ChatDAO(conn);
            return chatDAO.getMessagesByOrderId(orderId);
        }
    }

    public boolean addMessage(ChatMessage message) throws SQLException {
        try (Connection conn = DBConnection.getInstance().getConnection()) {
            ChatDAO chatDAO = new ChatDAO(conn);
            return chatDAO.addMessage(message);
        }
    }

    public List<ChatMessage> getPrivateMessages(int customerId, String viewerType) throws SQLException {
        try (Connection conn = DBConnection.getInstance().getConnection()) {
            ChatDAO chatDAO = new ChatDAO(conn);
            return chatDAO.getPrivateMessages(customerId, viewerType);
        }
    }
}

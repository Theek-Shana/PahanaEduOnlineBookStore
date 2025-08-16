package com.bookshop.dao;

import com.bookshop.model.ChatMessage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChatDAO {

    private Connection conn;

    public ChatDAO(Connection conn) {
        this.conn = conn;
    }

    public List<ChatMessage> getMessagesByOrderId(int orderId) throws SQLException {
        List<ChatMessage> messages = new ArrayList<>();
        String sql = "SELECT * FROM chat_messages WHERE order_id = ? AND chat_type = 'order' ORDER BY sent_at ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatMessage msg = mapResultSetToChatMessage(rs);
                    messages.add(msg);
                }
            }
        }
        return messages;
    }

    public List<ChatMessage> getPrivateMessages(int customerId, String viewerType) throws SQLException {
        List<ChatMessage> messages = new ArrayList<>();

        // Fetch private chat messages between customer and staff (or customer itself)
        String sql = "SELECT * FROM chat_messages WHERE chat_type = 'private' AND " +
                     "((sender_id = ? AND sender_type = 'customer') OR (receiver_id = ? AND sender_type = 'staff') " +
                     "OR (sender_id = ? AND sender_type = 'staff') OR (receiver_id = ? AND sender_type = 'customer')) ORDER BY sent_at ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, customerId);
            ps.setInt(3, customerId);
            ps.setInt(4, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatMessage msg = mapResultSetToChatMessage(rs);
                    messages.add(msg);
                }
            }
        }
        return messages;
    }

    public boolean addMessage(ChatMessage msg) throws SQLException {
        String sql = "INSERT INTO chat_messages (order_id, sender_type, sender_id, message, chat_type, receiver_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // order_id can be null for private chat, so set null if <= 0
            if (msg.getOrderId() > 0) {
                ps.setInt(1, msg.getOrderId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            
            ps.setString(2, msg.getSenderType());
            ps.setInt(3, msg.getSenderId());
            ps.setString(4, msg.getMessage());
            ps.setString(5, msg.getChatType());
            
            // receiver_id can be null if not applicable
            if (msg.getReceiverId() != null) {
                ps.setInt(6, msg.getReceiverId());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("ChatDAO.addMessage - rows inserted: " + rowsAffected);
            return rowsAffected > 0;
        }
    }

    private ChatMessage mapResultSetToChatMessage(ResultSet rs) throws SQLException {
        ChatMessage msg = new ChatMessage();
        msg.setId(rs.getInt("id"));
        msg.setOrderId(rs.getInt("order_id"));
        msg.setSenderType(rs.getString("sender_type"));
        msg.setSenderId(rs.getInt("sender_id"));
        msg.setMessage(rs.getString("message"));
        msg.setSentAt(rs.getTimestamp("sent_at"));
        msg.setChatType(rs.getString("chat_type"));
        int receiverId = rs.getInt("receiver_id");
        if (!rs.wasNull()) {
            msg.setReceiverId(receiverId);
        } else {
            msg.setReceiverId(null);
        }
        return msg;
    }
}

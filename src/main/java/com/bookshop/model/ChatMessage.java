package com.bookshop.model;

import java.sql.Timestamp;

public class ChatMessage {
    private int id;
    private int orderId;          
    private String senderType;     
    private int senderId;
    private String message;
    private Timestamp sentAt;
    private String chatType;       
    private Integer receiverId;    

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public String getSenderType() { return senderType; }
    public void setSenderType(String senderType) { this.senderType = senderType; }

    public int getSenderId() { return senderId; }
    public void setSenderId(int senderId) { this.senderId = senderId; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Timestamp getSentAt() { return sentAt; }
    public void setSentAt(Timestamp sentAt) { this.sentAt = sentAt; }

    public String getChatType() { return chatType; }
    public void setChatType(String chatType) { this.chatType = chatType; }

    public Integer getReceiverId() { return receiverId; }
    public void setReceiverId(Integer receiverId) { this.receiverId = receiverId; }

    @Override
    public String toString() {
        return "ChatMessage{" +
                "id=" + id +
                ", orderId=" + orderId +
                ", senderType='" + senderType + '\'' +
                ", senderId=" + senderId +
                ", message='" + message + '\'' +
                ", sentAt=" + sentAt +
                ", chatType='" + chatType + '\'' +
                ", receiverId=" + receiverId +
                '}';
    }
}

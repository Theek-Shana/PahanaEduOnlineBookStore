package com.bookshop.model;

import java.util.Date;
import java.util.List;

public class Order {
    private int orderId;
    private int userId;
    private Date orderDate;
    private double totalAmount;
    private boolean placedByStaff;
    private List<OrderItem> items;

    private String status = "Pending";  // default value

    private String staffMessage;

    private String customerName;  // Add this field

    // getters/setters for all fields

    public int getOrderId() {
        return orderId;
    }
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getOrderDate() {
        return orderDate;
    }
    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public boolean isPlacedByStaff() {
        return placedByStaff;
    }
    public void setPlacedByStaff(boolean placedByStaff) {
        this.placedByStaff = placedByStaff;
    }

    public List<OrderItem> getItems() {
        return items;
    }
    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public String getStaffMessage() {
        return staffMessage;
    }
    public void setStaffMessage(String staffMessage) {
        this.staffMessage = staffMessage;
    }
    private int quantity;

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }


    public String getCustomerName() {
        return customerName;
    }
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
 // add this field near other private fields
    private String staffName;

    // add getter and setter
    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }
    private Integer staffId; // Integer (nullable)
    public Integer getStaffId() { return staffId; }
    public void setStaffId(Integer staffId) { this.staffId = staffId; }

    
 // Add this near the other private fields:
    private String customerEmail;

    // Add getter and setter for customerEmail:
    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    
    
    
    
}

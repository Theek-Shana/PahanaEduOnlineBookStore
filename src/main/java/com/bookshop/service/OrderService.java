package com.bookshop.service;

import com.bookshop.dao.OrderDAO;
import com.bookshop.model.Order;

import java.sql.SQLException;
import java.util.List;

public class OrderService {

    private static OrderService instance;
    private final OrderDAO orderDAO;

  
    private OrderService() throws SQLException {
        this.orderDAO = new OrderDAO();
    }

  
    public static OrderService getInstance() throws SQLException {
        if (instance == null) {
            instance = new OrderService();
        }
        return instance;
    }

    /**
     * Place a new order.
     * @param order The order object
     * @return true if order placed successfully
     */
    public boolean placeOrder(Order order) {
        try {
            int orderId = orderDAO.placeOrder(order);
            return orderId > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get all orders.
     * @return List of orders
     */
    public List<Order> getAllOrders() {
        try {
            return orderDAO.getAllOrders();
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of(); 
        }
    }

    /**
     * Update order status.
     * @param orderId ID of the order
     * @param status New status
     * @param message Optional message
     * @param staffId Staff who updated
     * @return true if update successful
     */
    public boolean updateOrderStatus(int orderId, String status, String message, int staffId) {
        try {
            return orderDAO.updateOrderStatus(orderId, status, message, staffId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
    
    
    
    
    
    // --------- Add this constructor for testing only ---------
    public OrderService(OrderDAO orderDAO) {
        this.orderDAO = orderDAO;
    }
}

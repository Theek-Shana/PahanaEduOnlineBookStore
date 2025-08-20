package com.bookshop.service;

import com.bookshop.dao.OrderDAO;
import com.bookshop.model.Order;
import java.sql.SQLException;
import java.util.List;

public class OrderService {

    private static OrderService instance;
    private final OrderDAO orderDAO;

    // Production singleton constructor
    private OrderService() throws SQLException {
        this.orderDAO = new OrderDAO();
    }

    // Test constructor: inject mock DAO
    public OrderService(OrderDAO dao) {
        this.orderDAO = dao;
    }

    public static OrderService getInstance() throws SQLException {
        if (instance == null) {
            instance = new OrderService();
        }
        return instance;
    }

    public boolean placeOrder(Order order) {
        try {
            int orderId = orderDAO.placeOrder(order);
            return orderId > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Order> getAllOrders() {
        try {
            return orderDAO.getAllOrders();
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of(); 
        }
    }

    public boolean updateOrderStatus(int orderId, String status, String message, int staffId) {
        try {
            return orderDAO.updateOrderStatus(orderId, status, message, staffId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}

package com.bookshop.service;

import com.bookshop.dao.OrderDAO;
import com.bookshop.model.Order;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class OrderService {

    private OrderDAO orderDAO;

    public OrderService(Connection conn) {
        this.orderDAO = new OrderDAO(conn);
    }

    public boolean placeOrder(Order order) throws SQLException {
        int orderId = orderDAO.placeOrder(order);
        return orderId > 0;
    }
    public List<Order> getAllOrders() throws SQLException {
        return orderDAO.getAllOrders();
    }

    public boolean updateOrderStatus(int orderId, String status, String message, int staffId) throws SQLException {
        return orderDAO.updateOrderStatus(orderId, status, message, staffId);
    }
}

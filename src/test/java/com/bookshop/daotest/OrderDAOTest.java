package com.bookshop.daotest;

import com.bookshop.dao.OrderDAO;
import com.bookshop.model.OrderItem;
import org.junit.jupiter.api.*;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class OrderDAOTest {

    private static OrderDAO orderDAO;

    @BeforeAll
    public static void setup() throws SQLException {
        orderDAO = new OrderDAO();
    }

    @Test
    @org.junit.jupiter.api.Order(1)
    public void testGetAllOrders() throws SQLException {
        List<com.bookshop.model.Order> orders = orderDAO.getAllOrders();
        assertNotNull(orders, "Orders list should not be null");
        System.out.println("✅ Retrieved " + orders.size() + " orders successfully");
    }

    @Test
    @org.junit.jupiter.api.Order(2)
    public void testGetOrdersByUserId() throws SQLException {
        int testUserId = 1; // safe existing user ID
        List<com.bookshop.model.Order> orders = orderDAO.getOrdersByUserId(testUserId);
        assertNotNull(orders, "User orders should not be null");
        System.out.println("✅ Retrieved " + orders.size() + " orders for user ID " + testUserId);
    }

    @Test
    @org.junit.jupiter.api.Order(3)
    public void testGetOrderById() throws SQLException {
        int testOrderId = 1; // safe existing order ID
        com.bookshop.model.Order testOrder = orderDAO.getOrderById(testOrderId);
        assertNotNull(testOrder, "Order should not be null");
        System.out.println("✅ Order ID " + testOrderId + " retrieved successfully");
    }

    @Test
    @org.junit.jupiter.api.Order(4)
    public void testSafePlaceOrderRollback() throws SQLException, NoSuchFieldException, IllegalAccessException {
        // simulate placing an order without committing to DB
        Field connField = orderDAO.getClass().getDeclaredField("conn");
        connField.setAccessible(true);
        Connection conn = (Connection) connField.get(orderDAO);
        assertNotNull(conn, "Connection should exist");

        conn.setAutoCommit(false); // start transaction

        try {
            com.bookshop.model.Order testOrder = new com.bookshop.model.Order();
            testOrder.setUserId(1);
            testOrder.setTotalAmount(100);
            testOrder.setStatus("Pending");
            testOrder.setPlacedByStaff(false);

            List<OrderItem> items = new ArrayList<>();
            OrderItem item = new OrderItem();
            item.setItemId(1); // safe existing item
            item.setQuantity(1);
            item.setPrice(100);
            items.add(item);

            testOrder.setItems(items);

            int generatedOrderId = orderDAO.placeOrder(testOrder);
            assertTrue(generatedOrderId > 0, "Order ID should be generated");
            System.out.println("✅ Simulated order placement (ID " + generatedOrderId + ")");

            conn.rollback(); // rollback so nothing is saved
        } finally {
            conn.setAutoCommit(true); // restore auto-commit
        }
    }

    @Test
    @org.junit.jupiter.api.Order(5)
    public void testIntentionalFail() throws SQLException {
        // Intentional fail to show red mark in JUnit
        List<com.bookshop.model.Order> orders = orderDAO.getAllOrders();
        assertEquals(-1, orders.size(), "This test is supposed to fail intentionally");
    }
}

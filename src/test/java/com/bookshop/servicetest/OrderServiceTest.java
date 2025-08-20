package com.bookshop.servicetest;

import com.bookshop.dao.OrderDAO;
import com.bookshop.model.Order;
import com.bookshop.service.OrderService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class OrderServiceTest {

    private OrderDAO mockDAO;
    private OrderService orderService;

    @BeforeEach
    void setUp() {
        // Initialize mocks
        mockDAO = mock(OrderDAO.class);

        // Inject mock into service
        orderService = new OrderService(mockDAO);
    }

    @Test
    void testGetAllOrders() throws SQLException {
        Order order1 = new Order();
        Order order2 = new Order();

        // Mock DAO response
        when(mockDAO.getAllOrders()).thenReturn(Arrays.asList(order1, order2));

        // Call service method
        List<Order> orders = orderService.getAllOrders();

        // Assertions
        assertEquals(2, orders.size());
        verify(mockDAO, times(1)).getAllOrders();
    }
}
 
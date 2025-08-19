package com.bookshop.servicetest;

import com.bookshop.dao.OrderDAO;
import com.bookshop.model.Order;
import com.bookshop.service.OrderService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

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
        mockDAO = mock(OrderDAO.class);           // create mock DAO
        orderService = new OrderService(mockDAO); // inject mock DAO
    }

  

    @Test
    void testGetAllOrders() throws SQLException {
        Order order1 = new Order();
        Order order2 = new Order();
        when(mockDAO.getAllOrders()).thenReturn(Arrays.asList(order1, order2));

        List<Order> orders = orderService.getAllOrders();

        assertEquals(2, orders.size());
        verify(mockDAO, times(1)).getAllOrders();
    }
}



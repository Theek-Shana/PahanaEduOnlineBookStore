package com.bookshop.servicetest;

import com.bookshop.dao.OrderDAO;
import com.bookshop.model.Order;
import com.bookshop.service.OrderService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class OrderServiceTest {

    private OrderDAO mockDAO;
    private OrderService orderService;

    @BeforeEach
    void setUp() {
        mockDAO = mock(OrderDAO.class);          // create a mock DAO
        orderService = new OrderService(mockDAO); // inject mock into service
    }

    @Test
    void testGetAllOrders() throws Exception {
        List<Order> fakeOrders = List.of(new Order(), new Order());
        when(mockDAO.getAllOrders()).thenReturn(fakeOrders);

        List<Order> result = orderService.getAllOrders();

        assertNotNull(result);
        assertEquals(2, result.size());
        verify(mockDAO, times(1)).getAllOrders();
    }

    @Test
    void testPlaceOrder() throws Exception {
        Order order = new Order();
        when(mockDAO.placeOrder(order)).thenReturn(123);

        boolean placed = orderService.placeOrder(order);

        assertTrue(placed);
        verify(mockDAO, times(1)).placeOrder(order);
    }
}

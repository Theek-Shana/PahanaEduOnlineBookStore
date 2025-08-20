package com.bookshop.controllertest;

import com.bookshop.controller.PrintBillController;
import com.bookshop.dao.OrderDAO;
import com.bookshop.model.Order;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

import static org.mockito.Mockito.*;

class PrintBillControllerTest {

    private PrintBillController controller;
    private OrderDAO orderDAO;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() throws Exception {
        // Initialize controller and mocks
        controller = new PrintBillController();
        orderDAO = mock(OrderDAO.class);
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        dispatcher = mock(RequestDispatcher.class);

        // Inject mocked DAO using reflection
        var field = PrintBillController.class.getDeclaredField("orderDAO");
        field.setAccessible(true);
        field.set(controller, orderDAO);
    }

    // ---------- Test 1: Order exists ----------
    @Test
    void testPrintBillSuccess() throws Exception {
        when(request.getParameter("orderId")).thenReturn("1");
        Order order = new Order();
        when(orderDAO.getOrderById(1)).thenReturn(order);
        when(request.getRequestDispatcher("/view/printBill.jsp")).thenReturn(dispatcher);

        controller.doGet(request, response);

        verify(orderDAO, times(1)).getOrderById(1);
        verify(request, times(1)).setAttribute("order", order);
        verify(dispatcher, times(1)).forward(request, response);
    }

    // ---------- Test 2: Missing orderId ----------
    @Test
    void testMissingOrderId() throws IOException, ServletException {
        when(request.getParameter("orderId")).thenReturn(null);

        controller.doGet(request, response);

        // Realistic failure: verify correct error sent
        verify(response, times(1)).sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing orderId");
    }

    // ---------- Test 3: Order not found ----------
    @Test
    void testOrderNotFound() throws Exception {
        when(request.getParameter("orderId")).thenReturn("999");
        when(orderDAO.getOrderById(999)).thenReturn(null);

        controller.doGet(request, response);

        verify(orderDAO, times(1)).getOrderById(999);
        verify(response, times(1)).sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
    }
}
 
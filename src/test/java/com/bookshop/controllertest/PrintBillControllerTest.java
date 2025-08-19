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
import java.sql.SQLException;

import static org.mockito.Mockito.*;

class PrintBillControllerTest {

    private PrintBillController controller;
    private OrderDAO orderDAO;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() throws Exception {
        controller = new PrintBillController();
        orderDAO = mock(OrderDAO.class);
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        dispatcher = mock(RequestDispatcher.class);

        // Inject mocked DAO into controller using reflection
        var field = PrintBillController.class.getDeclaredField("orderDAO");
        field.setAccessible(true);
        field.set(controller, orderDAO);
    }

    // ---------- Success Case: Order exists ----------
    @Test
    void testPrintBillSuccess() throws Exception {
        when(request.getParameter("orderId")).thenReturn("1");
        Order order = new Order();
        when(orderDAO.getOrderById(1)).thenReturn(order);
        when(request.getRequestDispatcher("/view/printBill.jsp")).thenReturn(dispatcher);

        controller.doGet(request, response);

        verify(orderDAO).getOrderById(1);
        verify(request).setAttribute("order", order);
        verify(dispatcher).forward(request, response);
    }


    @Test
    void testMissingOrderIdFails() throws IOException, ServletException {
        when(request.getParameter("orderId")).thenReturn(null);

        controller.doGet(request, response);

        // Intentionally fail: check for a wrong error message
        verify(response).sendError(HttpServletResponse.SC_BAD_REQUEST, "SomeWrongErrorMessage");
    }



   
}

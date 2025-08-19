package com.bookshop.controller;

import com.bookshop.dao.DBConnection;
import com.bookshop.dao.OrderDAO;
import com.bookshop.model.Order;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/staff/printBill")
public class PrintBillController extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            Connection connection = DBConnection.getInstance().getConnection();
            orderDAO = new OrderDAO(connection);
        } catch (SQLException e) {
            throw new ServletException("Cannot initialize DB connection", e);
        }
    }

    @Override
	public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing orderId parameter");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid orderId parameter");
            return;
        }

        try {
            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                return;
            }

            request.setAttribute("order", order);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/view/printBill.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException ex) {
            throw new ServletException("Database error retrieving order", ex);
        }
    }
}

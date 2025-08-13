package com.bookshop.controller;

import com.bookshop.dao.OrderDAO;
import com.bookshop.dao.DBConnection;
import com.bookshop.model.ReportModel;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;


@WebServlet("/reports")
public class ReportServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            OrderDAO orderDAO = new OrderDAO(DBConnection.getInstance().getConnection());

            // Call your DAO method to get the report
            ReportModel report = orderDAO.getAllReports("MONTH", 10);

            // Add the report data as a request attribute for JSP access
            req.setAttribute("report", report);

            // Forward the request to the JSP page for rendering
            RequestDispatcher dispatcher = req.getRequestDispatcher("/view/report.jsp");
            dispatcher.forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Database error while fetching report", e);
        }
    }
}

package com.bookshop.controller;

import com.bookshop.dao.DBConnection;
import com.bookshop.dao.OrderDAO;
import com.bookshop.model.Order;
import com.bookshop.model.OrderItem;
import com.bookshop.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/order")
public class OrderController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	    HttpSession session = req.getSession(false);
	    if (session == null || session.getAttribute("user") == null) {
	        resp.sendRedirect(req.getContextPath() + "/view/login.jsp");
	        return;
	    }

	    User user = (User) session.getAttribute("user");
	    int userId = user.getId();

	    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
	    if (cart == null || cart.isEmpty()) {
	        resp.sendRedirect(req.getContextPath() + "/view/cart.jsp?error=emptycart");
	        return;
	    }

	    try (Connection conn = DBConnection.getInstance().getConnection()) {
	        OrderDAO orderDAO = new OrderDAO(conn);

	        Order order = new Order();
	        order.setUserId(userId);

	        if ("staff".equalsIgnoreCase(user.getRole())) {
	            order.setPlacedByStaff(true);
	            order.setStaffId(user.getId());
	        } else {
	            order.setPlacedByStaff(false);
	            order.setStaffId(null);
	        }
  

	        List<OrderItem> orderItems = new ArrayList<>();
	        double totalAmount = 0.0;

	        String priceQuery = "SELECT price FROM item WHERE item_id = ?";
	        try (PreparedStatement priceStmt = conn.prepareStatement(priceQuery)) {
	            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
	                int itemId = entry.getKey();
	                int quantity = entry.getValue();

	                priceStmt.setInt(1, itemId);
	                try (ResultSet rs = priceStmt.executeQuery()) {
	                    if (rs.next()) {
	                        double price = rs.getDouble("price");
	                        totalAmount += price * quantity;

	                        OrderItem oi = new OrderItem();
	                        oi.setItemId(itemId);
	                        oi.setQuantity(quantity);
	                        oi.setPrice(price);
	                        orderItems.add(oi);
	                    } else {
	                        throw new SQLException("Invalid item ID: " + itemId);
	                    }
	                }
	            }
	        }

	        order.setTotalAmount(totalAmount);
	        order.setItems(orderItems);

	        int orderId = orderDAO.placeOrder(order);

	        if (orderId > 0) {
	            session.removeAttribute("cart");
	            resp.sendRedirect(req.getContextPath() + "/view/orderSuccess.jsp?orderId=" + orderId);
	        } else {
	            resp.sendRedirect(req.getContextPath() + "/view/cart.jsp?error=orderfailed");
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        resp.sendRedirect(req.getContextPath() + "/view/cart.jsp?error=orderfailed");
	    }
	}

    
	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/view/login.jsp");
            return;
        }

        String orderIdStr = req.getParameter("orderId");
        if (orderIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/view/customerDashboard.jsp");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/view/customerDashboard.jsp");
            return;
        }

        try (Connection conn = DBConnection.getInstance().getConnection()) {
            OrderDAO orderDAO = new OrderDAO(conn);
            Order order = orderDAO.getOrderById(orderId); 
            if (order == null) {
                resp.sendRedirect(req.getContextPath() + "/view/customerDashboard.jsp");
                return;
            }

            req.setAttribute("order", order);
            req.getRequestDispatcher("/view/orderConfirmation.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/view/customerDashboard.jsp");
        }
    }
}

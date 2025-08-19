package com.bookshop.controller;

import com.bookshop.dao.*;
import com.bookshop.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/staff/orders", "/staff/createOrder", "/staff/addOrderItems"})
public class StaffOrderController extends HttpServlet {

    private UserDAO userDAO;
    private OrderDAO orderDAO;
    private ItemDAO itemDAO;

    @Override
    public void init() throws ServletException {
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            userDAO = new UserDAO();
            orderDAO = new OrderDAO(conn);
            itemDAO = new ItemDAO();
        } catch (SQLException e) {
            throw new ServletException("Failed to initialize DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User loggedInUser = getLoggedInUser(req);
        if (!isStaffOrAdmin(loggedInUser)) {
            resp.sendRedirect(req.getContextPath() + "/view/login.jsp");
            return;
        }

        String path = req.getServletPath();
        switch (path) {
            case "/staff/orders":
                handleOrdersList(req, resp, loggedInUser);
                break;
            case "/staff/createOrder":
                handleCreateOrderGet(req, resp);
                break;
            case "/staff/addOrderItems":
                handleAddOrderItemsGet(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User loggedInUser = getLoggedInUser(req);
        if (!isStaffOrAdmin(loggedInUser)) {
            resp.sendRedirect(req.getContextPath() + "/view/login.jsp");
            return;
        }

        String path = req.getServletPath();
        switch (path) {
            case "/staff/orders":
                handleOrdersPost(req, resp, loggedInUser);
                break;
            case "/staff/createOrder":
                handleCreateOrderPost(req, resp);
                break;
            case "/staff/addOrderItems":
                handleAddOrderItemsPost(req, resp, loggedInUser);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ---------- Helper Methods ----------
    private User getLoggedInUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }

    private boolean isStaffOrAdmin(User user) {
        if (user == null) return false;
        String role = user.getRole();
        return "staff".equalsIgnoreCase(role) || "admin".equalsIgnoreCase(role);
    }

    // ---------- GET Handlers ----------
    private void handleOrdersList(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        try {
            List<Order> orders = orderDAO.getAllOrders();
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/view/staff_orders.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error occurred while fetching orders.");
            req.getRequestDispatcher("/view/staff_orders.jsp").forward(req, resp);
        }
    }

    private void handleCreateOrderGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<User> customers = userDAO.getUsersByRole("customer");
            req.setAttribute("customers", customers);
            req.getRequestDispatcher("/view/add_order.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void handleAddOrderItemsGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String customerIdStr = req.getParameter("customerId");
        if (customerIdStr == null || customerIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/staff/createOrder");
            return;
        }

        int customerId;
        try {
            customerId = Integer.parseInt(customerIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/staff/createOrder");
            return;
        }

        List<Item> items = itemDAO.getAllItems();
        req.setAttribute("items", items);
        req.setAttribute("customerId", customerId);
        req.getRequestDispatcher("/view/staff_add_order_items.jsp").forward(req, resp);
    }

    // ---------- POST Handlers ----------
    private void handleOrdersPost(HttpServletRequest req, HttpServletResponse resp, User loggedInUser) throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(req.getParameter("order_id"));
            String status = req.getParameter("status");
            String message = req.getParameter("message");

            boolean updated = orderDAO.updateOrderStatus(orderId, status, message, loggedInUser.getId());

            if (updated) {
                req.setAttribute("success", "Order updated successfully.");
            } else {
                req.setAttribute("error", "Failed to update the order.");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid order ID.");
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Database error occurred while updating order.");
        }
        handleOrdersList(req, resp, loggedInUser);
    }

    private void handleCreateOrderPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String customerIdStr = req.getParameter("customerId");
        if (customerIdStr == null || customerIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/staff/createOrder");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/staff/addOrderItems?customerId=" + customerIdStr);
    }

    private void handleAddOrderItemsPost(HttpServletRequest req, HttpServletResponse resp, User loggedInUser) throws ServletException, IOException {
        try {
            String customerIdStr = req.getParameter("customerId");
            if (customerIdStr == null || customerIdStr.isEmpty()) {
                req.setAttribute("error", "Customer ID missing.");
                handleCreateOrderGet(req, resp);
                return;
            }

            int customerId = Integer.parseInt(customerIdStr);

            String[] itemIds = req.getParameterValues("itemId[]");
            String[] quantities = req.getParameterValues("quantity[]");
            String[] discounts = req.getParameterValues("discount[]");

            if (itemIds == null || quantities == null || itemIds.length != quantities.length) {
                req.setAttribute("error", "Invalid order submission.");
                handleAddOrderItemsGet(req, resp);
                return;
            }

            List<OrderItem> orderItems = new ArrayList<>();
            double totalAmount = 0.0;

            for (int i = 0; i < itemIds.length; i++) {
                int itemId = Integer.parseInt(itemIds[i]);
                int qty = Integer.parseInt(quantities[i]);
                double discount = 0.0;

                if (discounts != null && discounts.length > i) {
                    try {
                        discount = Double.parseDouble(discounts[i]);
                        if (discount < 0) discount = 0;
                        if (discount > 100) discount = 100;
                    } catch (NumberFormatException e) {
                        discount = 0;
                    }
                }

                if (qty <= 0) continue;

                Item item = itemDAO.getItemById(itemId);
                if (item == null) continue;

                double discountedPricePerUnit = item.getPrice() * (1 - discount / 100.0);
                totalAmount += discountedPricePerUnit * qty;

                OrderItem orderItem = new OrderItem();
                orderItem.setItemId(itemId);
                orderItem.setQuantity(qty);
                orderItem.setPrice(discountedPricePerUnit);

                orderItems.add(orderItem);
            }

            if (orderItems.isEmpty()) {
                req.setAttribute("error", "No valid items selected.");
                handleAddOrderItemsGet(req, resp);
                return;
            }

            Order order = new Order();
            order.setUserId(customerId);
            order.setStaffId(loggedInUser.getId());
            order.setItems(orderItems);
            order.setTotalAmount(totalAmount);
            order.setStatus("Pending");
            order.setPlacedByStaff(true);

            int orderId = orderDAO.placeOrder(order);

            if (orderId > 0) {
                resp.sendRedirect(req.getContextPath() + "/staff/orders?success=OrderPlaced");
            } else {
                req.setAttribute("error", "Failed to place order.");
                handleAddOrderItemsGet(req, resp);
            }

        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Error processing order: " + e.getMessage());
            handleAddOrderItemsGet(req, resp);
        }
    }
}

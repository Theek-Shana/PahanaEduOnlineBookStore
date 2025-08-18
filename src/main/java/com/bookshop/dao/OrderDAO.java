package com.bookshop.dao;

import com.bookshop.model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private final Connection conn;

    // No-arg constructor: uses singleton DBConnection
    public OrderDAO() throws SQLException {
        this.conn = DBConnection.getInstance().getConnection();
    }

    // Optional constructor for testing or flexibility
    public OrderDAO(Connection conn) {
        this.conn = conn;
    }

    /**
     * Place a new order with associated order items.
     * Returns the generated order ID.
     */
    public int placeOrder(Order order) throws SQLException {
        String insertOrderSQL = "INSERT INTO orders (user_id, total_amount, placed_by_staff, staff_id, order_status) VALUES (?, ?, ?, ?, ?)";
        String insertOrderItemSQL = "INSERT INTO order_items (order_id, item_id, quantity, price) VALUES (?, ?, ?, ?)";

        int orderId = -1;

        try {
            conn.setAutoCommit(false);

            // Insert order main record
            try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getUserId());
                psOrder.setDouble(2, order.getTotalAmount());
                psOrder.setBoolean(3, order.isPlacedByStaff());

                if (order.getStaffId() != null) {
                    psOrder.setInt(4, order.getStaffId());
                } else {
                    psOrder.setNull(4, Types.INTEGER);
                }

                psOrder.setString(5, order.getStatus());
                int affectedRows = psOrder.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Creating order failed, no rows affected.");
                }

                // Get generated order ID
                try (ResultSet generatedKeys = psOrder.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        orderId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating order failed, no ID obtained.");
                    }
                }
            }

            // Insert order items
            try (PreparedStatement psOrderItem = conn.prepareStatement(insertOrderItemSQL)) {
                for (OrderItem oi : order.getItems()) {
                    psOrderItem.setInt(1, orderId);
                    psOrderItem.setInt(2, oi.getItemId());
                    psOrderItem.setInt(3, oi.getQuantity());
                    psOrderItem.setDouble(4, oi.getPrice());
                    psOrderItem.addBatch();
                }
                psOrderItem.executeBatch();
            }

            conn.commit();

        } catch (SQLException ex) {
            conn.rollback();
            throw ex;
        } finally {
            conn.setAutoCommit(true);
        }

        return orderId;
    }


    /**
     * Get all orders with customer and staff names and order items.
     */
    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();

        String sql = "SELECT o.order_id, o.user_id, o.total_amount, o.order_date, o.placed_by_staff, o.order_status, o.staff_message, " +
                     "u.fullname AS customerName, s.fullname AS staffName " +
                     "FROM orders o " +
                     "JOIN users u ON o.user_id = u.id " +
                     "LEFT JOIN users s ON o.staff_id = s.id";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();

                int orderId = rs.getInt("order_id");
                order.setOrderId(orderId);
                order.setUserId(rs.getInt("user_id"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setPlacedByStaff(rs.getBoolean("placed_by_staff"));
                order.setStatus(rs.getString("order_status"));
                order.setStaffMessage(rs.getString("staff_message"));
                order.setCustomerName(rs.getString("customerName"));
                order.setStaffName(rs.getString("staffName"));

                // Fetch order items with book titles
                List<OrderItem> items = new ArrayList<>();
                String itemSql = "SELECT oi.item_id, oi.quantity, oi.price, i.title FROM order_items oi JOIN item i ON oi.item_id = i.item_id WHERE oi.order_id = ?";
                try (PreparedStatement itemStmt = conn.prepareStatement(itemSql)) {
                    itemStmt.setInt(1, orderId);
                    try (ResultSet itemRs = itemStmt.executeQuery()) {
                        while (itemRs.next()) {
                            OrderItem item = new OrderItem();
                            item.setItemId(itemRs.getInt("item_id"));
                            item.setQuantity(itemRs.getInt("quantity"));
                            item.setPrice(itemRs.getDouble("price"));
                            item.setBookTitle(itemRs.getString("title"));
                            items.add(item);
                        }
                    }
                }
                order.setItems(items);

                orders.add(order);
            }
        }

        return orders;
    }

    /**
     * Update the status and staff message of an order.
     * Also update stock quantity if order is shipped or delivered.
     */
    public boolean updateOrderStatus(int orderId, String status, String message, int staffId) throws SQLException {
        boolean updated = false;

        try {
            conn.setAutoCommit(false);

            // Update order status, message, and staff
            String sqlUpdateOrder = "UPDATE orders SET order_status = ?, staff_message = ?, staff_id = ? WHERE order_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sqlUpdateOrder)) {
                stmt.setString(1, status);
                stmt.setString(2, message);
                stmt.setInt(3, staffId);
                stmt.setInt(4, orderId);
                updated = stmt.executeUpdate() > 0;
            }

            // Adjust stock if delivered or shipped
            if (updated && ("Delivered".equalsIgnoreCase(status) || "Shipped".equalsIgnoreCase(status))) {
                String sqlGetItems = "SELECT item_id, quantity FROM order_items WHERE order_id = ?";
                try (PreparedStatement psItems = conn.prepareStatement(sqlGetItems)) {
                    psItems.setInt(1, orderId);
                    try (ResultSet rs = psItems.executeQuery()) {
                        String sqlUpdateStock = "UPDATE item SET stock_quantity = stock_quantity - ? WHERE item_id = ? AND stock_quantity >= ?";
                        try (PreparedStatement psUpdateStock = conn.prepareStatement(sqlUpdateStock)) {
                            while (rs.next()) {
                                int itemId = rs.getInt("item_id");
                                int quantity = rs.getInt("quantity");

                                psUpdateStock.setInt(1, quantity);
                                psUpdateStock.setInt(2, itemId);
                                psUpdateStock.setInt(3, quantity);

                                int affectedRows = psUpdateStock.executeUpdate();
                                if (affectedRows == 0) {
                                    throw new SQLException("Insufficient stock for item ID: " + itemId);
                                }
                            }
                        }
                    }
                }
            }

            conn.commit();

        } catch (SQLException ex) {
            conn.rollback();
            throw ex;
        } finally {
            conn.setAutoCommit(true);
        }

        return updated;
    }
    /**
     * Get orders that are pending or recently placed (within 1 day).
     */
    public List<Order> getPendingOrRecentOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE order_status = 'Pending' OR order_date >= NOW() - INTERVAL 1 DAY ORDER BY order_date DESC";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setPlacedByStaff(rs.getBoolean("placed_by_staff"));
                order.setStatus(rs.getString("order_status"));
                order.setStaffMessage(rs.getString("staff_message"));
                orders.add(order);
            }
        }

        return orders;
    }

    /**
     * Get all orders placed by a specific user.
     */
    public List<Order> getOrdersByUserId(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.fullname AS customerName FROM orders o JOIN users u ON o.user_id = u.id WHERE o.user_id = ? ORDER BY o.order_date DESC";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    int orderId = rs.getInt("order_id");

                    order.setOrderId(orderId);
                    order.setUserId(rs.getInt("user_id"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setOrderDate(rs.getTimestamp("order_date"));
                    order.setPlacedByStaff(rs.getBoolean("placed_by_staff"));
                    order.setStatus(rs.getString("order_status"));
                    order.setStaffMessage(rs.getString("staff_message"));
                    order.setCustomerName(rs.getString("customerName"));

                    // Fetch order items with book titles
                    List<OrderItem> items = new ArrayList<>();
                    String itemSql = "SELECT oi.item_id, oi.quantity, oi.price, i.title FROM order_items oi JOIN item i ON oi.item_id = i.item_id WHERE oi.order_id = ?";
                    try (PreparedStatement itemStmt = conn.prepareStatement(itemSql)) {
                        itemStmt.setInt(1, orderId);
                        try (ResultSet itemRs = itemStmt.executeQuery()) {
                            while (itemRs.next()) {
                                OrderItem item = new OrderItem();
                                item.setItemId(itemRs.getInt("item_id"));
                                item.setQuantity(itemRs.getInt("quantity"));
                                item.setPrice(itemRs.getDouble("price"));
                                item.setBookTitle(itemRs.getString("title"));
                                items.add(item);
                            }
                        }
                    }

                    order.setItems(items);
                    orders.add(order);
                }
            }
        }

        return orders;
    }

    /**
     * Delete order and its items by order ID and user ID (for ownership verification).
     */
    public boolean deleteOrderById(int orderId, int userId) throws SQLException {
        // Verify order ownership for security
        String checkSql = "SELECT COUNT(*) FROM orders WHERE order_id = ? AND user_id = ?";
        try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            checkStmt.setInt(1, orderId);
            checkStmt.setInt(2, userId);
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) == 0) {
                    // Order does not belong to user or does not exist
                    return false;
                }
            }
        }

        try {
            conn.setAutoCommit(false);

            // Delete order items first (to satisfy FK constraints)
            String deleteItemsSql = "DELETE FROM order_items WHERE order_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteItemsSql)) {
                stmt.setInt(1, orderId);
                stmt.executeUpdate();
            }

            // Delete the order itself
            String deleteOrderSql = "DELETE FROM orders WHERE order_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteOrderSql)) {
                stmt.setInt(1, orderId);
                stmt.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException ex) {
            conn.rollback();
            throw ex;
        } finally {
            conn.setAutoCommit(true);
        }
    }
    public Order getOrderById(int orderId) throws SQLException {
        Order order = null;

        // Main order query with customer and staff info
        String sql = """
            SELECT o.order_id, o.user_id, o.total_amount, o.order_date, o.placed_by_staff, 
                   o.order_status, o.staff_message,
                   u.fullname AS customerName, u.email AS customerEmail,
                   s.fullname AS staffName
            FROM orders o
            JOIN users u ON o.user_id = u.id
            LEFT JOIN users s ON o.staff_id = s.id
            WHERE o.order_id = ?
            """;

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    order = new Order();

                    order.setOrderId(rs.getInt("order_id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setOrderDate(rs.getTimestamp("order_date"));
                    order.setPlacedByStaff(rs.getBoolean("placed_by_staff"));
                    order.setStatus(rs.getString("order_status"));
                    order.setStaffMessage(rs.getString("staff_message"));
                    order.setCustomerName(rs.getString("customerName"));
                    order.setCustomerEmail(rs.getString("customerEmail"));
                    order.setStaffName(rs.getString("staffName"));

                    // Fetch order items with book titles
                    String itemSql = """
                        SELECT oi.item_id, oi.quantity, oi.price, i.title 
                        FROM order_items oi
                        JOIN item i ON oi.item_id = i.item_id
                        WHERE oi.order_id = ?
                        """;

                    List<OrderItem> items = new ArrayList<>();
                    try (PreparedStatement itemStmt = conn.prepareStatement(itemSql)) {
                        itemStmt.setInt(1, orderId);
                        try (ResultSet itemRs = itemStmt.executeQuery()) {
                            while (itemRs.next()) {
                                OrderItem item = new OrderItem();
                                item.setItemId(itemRs.getInt("item_id"));
                                item.setQuantity(itemRs.getInt("quantity"));
                                item.setPrice(itemRs.getDouble("price"));
                                item.setBookTitle(itemRs.getString("title")); // consistent naming
                                items.add(item);
                            }
                        }
                    }
                    order.setItems(items);
                }
            }
        }

        return order;
    }



    
    public ReportModel getAllReports(String salesPeriodType, int topItemsLimit) throws SQLException {
        ReportModel report = new ReportModel();

        // Sales by period (day/week/month)
        report.setSalesReports(getSalesByPeriod(salesPeriodType));

        // Order summary by status
        report.setOrderSummaries(getOrderSummary());

        // Top selling items (limit)
        report.setTopSellingItems(getTopSellingItems(topItemsLimit));

        // Staff performance
        report.setStaffPerformances(getStaffPerformance());

        // User order counts - NEW
        report.setUserOrderCounts(getUserOrderCounts());

        return report;
    }

    private List<ReportModel.SalesReport> getSalesByPeriod(String periodType) throws SQLException {
        String dateFormat;
        switch (periodType.toUpperCase()) {
            case "DAY": dateFormat = "%Y-%m-%d"; break;
            case "WEEK": dateFormat = "%Y-%u"; break;
            case "MONTH": dateFormat = "%Y-%m"; break;
            default: throw new IllegalArgumentException("Invalid periodType: " + periodType);
        }

        String sql = "SELECT DATE_FORMAT(order_date, '" + dateFormat + "') AS period, SUM(total_amount) AS totalSales " +
                     "FROM orders GROUP BY period ORDER BY period";

        List<ReportModel.SalesReport> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ReportModel.SalesReport(rs.getString("period"), rs.getDouble("totalSales")));
            }
        }
        return list;
    }

    private List<ReportModel.OrderSummary> getOrderSummary() throws SQLException {
        String sql = "SELECT order_status, COUNT(*) AS count FROM orders GROUP BY order_status";

        List<ReportModel.OrderSummary> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ReportModel.OrderSummary(rs.getString("order_status"), rs.getInt("count")));
            }
        }
        return list;
    }

    private List<ReportModel.TopSellingItem> getTopSellingItems(int limit) throws SQLException {
        String sql = "SELECT oi.item_id, i.title, SUM(oi.quantity) AS totalQuantitySold " +
                     "FROM order_items oi JOIN item i ON oi.item_id = i.item_id " +
                     "GROUP BY oi.item_id, i.title " +
                     "ORDER BY totalQuantitySold DESC LIMIT ?";

        List<ReportModel.TopSellingItem> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ReportModel.TopSellingItem(
                        rs.getInt("item_id"),
                        rs.getString("title"),
                        rs.getInt("totalQuantitySold")
                    ));
                }
            }
        }
        return list;
    }

    private List<ReportModel.StaffPerformance> getStaffPerformance() throws SQLException {
        String sql = "SELECT s.id AS staffId, s.fullname AS staffName, COUNT(o.order_id) AS ordersHandled " +
                     "FROM users s " +
                     "LEFT JOIN orders o ON s.id = o.staff_id " +
                     "WHERE s.role = 'staff' " +  // assuming you have a role column to identify staff
                     "GROUP BY s.id, s.fullname " +
                     "ORDER BY ordersHandled DESC";

        List<ReportModel.StaffPerformance> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ReportModel.StaffPerformance(
                    rs.getInt("staffId"),
                    rs.getString("staffName"),
                    rs.getInt("ordersHandled")
                ));
            }
        }
        return list;
    }

public List<ReportModel.UserOrderCount> getUserOrderCounts() throws SQLException {
    List<ReportModel.UserOrderCount> userOrderCounts = new ArrayList<>();
    
    String sql = """
        SELECT 
            o.user_id,
            CASE 
                WHEN u.username IS NOT NULL THEN u.username 
                ELSE CONCAT('User ', o.user_id) 
            END as user_name,
            COUNT(o.order_id) as total_orders,
            COALESCE(SUM(o.total_amount), 0) as total_spent
        FROM orders o
        LEFT JOIN users u ON o.user_id = u.id
        GROUP BY o.user_id, u.username
        ORDER BY total_orders DESC, total_spent DESC
        """;
    
    try (PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {
        
        while (rs.next()) {
            ReportModel.UserOrderCount userOrder = new ReportModel.UserOrderCount(
                rs.getInt("user_id"),
                rs.getString("user_name"),
                rs.getInt("total_orders"),
                rs.getDouble("total_spent")
            );
            userOrderCounts.add(userOrder);
        }
    }
    
    return userOrderCounts;
}
}

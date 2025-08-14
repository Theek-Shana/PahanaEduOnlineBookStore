package com.bookshop.dao;

import com.bookshop.model.Item;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {
    private Connection conn;

    public ItemDAO(Connection conn) {
        this.conn = conn;
    }

    public ItemDAO() {
        // no-arg constructor if needed elsewhere, but methods must open connection manually
    }

    public boolean addItem(Item item) {
        String sql = "INSERT INTO item (title, author, price, stock_quantity, description, category, image, added_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, item.getTitle());
            stmt.setString(2, item.getAuthor());
            stmt.setDouble(3, item.getPrice());
            stmt.setInt(4, item.getStockQuantity());
            stmt.setString(5, item.getDescription());
            stmt.setString(6, item.getCategory());
            stmt.setString(7, item.getImage());
            stmt.setString(8, item.getAddedBy());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Item> getAllItems() {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT * FROM item";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setTitle(rs.getString("title"));
                item.setAuthor(rs.getString("author"));
                item.setPrice(rs.getDouble("price"));
                item.setStockQuantity(rs.getInt("stock_quantity"));
                item.setDescription(rs.getString("description"));
                item.setCategory(rs.getString("category"));
                item.setImage(rs.getString("image"));
                item.setAddedBy(rs.getString("added_by"));
                items.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    public Item getItemById(int itemId) {
        String sql = "SELECT * FROM item WHERE item_id=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, itemId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setTitle(rs.getString("title"));
                item.setAuthor(rs.getString("author"));
                item.setPrice(rs.getDouble("price"));
                item.setStockQuantity(rs.getInt("stock_quantity"));
                item.setDescription(rs.getString("description"));
                item.setCategory(rs.getString("category"));
                item.setImage(rs.getString("image"));
                item.setAddedBy(rs.getString("added_by"));
                return item;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateItem(Item item) {
        String sql = "UPDATE item SET title=?, author=?, price=?, stock_quantity=?, description=?, category=?, image=? WHERE item_id=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, item.getTitle());
            stmt.setString(2, item.getAuthor());
            stmt.setDouble(3, item.getPrice());
            stmt.setInt(4, item.getStockQuantity());
            stmt.setString(5, item.getDescription());
            stmt.setString(6, item.getCategory());
            stmt.setString(7, item.getImage());
            stmt.setInt(8, item.getItemId());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteItem(int itemId) {
        String deleteOrderItemsSql = "DELETE FROM order_items WHERE item_id=?";
        String deleteItemSql = "DELETE FROM item WHERE item_id=?";
        try {
            conn.setAutoCommit(false); // Start transaction

            try (PreparedStatement stmt1 = conn.prepareStatement(deleteOrderItemsSql)) {
                stmt1.setInt(1, itemId);
                stmt1.executeUpdate();
            }

            try (PreparedStatement stmt2 = conn.prepareStatement(deleteItemSql)) {
                stmt2.setInt(1, itemId);
                int rowsDeleted = stmt2.executeUpdate();
                conn.commit(); // Commit transaction
                return rowsDeleted > 0;
            }

        } catch (Exception e) {
            try {
                conn.rollback(); // Rollback in case of error
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                conn.setAutoCommit(true); // Restore auto-commit
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    
    
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM item ORDER BY category ASC";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String category = rs.getString("category");
                if (category != null && !category.trim().isEmpty()) {
                    categories.add(category);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    
    // Check if item exists
    public boolean isItemExist(String title, String category) {
        String sql = "SELECT COUNT(*) FROM item WHERE title = ? AND category = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, category);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
}

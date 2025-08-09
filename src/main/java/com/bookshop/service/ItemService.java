package com.bookshop.service;

import com.bookshop.dao.DBConnection;
import com.bookshop.dao.ItemDAO;
import com.bookshop.model.Item;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ItemService {

    private ItemDAO itemDAO;

    // No-arg constructor - opens connection internally
    public ItemService() {
        try {
            Connection conn = com.bookshop.dao.DBConnection.getInstance().getConnection();
            this.itemDAO = new ItemDAO(conn);
        } catch (SQLException e) {
            throw new RuntimeException("Unable to get DB connection", e);
        }
    }

    // Constructor with connection (optional)
    public ItemService(Connection conn) {
        this.itemDAO = new ItemDAO(conn);
    }

    public boolean addItem(Item item) {
        return itemDAO.addItem(item);
    }

    public List<Item> getAllItems() {
        return itemDAO.getAllItems();
    }

    public Item getItemById(int itemId) {
        return itemDAO.getItemById(itemId);
    }

    public boolean updateItem(Item item) {
        return itemDAO.updateItem(item);
    }

    public boolean deleteItem(int itemId) {
        return itemDAO.deleteItem(itemId);
    }
    
    
    
    public List<String> getAllCategories() {
        try (Connection conn = DBConnection.getInstance().getConnection()) {
            ItemDAO dao = new ItemDAO(conn);
            return dao.getAllCategories();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

}

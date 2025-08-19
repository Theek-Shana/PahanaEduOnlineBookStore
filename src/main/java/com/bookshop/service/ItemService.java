package com.bookshop.service;

import com.bookshop.dao.ItemDAO;
import com.bookshop.model.Item;
import java.sql.SQLException;
import java.util.List;

public class ItemService {

    private static ItemService instance; 
    private final ItemDAO itemDAO;

   
    private ItemService() {
        try {
            this.itemDAO = new ItemDAO();
        } catch (SQLException e) {
            throw new RuntimeException("Unable to initialize ItemDAO", e);
        }
    }

    
    public static synchronized ItemService getInstance() {
        if (instance == null) {
            instance = new ItemService();
        }
        return instance;
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
        return itemDAO.getAllCategories();
    }

    public boolean isItemExist(String title, String category) {
        return itemDAO.isItemExist(title, category);
    }
    
    
    
    
    
    
    // New constructor for testing
    public ItemService(ItemDAO mockDAO) {
        this.itemDAO = mockDAO;
    }
    
}

package com.bookshop.service;

import com.bookshop.dao.ItemDAO;
import com.bookshop.model.Item;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ItemService {

    private final ItemDAO itemDAO;

    // No-arg constructor: ItemDAO handles DBConnection internally
    public ItemService() {
        try {
            this.itemDAO = new ItemDAO();
        } catch (SQLException e) {
            throw new RuntimeException("Unable to initialize ItemDAO", e);
        }
    }

    // Constructor with DAO injection (for testing or flexibility)
    public ItemService(ItemDAO itemDAO) {
        this.itemDAO = itemDAO;
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
}

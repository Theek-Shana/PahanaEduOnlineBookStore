package com.bookshop.daotest;

import com.bookshop.dao.ItemDAO;
import com.bookshop.model.Item;
import org.junit.jupiter.api.*;

import java.sql.Connection;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class ItemDAOTest {

    private static ItemDAO itemDAO;
    private static Connection conn; // for rollback
    private static Item testItem;

    @BeforeAll
    public static void setup() throws SQLException {
        itemDAO = new ItemDAO();

        // safely access private connection via reflection
        try {
            var field = itemDAO.getClass().getDeclaredField("conn");
            field.setAccessible(true);
            conn = (Connection) field.get(itemDAO);
        } catch (NoSuchFieldException | IllegalAccessException e) {
            e.printStackTrace();
            fail("Failed to access connection from ItemDAO");
        }

        // create a test item (unique title to avoid conflicts)
        testItem = new Item();
        testItem.setTitle("JUnit Test Book");
        testItem.setAuthor("Test Author");
        testItem.setPrice(123.45);
        testItem.setStockQuantity(10);
        testItem.setDescription("Test Description");
        testItem.setCategory("Test Category");
        testItem.setImage("test_image.jpg");
        testItem.setAddedBy("JUnit");
    }

    @Test
    @Order(1)
    public void testAddItemSuccess() throws SQLException {
        conn.setAutoCommit(false); // start transaction

        boolean added = itemDAO.addItem(testItem);
        assertTrue(added, "Item should be added successfully");

        conn.rollback(); // rollback to not affect real data
        conn.setAutoCommit(true);
    }

    @Test
    @Order(2)
    public void testAddItemFailDuplicate() throws SQLException {
        conn.setAutoCommit(false);

        try {
            
            boolean firstInsert = itemDAO.addItem(testItem);
            assertTrue(firstInsert, "First insert should succeed");

      
            assertThrows(SQLException.class, () -> {
                itemDAO.addItem(testItem);
            }, "Duplicate insert should throw SQLException");

        } finally {
            conn.rollback(); 
            conn.setAutoCommit(true);
        }
    }

    


    @Test
    @Order(3)
    public void testGetAllCategories() {
        var categories = itemDAO.getAllCategories();
        assertNotNull(categories, "Categories list should not be null");
        assertTrue(categories.size() > 0, "There should be at least one category");
    }

    @Test  
    @Order(4)
    public void testIsItemExist() throws SQLException {
        conn.setAutoCommit(false);

        itemDAO.addItem(testItem);

        boolean exists = itemDAO.isItemExist(testItem.getTitle(), testItem.getCategory());
        assertTrue(exists, "Test item should exist in DB");

        boolean notExist = itemDAO.isItemExist("NonExistentTitle", "NonExistentCategory");
        assertFalse(notExist, "Non-existent item should return false");

        conn.rollback();
        conn.setAutoCommit(true);
    }

    @Test
    @Order(5)
    public void testGetItemByIdFail() {
        Item item = itemDAO.getItemById(-9999); // unlikely ID
        assertNull(item, "Item with invalid ID should return null");
    }
}

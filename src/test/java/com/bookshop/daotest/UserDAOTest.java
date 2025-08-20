package com.bookshop.daotest;

import com.bookshop.dao.DBConnection;
import com.bookshop.dao.UserDAO;
import com.bookshop.model.User;
import org.junit.jupiter.api.*;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class UserDAOTest {

    private static UserDAO userDAO;
    private static Connection conn;

    private static final String TEST_PASSWORD = "Test1234";
    private static final String TEST_NAME = "JUnit User";
    private static String TEST_EMAIL_FOR_DUPLICATE; // for duplicate test later

    @BeforeAll
    public static void setup() throws SQLException {
        userDAO = new UserDAO();
        conn = DBConnection.getInstance().getConnection();
        conn.setAutoCommit(false); // Start transaction for safe rollback
    }

    @BeforeEach
    void cleanTable() throws SQLException {
        // Clear users table before each test to avoid duplicates
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("DELETE FROM users");
        }
    }

    @AfterAll
    public static void cleanup() throws SQLException {
        conn.rollback(); // rollback everything so real DB is untouched
        conn.setAutoCommit(true);
    }

    @Test
    @Order(1)
    public void testRegisterUserSuccess() throws SQLException {
        // Generate a unique email for this test run
        String uniqueEmail = "testuser+" + System.currentTimeMillis() + "@example.com";

        User testUser = new User();
        testUser.setFullname(TEST_NAME);
        testUser.setEmail(uniqueEmail);       // unique email
        testUser.setMobile("0711234567");
        testUser.setPassword(TEST_PASSWORD);
        testUser.setRole("customer");
        testUser.setAccountNumber("ACC12345");

        boolean result = userDAO.registerUser(testUser);
        assertTrue(result, "User should register successfully");

        // Save this email for potential duplicate test later
        TEST_EMAIL_FOR_DUPLICATE = uniqueEmail;
    }

    @Test
    @Order(2)
    public void testRegisterDuplicateUserFails() throws SQLException {
        // Use the previously registered email
        String duplicateEmail = TEST_EMAIL_FOR_DUPLICATE;

        User duplicateUser = new User();
        duplicateUser.setFullname(TEST_NAME);
        duplicateUser.setEmail(duplicateEmail);
        duplicateUser.setMobile("0711234567");
        duplicateUser.setPassword(TEST_PASSWORD);
        duplicateUser.setRole("customer");
        duplicateUser.setAccountNumber("ACC12345");

        boolean result = userDAO.registerUser(duplicateUser);
        assertFalse(result, "Duplicate email registration should fail");
    }
}

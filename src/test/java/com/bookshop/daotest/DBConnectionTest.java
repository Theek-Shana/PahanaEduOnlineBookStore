package com.bookshop.daotest;

import com.bookshop.dao.DBConnection;
import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;

public class DBConnectionTest {

    @Test
    void testSuccessfulConnection() {
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            assertNotNull(conn, "Connection should not be null");
            assertFalse(conn.isClosed(), "Connection should be open");
            System.out.println("✅ Successful connection test passed!");
        } catch (SQLException e) {
            fail("❌ Connection failed, but it should have succeeded: " + e.getMessage());
        }
    }
}

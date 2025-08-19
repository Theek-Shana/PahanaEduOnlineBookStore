package com.bookshop.daotest;

import org.junit.jupiter.api.Test;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import static org.junit.jupiter.api.Assertions.*;

public class DBConnectionTest {

	@Test
	void testSuccessfulConnection() {
	    String url = System.getenv("DB_URL");
	    String username = System.getenv("DB_USERNAME");
	    String password = System.getenv("DB_PASSWORD");

	    if (url == null) url = "jdbc:mysql://127.0.0.1:3306/bookstore_test?useSSL=false&allowPublicKeyRetrieval=true";
	    if (username == null) username = "root";
	    if (password == null) password = "root";

	    try (Connection conn = DriverManager.getConnection(url, username, password)) {
	        assertNotNull(conn, "Connection should not be null");
	        assertFalse(conn.isClosed(), "Connection should be open");
	        System.out.println("✅ Successful connection test passed!");
	    } catch (SQLException e) {  
	        fail("❌ Connection failed: " + e.getMessage());
	    }
	}
}

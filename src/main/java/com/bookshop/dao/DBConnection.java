package com.bookshop.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static DBConnection instance;
    private String url;
    private String username;
    private String password;

    private DBConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver not found", e);
        }

        // Read credentials from environment variables (GitHub Actions safe)
        url = System.getenv().getOrDefault("DB_URL", "jdbc:mysql://localhost:3306/pahanaonline");
        username = System.getenv().getOrDefault("DB_USERNAME", "root");
        password = System.getenv().getOrDefault("DB_PASSWORD", "Theek@2004");
    }

    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }

    public static synchronized DBConnection getInstance() throws SQLException {
        if (instance == null) {
            instance = new DBConnection();
        }
        return instance;
    }
}

package com.bookshop.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static DBConnection instance;
    private Connection connection;
    private String url = "jdbc:mysql://localhost:3306/pahanaonline";
    private String username = "root";
    private String password = "Theek@2004"; 

    private DBConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            this.connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException ex) {
            System.out.println("DB Connection creation failed: " + ex.getMessage());
        }
    }

    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }

    public static DBConnection getInstance() throws SQLException {
        if (instance == null || instance.getConnection().isClosed()) {
            instance = new DBConnection();
        }
        return instance;
    }
}

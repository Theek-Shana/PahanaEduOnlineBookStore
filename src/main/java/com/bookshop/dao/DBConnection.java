package com.bookshop.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;



public class DBConnection {
    private static DBConnection instance;
    private String url = "jdbc:mysql://localhost:3306/pahanaonline";
    private String username = "root";
    private String password = "Theek@2004";

    private DBConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver not found", e);
        }
    }

    public Connection getConnection() throws SQLException {
        // return a new connection each time
        return DriverManager.getConnection(url, username, password);
    }

    public static synchronized DBConnection getInstance() throws SQLException {
        if (instance == null) {
            instance = new DBConnection();
        }
        return instance;
    }
}


 
package com.bookshop.service;

import com.bookshop.dao.UserDAO;
import com.bookshop.model.User;

import java.sql.SQLException;
import java.util.List;

public class UserService {
    private static UserService instance; 
    private UserDAO userDAO;

    
    private UserService() {
        this.userDAO = new UserDAO();
    }

    
    public static synchronized UserService getInstance() {
        if (instance == null) {
            instance = new UserService();
        }
        return instance;
    }

   

    public User login(String email, String password) throws SQLException {
        return userDAO.login(email, password);
    }

    public boolean registerUser(User user) throws SQLException {
        if (user.getAccountNumber() == null || user.getAccountNumber().trim().isEmpty()) {
            String accountNumber = "ACC" + System.currentTimeMillis();
            user.setAccountNumber(accountNumber);
        }
        return userDAO.registerUser(user);
    }

    public List<User> getUsersByRole(String role) throws SQLException {
        return userDAO.getUsersByRole(role);
    }

    public List<User> searchUsersByRoleAndNameOrEmail(String role, String search) throws SQLException {
        return userDAO.searchUsersByRoleAndNameOrEmail(role, search);
    }

    public void deleteUserById(int id) throws SQLException {
        userDAO.deleteUserById(id);
    }

    public void updateUserByAdmin(User user) throws SQLException {
        userDAO.updateUserByAdmin(user);
    }

    public User getUserById(int id) throws SQLException {
        return userDAO.getUserById(id);
    }

    public List<User> getAllCustomers() throws SQLException {
        return userDAO.getAllCustomers();
    }

    public User getUserByEmail(String email) throws SQLException {
        return userDAO.getUserByEmail(email);
    }

    public void updatePasswordByEmail(String email, String password) throws SQLException {
        userDAO.updatePasswordByEmail(email, password);
    }
}

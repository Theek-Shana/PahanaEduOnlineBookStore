package com.bookshop.dao;

import com.bookshop.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO {

    private Connection getConnection() throws SQLException {
        return DBConnection.getInstance().getConnection();
    }
    private Connection conn;

    public UserDAO (){
    }

    public User login(String email, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password");
                    if (BCrypt.checkpw(password, storedHash)) {
                        User user = new User();
                        user.setId(rs.getInt("id"));
                        user.setAccountNumber(rs.getString("account_number"));
                        user.setFullname(rs.getString("fullname"));
                        user.setEmail(rs.getString("email"));
                        user.setMobile(rs.getString("mobile"));
                        user.setUsername(rs.getString("username"));
                        user.setPassword(storedHash);
                        user.setAddress(rs.getString("address"));
                        user.setTelephone(rs.getString("telephone"));
                        user.setProfilePhoto(rs.getString("profile_photo"));
                        user.setCreatedAt(rs.getTimestamp("created_at"));
                        user.setRole(rs.getString("role"));
                        return user;
                    }
                }
            }
        }
        return null;
    }


    public boolean registerUser(User user) throws SQLException {
        String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
        String sql = "INSERT INTO users (fullname, email, mobile, password, role, account_number) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getFullname());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getMobile());
            ps.setString(4, hashedPassword); // store hashed password
            ps.setString(5, user.getRole());
            ps.setString(6, user.getAccountNumber());
            return ps.executeUpdate() > 0;
        }
    }

    public List<User> getUsersByRole(String role) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, account_number, fullname, email, mobile, username, password, address, telephone, profile_photo, created_at, role FROM users WHERE role = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setAccountNumber(rs.getString("account_number"));
                    user.setFullname(rs.getString("fullname"));
                    user.setEmail(rs.getString("email"));
                    user.setMobile(rs.getString("mobile"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setAddress(rs.getString("address"));
                    user.setTelephone(rs.getString("telephone"));
                    user.setProfilePhoto(rs.getString("profile_photo"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setRole(rs.getString("role"));
                    users.add(user);
                }
            }
        }
        return users;
    }



    public List<User> searchUsersByRoleAndNameOrEmail(String role, String search) throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? AND (fullname LIKE ? OR email LIKE ?)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, role);
            String pattern = "%" + search + "%";
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setAccountNumber(rs.getString("account_number"));
                    user.setFullname(rs.getString("fullname"));
                    user.setEmail(rs.getString("email"));
                    user.setMobile(rs.getString("mobile"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setAddress(rs.getString("address"));
                    user.setTelephone(rs.getString("telephone"));
                    user.setProfilePhoto(rs.getString("profile_photo"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setRole(rs.getString("role"));
                    users.add(user);
                }
            }
        }
        return users;
    }

    public void updateUserByAdmin(User user) throws SQLException {
        String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
        String sql = "UPDATE users SET fullname = ?, email = ?, mobile = ?, password = ? WHERE id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getFullname());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getMobile());
            ps.setString(4, hashedPassword);
            ps.setInt(5, user.getId());
            ps.executeUpdate();
        }
    }


    public void deleteUserById(int id) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
    
    public User getUserById(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setAccountNumber(rs.getString("account_number"));
                    user.setFullname(rs.getString("fullname"));
                    user.setEmail(rs.getString("email"));
                    user.setMobile(rs.getString("mobile"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setAddress(rs.getString("address"));
                    user.setTelephone(rs.getString("telephone"));
                    user.setProfilePhoto(rs.getString("profile_photo"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setRole(rs.getString("role"));
                    return user;
                }
            }
        }
        return null;
    }
    public String getFullnameById(int userId) throws SQLException {
        String sql = "SELECT fullname FROM users WHERE id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("fullname");
                }
            }
        }
        return null;
    }
    public List<User> getAllCustomers() throws SQLException {
        return getUsersByRole("customer");
    }

    
    
    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setEmail(rs.getString("email"));
                    return user;
                }
            }
        }
        return null;
    }


    public void updatePasswordByEmail(String email, String newPassword) throws SQLException {
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            ps.executeUpdate();
        }
    }

}
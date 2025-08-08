package com.bookshop.dao;

import com.bookshop.model.ProfileManage;
import java.sql.*;

public class ProfileDAO {
    private Connection connection;

    public ProfileDAO() throws SQLException {
        connection = DBConnection.getInstance().getConnection();
    }

   

        public ProfileManage getProfile(int customerId) throws SQLException {
            String sql = "SELECT * FROM users WHERE id=?";
            try (Connection connection = DBConnection.getInstance().getConnection();
                 PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setInt(1, customerId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        ProfileManage profile = new ProfileManage();
                        profile.setId(rs.getInt("id"));
                        profile.setFullname(rs.getString("fullname"));
                        profile.setEmail(rs.getString("email"));
                        profile.setUsername(rs.getString("username"));
                        profile.setPassword(rs.getString("password"));
                        profile.setAddress(rs.getString("address"));
                        profile.setTelephone(rs.getString("telephone"));
                        profile.setProfilePhoto(rs.getString("profile_photo"));
                        profile.setAccountNumber(rs.getString("account_number"));
                        profile.setCreatedAt(rs.getString("created_at"));
                        return profile;
                    }
                }
            }
            return null;
        }

        // similarly for updateProfile()



        public boolean updateProfile(ProfileManage profile) throws SQLException {
            String sql = "UPDATE users SET fullname=?, username=?, password=?, address=?, telephone=?, profile_photo=? WHERE id=?";
            try (Connection connection = DBConnection.getInstance().getConnection();
                 PreparedStatement stmt = connection.prepareStatement(sql)) {

                stmt.setString(1, profile.getFullname());
                stmt.setString(2, profile.getUsername());
                stmt.setString(3, profile.getPassword());
                stmt.setString(4, profile.getAddress());
                stmt.setString(5, profile.getTelephone());
                stmt.setString(6, profile.getProfilePhoto());
                stmt.setInt(7, profile.getId());

                return stmt.executeUpdate() > 0;
            }
        }
}

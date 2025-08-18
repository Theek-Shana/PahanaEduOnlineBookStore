package com.bookshop.service;

import com.bookshop.dao.ProfileDAO;
import com.bookshop.model.ProfileManage;
import java.sql.SQLException;

public class ProfileService {
    private static ProfileService instance;
    private ProfileDAO profileDAO;

    // Private constructor (Singleton rule)
    private ProfileService() throws SQLException {
        profileDAO = new ProfileDAO();
    }

    // Global access point
    public static ProfileService getInstance() throws SQLException {
        if (instance == null) {
            instance = new ProfileService();
        }
        return instance;
    }

    public ProfileManage getProfile(int userId) throws SQLException {
        return profileDAO.getProfile(userId);
    }

    public boolean updateProfile(ProfileManage profile) throws SQLException {
        return profileDAO.updateProfile(profile);
    }
}

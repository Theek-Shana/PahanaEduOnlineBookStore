package com.bookshop.service;

import com.bookshop.dao.ProfileDAO;
import com.bookshop.model.ProfileManage;
import java.sql.SQLException;

public class ProfileService {
    private static ProfileService instance;
    private ProfileDAO profileDAO;

    // Production constructor (no arguments) uses real DAO
    private ProfileService() throws SQLException {
        this.profileDAO = new ProfileDAO();
    }

    // Test constructor allows injecting a mock DAO
    public ProfileService(ProfileDAO dao) {
        this.profileDAO = dao;
    }

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

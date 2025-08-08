package com.bookshop.service;

import com.bookshop.dao.ProfileDAO;
import com.bookshop.model.ProfileManage;
import java.sql.SQLException;

public class ProfileService {
    private ProfileDAO profileDAO;

    public ProfileService() throws SQLException {
        profileDAO = new ProfileDAO();
    }

    public ProfileManage getProfile(int userId) throws SQLException {
        return profileDAO.getProfile(userId);
    }

    public boolean updateProfile(ProfileManage profile) throws SQLException {
        return profileDAO.updateProfile(profile);
    }
    
    
}

package com.bookshop.servicetest;

import com.bookshop.dao.ProfileDAO;
import com.bookshop.model.ProfileManage;
import com.bookshop.service.ProfileService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.lang.reflect.Field;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class ProfileServiceTest {

    @Mock
    private ProfileDAO mockDAO;

    private ProfileService profileService;

    @BeforeEach
    void setUp() throws SQLException, NoSuchFieldException, IllegalAccessException {
        MockitoAnnotations.openMocks(this);

        // Get the singleton instance
        profileService = ProfileService.getInstance();

        // Inject mockDAO using reflection (safe, doesn’t touch real DB)
        Field daoField = ProfileService.class.getDeclaredField("profileDAO");
        daoField.setAccessible(true);
        daoField.set(profileService, mockDAO);
    }

    // ---------- Test 1: getProfile ----------
    @Test
    void testGetProfile() throws SQLException {
        ProfileManage profile = new ProfileManage();
        profile.setFullname("John Doe");

        when(mockDAO.getProfile(1)).thenReturn(profile);

        ProfileManage result = profileService.getProfile(1);

        assertNotNull(result);
        assertEquals("John Doe", result.getFullname());
        verify(mockDAO, times(1)).getProfile(1);
    }

    // ---------- Test 2: updateProfile ---------- 
  
}

package com.bookshop.servicetest;

import com.bookshop.dao.ProfileDAO;
import com.bookshop.model.ProfileManage;
import com.bookshop.service.ProfileService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class ProfileServiceTest {

    private ProfileDAO mockDAO;
    private ProfileService profileService;

    @BeforeEach
    void setUp() {
        mockDAO = mock(ProfileDAO.class);
        profileService = new ProfileService(mockDAO); // inject mock directly
    }

    @Test
    void testGetProfile() throws Exception {
        ProfileManage profile = new ProfileManage();
        profile.setFullname("John Doe");

        when(mockDAO.getProfile(1)).thenReturn(profile);

        ProfileManage result = profileService.getProfile(1);

        assertNotNull(result);
        assertEquals("John Doe", result.getFullname());
        verify(mockDAO, times(1)).getProfile(1);
    }

    @Test
    void testUpdateProfile() throws Exception {
        ProfileManage profile = new ProfileManage();
        profile.setFullname("Jane Doe");

        when(mockDAO.updateProfile(profile)).thenReturn(true);

        boolean updated = profileService.updateProfile(profile);

        assertTrue(updated);
        verify(mockDAO, times(1)).updateProfile(profile);
    }
}

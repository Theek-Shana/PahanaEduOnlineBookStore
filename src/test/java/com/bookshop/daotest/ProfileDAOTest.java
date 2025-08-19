package com.bookshop.daotest;

import com.bookshop.dao.ProfileDAO;
import com.bookshop.model.ProfileManage;
import org.junit.jupiter.api.*;

import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class ProfileDAOTest {

    private static ProfileDAO profileDAO;
    private static ProfileManage testProfile;
    private static String originalFullname;
    private static String originalPassword;

    @BeforeAll
    public static void setup() throws SQLException {
        profileDAO = new ProfileDAO();

        // Use your specific test ID
        testProfile = profileDAO.getProfile(40); 
        assertNotNull(testProfile, "Test profile with ID 40 must exist");

        // Save original data to restore later
        originalFullname = testProfile.getFullname();
        originalPassword = testProfile.getPassword();
    }

    @Test
    @Order(1)
    public void testGetProfileSuccess() throws SQLException {
        ProfileManage profile = profileDAO.getProfile(testProfile.getId());
        assertNotNull(profile, "Profile should be retrieved successfully");
        assertEquals(testProfile.getId(), profile.getId());
    }

    @Test
    @Order(2)
    public void testGetProfileFailInvalidId() throws SQLException {
        ProfileManage profile = profileDAO.getProfile(9999); // non-existent ID
        assertNull(profile, "Profile should be null for invalid ID");
    }

    @Test
    @Order(3)
    public void testUpdateProfileSuccess() throws SQLException {
        testProfile.setFullname("Temporary Name");
        testProfile.setPassword("TempPass123");

        boolean updated = profileDAO.updateProfile(testProfile);
        assertTrue(updated, "Profile should be updated successfully");

        // verify update
        ProfileManage profile = profileDAO.getProfile(testProfile.getId());
        assertEquals("Temporary Name", profile.getFullname());
    }



    


    @AfterAll
    public static void cleanup() throws SQLException {
        // Restore original data for ID 40
        testProfile.setFullname(originalFullname);
        testProfile.setPassword(originalPassword);
        profileDAO.updateProfile(testProfile);
    }
}

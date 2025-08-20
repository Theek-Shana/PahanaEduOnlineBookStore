import com.bookshop.controller.ForgotPasswordController;
import com.bookshop.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import static org.mockito.Mockito.*;

class ForgotPasswordControllerTest {
    private ForgotPasswordController controller;
    private UserService userService;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;

    @BeforeEach
    void setUp() throws Exception {
        controller = new ForgotPasswordController();
        userService = mock(UserService.class);
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        session = mock(HttpSession.class);

        var field = ForgotPasswordController.class.getDeclaredField("userService");
        field.setAccessible(true);
        field.set(controller, userService);
    }

    @Test
    void testSendOtpEmailNotFoundFails() throws Exception {
        when(request.getParameter("action")).thenReturn("sendOtp");
        when(request.getParameter("email")).thenReturn("notfound@test.com");
        when(userService.getUserByEmail("notfound@test.com")).thenReturn(null);

        controller.doPost(request, response);

        verify(response).sendRedirect(contains("forgot-password.jsp?error=EmailNotFound"));
    }

    @Test
    void testResetPasswordSuccess() throws Exception {
        when(request.getParameter("action")).thenReturn("reset");
        when(request.getParameter("otp")).thenReturn("123456");
        when(request.getParameter("password")).thenReturn("newpass");
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("otp")).thenReturn("123456");
        when(session.getAttribute("email")).thenReturn("user@test.com");

        doNothing().when(userService).updatePasswordByEmail("user@test.com", "newpass");

        controller.doPost(request, response);

        verify(userService).updatePasswordByEmail("user@test.com", "newpass");
        verify(session).removeAttribute("otp");
        verify(session).removeAttribute("email");
        verify(response).sendRedirect(contains("login.jsp?msg=PasswordReset"));
    }

    @Test
    void testResetPasswordInvalidOtp() throws Exception {
        when(request.getParameter("action")).thenReturn("reset");
        when(request.getParameter("otp")).thenReturn("000000");
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("otp")).thenReturn("123456");

        controller.doPost(request, response);

        verify(response).sendRedirect(contains("enter-otp.jsp?error=InvalidOTP"));
    }

    @Test
    void testResetPasswordSessionExpired() throws Exception {
        when(request.getParameter("action")).thenReturn("reset");
        when(request.getSession(false)).thenReturn(null);

        controller.doPost(request, response);

        verify(response).sendRedirect(contains("forgot-password.jsp?error=SessionExpired"));
    }
}
 
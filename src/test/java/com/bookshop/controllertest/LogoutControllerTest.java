package com.bookshop.controllertest;

import com.bookshop.controller.LogoutController;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

import static org.mockito.Mockito.*;

class LogoutControllerTest {

    private LogoutController controller;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;

    @BeforeEach
    void setUp() {
        controller = new LogoutController();
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        session = mock(HttpSession.class);
    }

    // ---------- Session exists ----------
    @Test
    void testLogoutWithSession() throws IOException, ServletException {
        when(request.getSession(false)).thenReturn(session);
        when(request.getContextPath()).thenReturn("/bookshop");

        controller.doGet(request, response);

        verify(session).invalidate();
        verify(response).sendRedirect("/bookshop/view/login.jsp");
    }
 
  
}

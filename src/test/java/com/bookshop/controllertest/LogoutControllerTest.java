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

    // ---------- Test 1: Session exists ----------
    @Test
    void testLogoutWithSession() throws IOException, ServletException {
        when(request.getSession(false)).thenReturn(session);
        when(request.getContextPath()).thenReturn("/bookshop");

        controller.doGet(request, response);

        verify(session, times(1)).invalidate();
        verify(response, times(1)).sendRedirect("/bookshop/view/login.jsp");
    }

    // ---------- Test 2: No session exists ----------
    @Test
    void testLogoutWithoutSession() throws IOException, ServletException {
        when(request.getSession(false)).thenReturn(null);
        when(request.getContextPath()).thenReturn("/bookshop");

        controller.doGet(request, response);

        // No session to invalidate, but should still redirect
        verify(response, times(1)).sendRedirect("/bookshop/view/login.jsp");
    }
}

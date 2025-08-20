package com.bookshop.controllertest;

import com.bookshop.controller.ItemController;
import com.bookshop.model.Item;
import com.bookshop.service.ItemService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.util.ArrayList;
import java.util.List;

import static org.mockito.Mockito.*;

class ItemControllerTest {

    private ItemController controller;
    private ItemService itemService;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private RequestDispatcher dispatcher;
    private Part imagePart;

    @BeforeEach
    void setUp() throws Exception {
        controller = new ItemController();

        // Mocks
        itemService = mock(ItemService.class);
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        session = mock(HttpSession.class);
        dispatcher = mock(RequestDispatcher.class);
        imagePart = mock(Part.class);

        // Inject mocked service into controller
        var field = ItemController.class.getDeclaredField("itemService");
        field.setAccessible(true);
        field.set(controller, itemService);
    }

    // ---------- Test: List Items ----------
    @Test
    void testListItems() throws Exception {
        when(request.getParameter("action")).thenReturn("list");
        when(request.getRequestDispatcher("/view/listItems.jsp")).thenReturn(dispatcher);

        List<Item> dummyItems = new ArrayList<>();
        dummyItems.add(new Item());
        when(itemService.getAllItems()).thenReturn(dummyItems);

        List<String> dummyCategories = new ArrayList<>();
        dummyCategories.add("Test Category");
        when(itemService.getAllCategories()).thenReturn(dummyCategories);

        controller.doGet(request, response);

        verify(request).setAttribute("items", dummyItems);
        verify(request).setAttribute("categories", dummyCategories);
        verify(dispatcher).forward(request, response);
    }

    // ---------- Test: Show Add Form ----------
    @Test
    void testShowAddForm() throws Exception {
        when(request.getParameter("action")).thenReturn("new");
        when(request.getRequestDispatcher("/view/addItem.jsp")).thenReturn(dispatcher);

        controller.doGet(request, response);

        verify(dispatcher).forward(request, response);
    }

    // ---------- Test: Delete Item ----------
    @Test
    void testDeleteItem() throws Exception {
        when(request.getParameter("action")).thenReturn("delete");
        when(request.getParameter("id")).thenReturn("1");
        when(itemService.deleteItem(1)).thenReturn(true);

        controller.doGet(request, response);

        verify(itemService, times(1)).deleteItem(1);
        verify(response).sendRedirect(anyString());
    }

    // ---------- Test: Add Duplicate Item ----------
    @Test
    void testAddDuplicateItem() throws Exception {
        when(request.getParameter("action")).thenReturn("add");
        when(request.getParameter("title")).thenReturn("Test Book");
        when(request.getParameter("category")).thenReturn("Test Category");
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("user")).thenReturn(null);
        when(request.getPart("image")).thenReturn(imagePart);
        when(imagePart.getSize()).thenReturn(1L);
        when(imagePart.getSubmittedFileName()).thenReturn("fake.jpg");
        doNothing().when(imagePart).write(anyString());
        when(itemService.isItemExist("Test Book", "Test Category")).thenReturn(true);
        when(request.getRequestDispatcher("/view/addItem.jsp")).thenReturn(dispatcher);

        controller.doPost(request, response);

        verify(itemService, never()).addItem(any(Item.class));
        verify(request).setAttribute(eq("error"), eq("All required fields must be filled!"));

        verify(dispatcher).forward(request, response);
    }

    // ---------- Test: Update Item ---------- 
    @Test
    void testUpdateItem() throws Exception {
        when(request.getParameter("action")).thenReturn("update");
        when(request.getParameter("itemId")).thenReturn("1");
        when(request.getParameter("title")).thenReturn("Updated Book");
        when(request.getParameter("author")).thenReturn("Author");
        when(request.getParameter("price")).thenReturn("20");
        when(request.getParameter("stock_quantity")).thenReturn("5");
        when(request.getParameter("description")).thenReturn("Desc");
        when(request.getParameter("category")).thenReturn("Test Cat");
        when(request.getParameter("existingImage")).thenReturn("old.jpg");
        when(request.getRequestDispatcher("/view/editItem.jsp")).thenReturn(dispatcher);
        when(itemService.updateItem(any(Item.class))).thenReturn(true);

        controller.doPost(request, response);

        verify(itemService).updateItem(any(Item.class));
        verify(response).sendRedirect(anyString());
    }
} 
 
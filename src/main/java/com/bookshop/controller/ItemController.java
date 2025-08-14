package com.bookshop.controller;

import com.bookshop.model.Item;
import com.bookshop.service.ItemService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ItemController extends HttpServlet {

    private ItemService itemService;

    @Override
    public void init() {
        itemService = new ItemService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteItem(request, response);
                break;
            case "list":
            default:
                listItems(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addItem(request, response);
        } else if ("update".equals(action)) {
            updateItem(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/item?action=list");
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/addItem.jsp");
        dispatcher.forward(request, response);
    }

    private void listItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Item> items = itemService.getAllItems();
        request.setAttribute("items", items);
        List<String> categories = itemService.getAllCategories();
        request.setAttribute("categories", categories);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/listItems.jsp");
        dispatcher.forward(request, response);
    }

    private void addItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String addedBy = getAddedByFromSession(session);

        try {
            String title = request.getParameter("title").trim();
            String author = request.getParameter("author").trim();
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock_quantity"));
            String description = request.getParameter("description").trim();
            String category = request.getParameter("category").trim();

            // Check if item already exists
            if (itemService.isItemExist(title, category)) {
                request.setAttribute("error", "Item with this name and category already exists!");
                request.getRequestDispatcher("/view/addItem.jsp").forward(request, response);
                return; // stop further processing
            }

            Part imagePart = request.getPart("image");
            String imagePath = handleFileUpload(imagePart, request);

            Item item = new Item();
            item.setTitle(title);
            item.setAuthor(author);
            item.setPrice(price);
            item.setStockQuantity(stock);
            item.setDescription(description);
            item.setCategory(category);
            item.setImage(imagePath);
            item.setAddedBy(addedBy);

            itemService.addItem(item);

            request.setAttribute("success", "Item successfully added!");
            request.getRequestDispatcher("/view/addItem.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to add item: " + e.getMessage());
            request.getRequestDispatcher("/view/addItem.jsp").forward(request, response);
        }
    }


    private String getAddedByFromSession(HttpSession session) {
        if (session == null) return "unknown";

        String userType = (String) session.getAttribute("userType");
        Object user = session.getAttribute("user");

        // Since you unified users into one User class, you can cast accordingly.
        // Adjust if you keep separate models.
        if ("staff".equals(userType) && user instanceof com.bookshop.model.User) {
            return ((com.bookshop.model.User) user).getEmail();
        } else if ("admin".equals(userType) && user instanceof com.bookshop.model.User) {
            return ((com.bookshop.model.User) user).getEmail();
        } else if ("customer".equals(userType) && user instanceof com.bookshop.model.User) {
            return ((com.bookshop.model.User) user).getEmail();
        } else {
            return "unknown";
        }
    }

    private String handleFileUpload(Part filePart, HttpServletRequest request) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;  // No file uploaded
        }

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        // Sanitize filename or add timestamp if needed to avoid collisions
        String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        return "uploads/" + fileName;  // relative path for use in UI
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/item?action=list");
            return;
        }

        int itemId;
        try {
            itemId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/item?action=list");
            return;
        }

        Item item = itemService.getItemById(itemId);
        if (item == null) {
            response.sendRedirect(request.getContextPath() + "/item?action=list");
            return;
        }

        request.setAttribute("item", item);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/editItem.jsp");
        dispatcher.forward(request, response);
    }

    private void updateItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock_quantity"));
            String description = request.getParameter("description");
            String category = request.getParameter("category");

            Part filePart = request.getPart("image");
            String imagePath;

            if (filePart != null && filePart.getSize() > 0) {
                imagePath = handleFileUpload(filePart, request);
            } else {
                imagePath = request.getParameter("existingImage");
            }

            Item item = new Item();
            item.setItemId(itemId);
            item.setTitle(title);
            item.setAuthor(author);
            item.setPrice(price);
            item.setStockQuantity(stock);
            item.setDescription(description);
            item.setCategory(category);
            item.setImage(imagePath);

            itemService.updateItem(item);
            response.sendRedirect(request.getContextPath() + "/item?action=list");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to update item: " + e.getMessage());
            request.getRequestDispatcher("/view/editItem.jsp").forward(request, response);
        }
    }

    private void deleteItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/item?action=list");
            return;
        }

        try {
            int itemId = Integer.parseInt(idParam);
            itemService.deleteItem(itemId);
        } catch (NumberFormatException e) {
            // optionally log error
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/item?action=list");
    }
}

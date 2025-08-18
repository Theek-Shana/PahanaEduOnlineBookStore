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
        itemService = ItemService.getInstance();
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
            // Get parameters safely with null checks
            String title = getParameterSafely(request, "title");
            String author = getParameterSafely(request, "author");
            String priceStr = getParameterSafely(request, "price");
            String stockStr = getParameterSafely(request, "stock_quantity");
            String description = getParameterSafely(request, "description");
            String category = getParameterSafely(request, "category");

            // Handle new category case
            if ("add_new".equals(category)) {
                String newCategory = getParameterSafely(request, "newCategory");
                if (newCategory.isEmpty()) {
                    request.setAttribute("error", "Please enter a new category name!");
                    request.getRequestDispatcher("/view/addItem.jsp").forward(request, response);
                    return;
                }
                category = newCategory;
            }

            // Validate required fields
            if (title.isEmpty() || priceStr.isEmpty() || stockStr.isEmpty() || 
                description.isEmpty() || category.isEmpty()) {
                request.setAttribute("error", "All required fields must be filled!");
                request.getRequestDispatcher("/view/addItem.jsp").forward(request, response);
                return;
            }

            double price;
            int stock;
            
            try {
                price = Double.parseDouble(priceStr);
                stock = Integer.parseInt(stockStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Please enter valid numbers for price and stock quantity!");
                request.getRequestDispatcher("/view/addItem.jsp").forward(request, response);
                return;
            }

            if (price < 0 || stock < 0) {
                request.setAttribute("error", "Price and stock quantity cannot be negative!");
                request.getRequestDispatcher("/view/addItem.jsp").forward(request, response);
                return;
            }

            // Check if item already exists
            if (itemService.isItemExist(title, category)) {
                request.setAttribute("error", "Item with this name and category already exists!");
                request.getRequestDispatcher("/view/addItem.jsp").forward(request, response);
                return;
            }

            Part imagePart = request.getPart("image");
            if (imagePart == null || imagePart.getSize() == 0) {
                request.setAttribute("error", "Please select an image file!");
                request.getRequestDispatcher("/view/addItem.jsp").forward(request, response);
                return;
            }

            String imagePath = handleFileUpload(imagePart, request);

            Item item = new Item();
            item.setTitle(title);
            item.setAuthor(author.isEmpty() ? null : author); // Allow empty author for some categories
            item.setPrice(price);
            item.setStockQuantity(stock);
            item.setDescription(description);
            item.setCategory(category);
            item.setImage(imagePath);
            item.setAddedBy(addedBy);

            boolean success = itemService.addItem(item);
            
            if (success) {
                request.setAttribute("success", "Item successfully added!");
            } else {
                request.setAttribute("error", "Failed to add item. Please try again.");
            }
            
            request.getRequestDispatcher("/view/addItem.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to add item: " + e.getMessage());
            request.getRequestDispatcher("/view/addItem.jsp").forward(request, response);
        }
    }

    /**
     * Safely get parameter with null and empty string checks
     */
    private String getParameterSafely(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        if (value == null) {
            return "";
        }
        return value.trim();
    }

    private String getAddedByFromSession(HttpSession session) {
        if (session == null) {
            System.out.println("Session is null");
            return "unknown";
        }

        // Try different possible session attribute names
        String userEmail = null;
        
        // Method 1: Try getting email directly from session
        userEmail = (String) session.getAttribute("userEmail");
        if (userEmail != null && !userEmail.trim().isEmpty()) {
            return userEmail;
        }
        
        // Method 2: Try getting from user object
        Object user = session.getAttribute("user");
        if (user != null) {
            try {
                // Try casting to User class and get email
                if (user instanceof com.bookshop.model.User) {
                    userEmail = ((com.bookshop.model.User) user).getEmail();
                    if (userEmail != null && !userEmail.trim().isEmpty()) {
                        return userEmail;
                    }
                }
                
                // Try reflection to get email if the class structure is different
                java.lang.reflect.Method getEmailMethod = user.getClass().getMethod("getEmail");
                userEmail = (String) getEmailMethod.invoke(user);
                if (userEmail != null && !userEmail.trim().isEmpty()) {
                    return userEmail;
                }
            } catch (Exception e) {
                System.out.println("Error getting email from user object: " + e.getMessage());
            }
        }
        
        // Method 3: Try other common session attribute names
        String[] possibleEmailKeys = {"email", "loginEmail", "currentUser", "loggedInUser"};
        for (String key : possibleEmailKeys) {
            Object value = session.getAttribute(key);
            if (value != null) {
                if (value instanceof String) {
                    userEmail = (String) value;
                    if (userEmail != null && !userEmail.trim().isEmpty()) {
                        return userEmail;
                    }
                }
            }
        }
        
        // Method 4: Try getting userType and user combination
        String userType = (String) session.getAttribute("userType");
        System.out.println("User type: " + userType + ", User object: " + (user != null ? user.getClass().getName() : "null"));
        
        if (userType != null && user != null) {
            try {
                if ("staff".equals(userType) || "admin".equals(userType) || "customer".equals(userType)) {
                    if (user instanceof com.bookshop.model.User) {
                        userEmail = ((com.bookshop.model.User) user).getEmail();
                        if (userEmail != null && !userEmail.trim().isEmpty()) {
                            return userEmail;
                        }
                    }
                }
            } catch (Exception e) {
                System.out.println("Error in userType-based retrieval: " + e.getMessage());
            }
        }
        
        // Log session attributes for debugging
        System.out.println("Session attributes:");
        java.util.Enumeration<String> attributeNames = session.getAttributeNames();
        while (attributeNames.hasMoreElements()) {
            String attributeName = attributeNames.nextElement();
            Object attributeValue = session.getAttribute(attributeName);
            System.out.println("  " + attributeName + " = " + attributeValue + " (" + 
                             (attributeValue != null ? attributeValue.getClass().getName() : "null") + ")");
        }
        
        return "unknown";
    }

    private String handleFileUpload(Part filePart, HttpServletRequest request) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;  // No file uploaded
        }

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        
        // Add timestamp to prevent filename collisions
        String timestamp = String.valueOf(System.currentTimeMillis());
        String fileExtension = "";
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex > 0) {
            fileExtension = fileName.substring(dotIndex);
            fileName = fileName.substring(0, dotIndex) + "_" + timestamp + fileExtension;
        } else {
            fileName = fileName + "_" + timestamp;
        }

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
            String title = getParameterSafely(request, "title");
            String author = getParameterSafely(request, "author");
            String priceStr = getParameterSafely(request, "price");
            String stockStr = getParameterSafely(request, "stock_quantity");
            String description = getParameterSafely(request, "description");
            String category = getParameterSafely(request, "category");

            // Handle new category case for update as well
            if ("add_new".equals(category)) {
                String newCategory = getParameterSafely(request, "newCategory");
                if (!newCategory.isEmpty()) {
                    category = newCategory;
                }
            }

            double price = Double.parseDouble(priceStr);
            int stock = Integer.parseInt(stockStr);

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
            item.setAuthor(author.isEmpty() ? null : author);
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
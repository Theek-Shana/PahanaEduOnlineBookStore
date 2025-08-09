<%@ page session="true" contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userType = (String) session.getAttribute("userType");
    if (userType == null || (!"staff".equals(userType) && !"admin".equals(userType))) {
        response.sendRedirect(request.getContextPath() + "/view/login.jsp");
        return;
    }

    com.bookshop.model.Item item = (com.bookshop.model.Item) request.getAttribute("item");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Book</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #1a1a1a, #2c2c2c);
            color: #fff;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .form-container {
            background: rgba(255, 255, 255, 0.08);
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
            width: 450px;
            backdrop-filter: blur(10px);
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        input, textarea, select {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            margin-bottom: 15px;
            border: none;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
            font-size: 14px;
        }

        input::placeholder, textarea::placeholder {
            color: #ccc;
        }

        input[type="file"] {
            background: none;
            color: #fff;
        }

        .image-preview {
            text-align: center;
            margin-bottom: 10px;
        }

        .image-preview img {
            width: 100px;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #444;
        }

        button {
            width: 100%;
            background-color: #28a745;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

<div class="form-container">
    <h2>✏️ Edit Book</h2>
    <form action="<%= request.getContextPath() %>/item?action=update" method="post" enctype="multipart/form-data">
        <input type="hidden" name="itemId" value="<%= item.getItemId() %>" />

        <input type="text" name="title" value="<%= item.getTitle() %>" placeholder="Title" required />
        <input type="text" name="author" value="<%= item.getAuthor() %>" placeholder="Author" required />
        <input type="number" name="price" value="<%= item.getPrice() %>" step="0.01" placeholder="Price" required />
        <input type="number" name="stock_quantity" value="<%= item.getStockQuantity() %>" placeholder="Stock Quantity" required />
        <textarea name="description" placeholder="Description" required><%= item.getDescription() %></textarea>
        <input type="text" name="category" value="<%= item.getCategory() %>" placeholder="Category" required />

        <div class="image-preview">
            <p style="margin-bottom: 5px;">Current Image:</p>
            <img src="<%= request.getContextPath() + "/" + item.getImage() %>" alt="Current Book Image" />
        </div>

        <input type="hidden" name="existingImage" value="<%= item.getImage() %>" />
        <label for="image">Change Image (optional):</label>
        <input type="file" name="image" accept="image/*" />

        <button type="submit">Update Book</button>
    </form>
</div>

</body>
</html>

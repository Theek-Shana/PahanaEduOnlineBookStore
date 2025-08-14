<%@ page session="true" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>Add New Item</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
<style>
body {
    font-family: 'Poppins', sans-serif;
    background: linear-gradient(to right, #2c5364, #203a43, #0f2027);
    color: #fff;
    padding: 30px;
    min-height: 100vh;
}

h2 {
    text-align: center;
    margin-bottom: 30px;
    font-weight: 600;
    font-size: 2rem;
}

form {
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(10px);
    padding: 30px;
    border-radius: 15px;
    width: 600px;
    margin: auto;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
}

.form-group {
    margin-bottom: 20px;
}

label {
    display: block;
    margin-bottom: 8px;
    font-weight: 500;
    color: #f0f0f0;
}

input, textarea, select {
    width: 100%;
    padding: 12px 16px;
    border-radius: 8px;
    border: none;
    font-size: 16px;
    background-color: rgba(255, 255, 255, 0.1);
    color: #fff;
    outline: none;
    transition: background-color 0.3s ease;
    box-sizing: border-box;
}

input:focus, textarea:focus, select:focus {
    background-color: rgba(255, 255, 255, 0.15);
}

input::placeholder, textarea::placeholder {
    color: rgba(255, 255, 255, 0.7);
}

select option {
    background-color: #2c5364;
    color: #fff;
}

button {
    width: 100%;
    padding: 15px 20px;
    background-color: #27ae60;
    border: none;
    border-radius: 8px;
    color: white;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: background-color 0.3s ease;
    margin-top: 10px;
}

button:hover {
    background-color: #219150;
}

.error {
    color: #f44336;
    margin-bottom: 20px;
    text-align: center;
    padding: 10px;
    background-color: rgba(244, 67, 54, 0.1);
    border-radius: 8px;
}

.success {
    color: #4caf50;
    margin-bottom: 20px;
    text-align: center;
    padding: 10px;
    background-color: rgba(76, 175, 80, 0.1);
    border-radius: 8px;
}

.field-group {
    transition: all 0.3s ease;
}

.field-group.hidden {
    display: none;
}

.category-hint {
    font-size: 14px;
    color: rgba(255, 255, 255, 0.6);
    margin-top: 5px;
}

.author-label {
    transition: all 0.3s ease;
}

.back-link {
    display: block;
    text-align: center;
    margin-top: 20px;
    color: #fff;
    text-decoration: none;
    padding: 10px;
    background-color: rgba(255, 255, 255, 0.1);
    border-radius: 8px;
    transition: background-color 0.3s ease;
}

.back-link:hover {
    background-color: rgba(255, 255, 255, 0.15);
    color: #fff;
    text-decoration: none;
}
</style>
</head>
<body>
<h2>📚 Add New Item</h2>

<c:if test="${not empty error}">
<div class="error">${error}</div>
</c:if>

<c:if test="${not empty success}">
<div class="success">${success}</div>
</c:if>

<form action="${pageContext.request.contextPath}/item?action=add" method="post" enctype="multipart/form-data">
   <!-- Category Selection -->
<div class="form-group">
    <label for="category">📋 Category *</label>
    <select name="category" id="category" required onchange="updateFormFields()">
        <option value="">Select Category</option>
        <option value="Books">📚 Books</option>
        <option value="Story Books">📖 Story Books</option>
        <option value="Educational Books">🎓 Educational Books</option>
        <option value="Comics">💥 Comics</option>
        <option value="Magazines">📰 Magazines</option>
        <option value="Accessories">🎯 Accessories</option>
        <option value="Stationery">✏️ Stationery</option>
        <option value="Electronics">💻 Electronics</option>
        <option value="add_new">➕ Add New Category</option>
    </select>
    <div class="category-hint">Choose the appropriate category for your item</div>
</div>

<!-- New Category Input (hidden initially) -->
<div class="form-group field-group hidden" id="newCategoryField">
    <label for="newCategory">🆕 Enter New Category *</label>
    <input type="text" name="newCategory" id="newCategory" placeholder="Enter new category name" />
    <div class="category-hint">This will create a new category in your system</div>
</div>

    <!-- Item Name -->
    <div class="form-group">
        <label for="title">📝 Item Name *</label>
        <input type="text" name="title" id="title" placeholder="Enter item name" required />
    </div>

    <!-- Author Field (Dynamic label and requirement) -->
    <div class="form-group field-group" id="authorField">
        <label for="author" id="authorLabel" class="author-label">✍️ Author *</label>
        <input type="text" name="author" id="author" placeholder="Enter author name" required />
    </div>

    <!-- Price -->
    <div class="form-group">
        <label for="price">💰 Price (Rs.) *</label>
        <input type="number" name="price" id="price" placeholder="0.00" step="0.01" min="0" required />
    </div>

    <!-- Stock Quantity -->
    <div class="form-group">
        <label for="stock_quantity">📦 Stock Quantity *</label>
        <input type="number" name="stock_quantity" id="stock_quantity" placeholder="Enter quantity" min="0" required />
    </div>

    <!-- Description -->
    <div class="form-group">
        <label for="description">📄 Description *</label>
        <textarea name="description" id="description" rows="4" placeholder="Enter item description" required></textarea>
    </div>

    <!-- Image Upload -->
    <div class="form-group">
        <label for="image">🖼️ Item Image *</label>
        <input type="file" name="image" id="image" accept="image/*" required />
    </div>

    <button type="submit">➕ Add Item</button>
</form>

<a href="${pageContext.request.contextPath}/item?action=list" class="back-link">← Back to Items List</a>

<script>
function updateFormFields() {
    const category = document.getElementById('category').value;
    const authorField = document.getElementById('authorField');
    const authorInput = document.getElementById('author');
    const authorLabel = document.getElementById('authorLabel');

    const newCategoryField = document.getElementById('newCategoryField');
    const newCategoryInput = document.getElementById('newCategory');

    // Show/hide new category input
    if(category === 'add_new') {
        newCategoryField.classList.remove('hidden');
        newCategoryInput.setAttribute('required', 'required');
    } else {
        newCategoryField.classList.add('hidden');
        newCategoryInput.removeAttribute('required');
        newCategoryInput.value = ''; // Clear the value when hidden
    }

    // Reset author field
    authorField.classList.remove('hidden');

    // Update author/brand based on selected category
    switch(category) {
        case 'Books':
        case 'Story Books':
        case 'Educational Books':
        case 'Comics':
            authorLabel.innerHTML = '✍️ Author *';
            authorInput.placeholder = 'Enter author name';
            authorInput.setAttribute('required', 'required');
            break;
        case 'Magazines':
            authorLabel.innerHTML = '✍️ Author/Editor';
            authorInput.placeholder = 'Enter author or editor name (optional)';
            authorInput.removeAttribute('required');
            break;
        case 'Accessories':
        case 'Electronics':
            authorLabel.innerHTML = '🏷️ Brand/Manufacturer';
            authorInput.placeholder = 'Enter brand or manufacturer name (optional)';
            authorInput.removeAttribute('required');
            break;
        case 'Stationery':
            authorLabel.innerHTML = '🏷️ Brand';
            authorInput.placeholder = 'Enter brand name (optional)';
            authorInput.removeAttribute('required');
            break;
        case 'add_new':
            authorLabel.innerHTML = '✍️ Author/Brand';
            authorInput.placeholder = 'Enter author or brand name (optional)';
            authorInput.removeAttribute('required');
            break;
        default:
            if (category === '') {
                authorField.classList.add('hidden');
                authorInput.removeAttribute('required');
            } else {
                authorLabel.innerHTML = '✍️ Author/Brand';
                authorInput.placeholder = 'Enter author or brand name (optional)';
                authorInput.removeAttribute('required');
            }
            break;
    }
}

// Form validation before submit
document.querySelector('form').addEventListener('submit', function(e) {
    const categorySelect = document.getElementById('category');
    const newCategoryInput = document.getElementById('newCategory');
    
    // If "Add New Category" is selected, validate that new category name is provided
    if(categorySelect.value === 'add_new') {
        if(!newCategoryInput.value || newCategoryInput.value.trim() === '') {
            e.preventDefault();
            alert('Please enter a new category name!');
            newCategoryInput.focus();
            return false;
        }
        
        // Validate category name doesn't contain special characters
        const categoryName = newCategoryInput.value.trim();
        if (categoryName.length < 2) {
            e.preventDefault();
            alert('Category name must be at least 2 characters long!');
            newCategoryInput.focus();
            return false;
        }
        
        // Check for valid category name (letters, numbers, spaces only)
        if (!/^[a-zA-Z0-9\s]+$/.test(categoryName)) {
            e.preventDefault();
            alert('Category name can only contain letters, numbers, and spaces!');
            newCategoryInput.focus();
            return false;
        }
    }
    
    // Basic form validation
    const requiredFields = ['title', 'price', 'stock_quantity', 'description'];
    for (let field of requiredFields) {
        const element = document.getElementById(field);
        if (!element.value || element.value.trim() === '') {
            e.preventDefault();
            alert('Please fill in all required fields!');
            element.focus();
            return false;
        }
    }
    
    // Validate image file
    const imageInput = document.getElementById('image');
    if (!imageInput.files || imageInput.files.length === 0) {
        e.preventDefault();
        alert('Please select an image file!');
        imageInput.focus();
        return false;
    }
    
    // Check file type
    const file = imageInput.files[0];
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
    if (!allowedTypes.includes(file.type)) {
        e.preventDefault();
        alert('Please select a valid image file (JPEG, PNG, or GIF)!');
        imageInput.focus();
        return false;
    }
    
    // Check file size (10MB max)
    if (file.size > 10 * 1024 * 1024) {
        e.preventDefault();
        alert('Image file size must be less than 10MB!');
        imageInput.focus();
        return false;
    }
    
    return true;
});

// Initialize form on page load
document.addEventListener('DOMContentLoaded', function() {
    updateFormFields();
});

</script>

</body>
</html>
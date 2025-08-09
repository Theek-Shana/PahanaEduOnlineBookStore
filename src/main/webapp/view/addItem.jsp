<%@ page session="true" contentType="text/html;charset=UTF-8" language="java" %>
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
</style>
</head>
<body>
<h2>📚 Add New Item</h2>

<c:if test="${not empty error}">
<div class="error">${error}</div>
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
        </select>
        <div class="category-hint">Choose the appropriate category for your item</div>
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

<script>
function updateFormFields() {
    const category = document.getElementById('category').value;
    const authorField = document.getElementById('authorField');
    const authorInput = document.getElementById('author');
    const authorLabel = document.getElementById('authorLabel');
    
    // Reset field visibility
    authorField.classList.remove('hidden');
    
    // Update field based on category
    switch(category) {
        case 'Books':
        case 'Story Books':
        case 'Educational Books':
        case 'Comics':
            authorLabel.innerHTML = '✍️ Author *';
            authorInput.placeholder = 'Enter author name';
            authorInput.setAttribute('required', 'required');
            authorField.classList.remove('hidden');
            break;
            
        case 'Magazines':
            authorLabel.innerHTML = '✍️ Author/Editor';
            authorInput.placeholder = 'Enter author or editor name (optional)';
            authorInput.removeAttribute('required');
            authorField.classList.remove('hidden');
            break;
            
        case 'Accessories':
        case 'Electronics':
            authorLabel.innerHTML = '🏷️ Brand/Manufacturer';
            authorInput.placeholder = 'Enter brand or manufacturer name (optional)';
            authorInput.removeAttribute('required');
            authorField.classList.remove('hidden');
            break;
            
        case 'Stationery':
            authorLabel.innerHTML = '🏷️ Brand';
            authorInput.placeholder = 'Enter brand name (optional)';
            authorInput.removeAttribute('required');
            authorField.classList.remove('hidden');
            break;
            
        default:
            // Hide author field if no category selected
            authorField.classList.add('hidden');
            authorInput.removeAttribute('required');
            break;
    }
}

// Initialize form on page load
document.addEventListener('DOMContentLoaded', function() {
    updateFormFields();
});
</script>

</body>
</html>
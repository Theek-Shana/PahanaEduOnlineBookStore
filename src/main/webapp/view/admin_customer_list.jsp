<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Admin Dashboard - Customer Management</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Poppins', sans-serif;
      background: #f4f6f8;
      margin: 30px;
      color: #222;
    }

    h1 {
      text-align: center;
      margin-bottom: 40px;
      font-weight: 700;
      color: #333;
    }

    .button-group {
      text-align: center;
      margin-bottom: 30px;
    }

    button.main-btn {
      background-color: #007bff;
      color: #fff;
      border: none;
      margin: 0 12px;
      padding: 12px 24px;
      font-weight: 600;
      border-radius: 8px;
      font-size: 16px;
      cursor: pointer;
      transition: background-color 0.25s ease;
    }

    button.main-btn:hover {
      background-color: #0056b3;
    }

    section {
      display: none;
      max-width: 1000px;
      margin: 0 auto 40px auto;
      background: #ffffff;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
    }

    section.active {
      display: block;
    }

    form label {
      display: block;
      margin: 14px 0 6px;
      font-weight: 600;
    }

    form input[type="text"],
    form input[type="email"],
    form input[type="password"] {
      width: 100%;
      padding: 10px 14px;
      border-radius: 8px;
      border: 1.5px solid #ccc;
      font-size: 15px;
      transition: border-color 0.3s ease;
    }

    form input:focus {
      border-color: #007bff;
      outline: none;
    }

    form button.submit-btn {
      margin-top: 24px;
      background-color: #28a745;
      color: white;
      font-weight: 600;
      border: none;
      padding: 14px 30px;
      font-size: 16px;
      border-radius: 8px;
      cursor: pointer;
      transition: background-color 0.25s ease;
    }

    form button.submit-btn:hover {
      background-color: #1e7e34;
    }

    table {
      width: 100%;
      border-collapse: collapse;
    }

    th,
    td {
      padding: 14px 10px;
      border-bottom: 1px solid #ddd;
      text-align: left;
    }

    th {
      background-color: #007bff;
      color: white;
      font-weight: 600;
    }

    tr:hover {
      background-color: #f1f8ff;
    }

    button.edit-btn,
    button.save-btn,
    button.cancel-btn,
    button.delete-btn {
      padding: 8px 16px;
      border-radius: 6px;
      border: none;
      cursor: pointer;
      font-weight: 600;
      font-size: 14px;
      margin-right: 6px;
      transition: background-color 0.2s ease;
    }
     .edit-btn, .delete-btn {
        padding: 6px 14px;
        font-size: 14px;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        font-weight: 500;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        transition: background-color 0.3s ease;
        text-decoration: none;
        margin-right: 8px;
        color: #fff;
    }

    .edit-btn {
        background-color: #2196F3;
    }

    .edit-btn:hover {
        background-color: #1976D2;
    }

    .delete-btn {
        background-color: #f44336;
    }

    .delete-btn:hover {
        background-color: #d32f2f;
    }

    button.edit-btn {
      background-color: #ffc107;
      color: #212529;
    }

    button.edit-btn:hover {
      background-color: #e0a800;
    }

    button.save-btn {
      background-color: #28a745;
      color: white;
    }

    button.save-btn:hover {
      background-color: #1e7e34;
    }

    button.cancel-btn {
      background-color: #6c757d;
      color: white;
      min-width: 70px;
    }

    button.cancel-btn:hover {
      background-color: #565e64;
    }

    button.delete-btn {
      background-color: #dc3545;
      color: white;
    }

    button.delete-btn:hover {
      background-color: #bd2130;
    }

    .edit-mode input.edit-input {
      width: 100%;
      padding: 8px 10px;
      font-size: 15px;
      border-radius: 6px;
      border: 1.5px solid #007bff;
      transition: border-color 0.3s ease;
    }

    .edit-mode input.edit-input:focus {
      outline: none;
      border-color: #0056b3;
      background-color: #e7f1ff;
    }

    td:last-child {
      display: flex;
      gap: 10px;
      align-items: center;
    }

    #search-input {
      width: 100%;
      max-width: 400px;
      padding: 12px 16px;
      font-size: 16px;
      border: 1.5px solid #ccc;
      border-radius: 8px;
      margin-bottom: 20px;
    }

    @media (max-width: 768px) {
      body {
        margin: 15px;
      }

      button.main-btn {
        margin: 10px 6px;
        padding: 10px 20px;
        font-size: 14px;
      }

      #search-input {
        width: 100%;
      }

      table th,
      table td {
        font-size: 14px;
      }
    }
  </style>
</head>

<body>
<h1>Admin Dashboard - Customer Management</h1>

<div class="button-group">
  <button class="main-btn" onclick="showSection('add-section')">Add Customer</button>
  <button class="main-btn" onclick="showSection('view-section')">View All Customers</button>
  <button class="main-btn" onclick="showSection('search-section')">Search Customers</button>
</div>

<section id="add-section">
 <form id="addCustomerForm" action="${pageContext.request.contextPath}/admin/customers" method="post">
    <input type="hidden" name="action" value="create" />

    <label for="fullname">Full Name</label>
    <input id="fullname" name="fullname" type="text" required />
    <label for="email">Email</label>
    <input id="email" name="email" type="email" required />
    <label for="mobile">Mobile</label>
    <input id="mobile" name="mobile" type="text" required />
    <label for="password">Password</label>
    <input id="password" name="password" type="password" required />
    <button class="submit-btn" type="submit">Add Customer</button>
</form>

  <c:if test="${not empty success}">
    <p style="color: green; font-weight: 600; margin-top: 12px;">${success}</p>
  </c:if>
  <c:if test="${not empty error}">
    <p style="color: red; font-weight: 600; margin-top: 12px;">${error}</p>
  </c:if>
</section>

<section id="view-section">
  <h2>All Customers</h2>
  <table id="customers-table">
    <thead>
      <tr>
        <th>ID</th>
        <th>Account Number</th>
        <th>Full Name</th>
        <th>Email</th>
        <th>Mobile</th>
        <th>Created At</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="customer" items="${customers}">
        <tr data-id="${customer.id}">
          <td>${customer.id}</td>
          <td class="accountNumber">${customer.accountNumber}</td>
          <td class="fullname">${customer.fullname}</td>
          <td class="email">${customer.email}</td>
          <td class="mobile">${customer.mobile}</td>
          <td>${customer.createdAt}</td>
          <td>
<a href="${pageContext.request.contextPath}/admin/customers?action=edit&id=${customer.id}" class="edit-btn">Edit</a>
<button class="delete-btn" onclick="deleteCustomer(${customer.id})">Delete</button>
</td>

        </tr>
      </c:forEach>
    </tbody>
  </table>
</section>

<section id="search-section">
  <h2>Search Customers</h2>
  <input type="text" id="search-input" placeholder="Search by name or email..." onkeyup="filterTable()" />
  <table id="search-results-table">
    <thead>
      <tr>
        <th>ID</th>
        <th>Account Number</th>
        <th>Full Name</th>
        <th>Email</th>
        <th>Mobile</th>
        <th>Created At</th>
      </tr>
    </thead>
    <tbody id="search-results-body">
      <!-- Results loaded by JS -->
    </tbody>
  </table>
</section>

<script>
  function showSection(id) {
    document.querySelectorAll('section').forEach(s => s.classList.remove('active'));
    document.getElementById(id).classList.add('active');
  }

  function startEdit(button) {
    let row = button.closest('tr');
    if (row.classList.contains('edit-mode')) return;
    row.classList.add('edit-mode');

    ['accountNumber', 'fullname', 'email', 'mobile'].forEach(cls => {
      let cell = row.querySelector('.' + cls);
      let val = cell.textContent.trim();
      cell.innerHTML = `<input type="text" value="${val}" class="edit-input" name="${cls}" />`;
    });

    button.textContent = 'Save';
    button.classList.replace('edit-btn', 'save-btn');
    button.onclick = () => saveEdit(row);

    let actionsCell = row.querySelector('td:last-child');
    let cancelBtn = document.createElement('button');
    cancelBtn.textContent = 'Cancel';
    cancelBtn.className = 'cancel-btn';
    cancelBtn.onclick = () => cancelEdit(row);
    actionsCell.appendChild(cancelBtn);
  }

  function cancelEdit(row) {
    window.location.reload();
  }

  function saveEdit(row) {
    let id = row.dataset.id;
    let inputs = row.querySelectorAll('input.edit-input');
    let data = {
      id: id,
      action: 'update',
      accountNumber: inputs[0].value.trim(),
      fullname: inputs[1].value.trim(),
      email: inputs[2].value.trim(),
      mobile: inputs[3].value.trim()
    };

    if (!data.accountNumber || !data.fullname || !data.email || !data.mobile) {
      alert('Please fill all fields!');
      return;
    }

    fetch('${pageContext.request.contextPath}/admin/customers', {
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: new URLSearchParams(data).toString()
    })
    .then(res => {
      if (res.ok) {
        alert('Customer updated successfully!');
        window.location.reload();
      } else {
        alert('Failed to update customer.');
      }
    })
    .catch(err => {
      alert('Error updating customer.');
      console.error(err);
    });
  }

  function deleteCustomer(id) {
    if (!confirm('Are you sure you want to delete this customer?')) return;

    fetch('${pageContext.request.contextPath}/admin/customers', {
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: new URLSearchParams({id: id, action: 'delete'}).toString()
    })
    .then(res => {
      if (res.ok) {
        alert('Customer deleted successfully!');
        window.location.reload();
      } else {
        alert('Failed to delete customer.');
      }
    })
    .catch(err => {
      alert('Error deleting customer.');
      console.error(err);
    });
  }

  function filterTable() {
    let input = document.getElementById('search-input');
    let filter = input.value.toLowerCase();
    let tbody = document.getElementById('search-results-body');
    tbody.innerHTML = '';

    let rows = document.querySelectorAll('#customers-table tbody tr');

    rows.forEach(row => {
      let fullname = row.querySelector('.fullname').textContent.toLowerCase();
      let email = row.querySelector('.email').textContent.toLowerCase();

      if (fullname.includes(filter) || email.includes(filter)) {
        let clone = row.cloneNode(true);
        clone.querySelector('td:last-child').remove();
        tbody.appendChild(clone);
      }
    });
  }

  window.onload = () => showSection('view-section');
</script>

</body>
</html>
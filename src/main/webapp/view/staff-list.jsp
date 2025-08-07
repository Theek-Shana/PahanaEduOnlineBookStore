<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.bookshop.model.User" %>
<%
    List<User> staffList = (List<User>) request.getAttribute("staffList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Staff List</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #121212;
            color: #eee;
            margin: 0;
            padding: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #1e1e1e;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0,0,0,0.7);
        }
        thead {
            background-color: #00bcd4;
        }
        thead th {
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #121212;
        }
        tbody tr:hover {
            background-color: #333;
        }
        tbody td {
            padding: 12px;
            border-bottom: 1px solid #444;
            vertical-align: middle;
        }
        .btn-delete, .btn-edit {
            border: none;
            color: white;
            padding: 7px 14px;
            font-size: 14px;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-right: 8px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-delete {
            background-color: #e74c3c;
        }
        .btn-delete:hover {
            background-color: #c0392b;
        }
        .btn-edit {
            background-color: #3498db;
        }
        .btn-edit:hover {
            background-color: #2980b9;
        }
        .no-data {
            text-align: center;
            padding: 20px;
            color: #aaa;
        }
        form {
            display: inline;
            margin: 0;
        }
    </style>
</head>
<body>
    <h2>Staff Members</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Mobile</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
        <%
            if (staffList != null && !staffList.isEmpty()) {
                for (User s : staffList) {
        %>
            <tr>
                <td><%= s.getId() %></td>
                <td><%= s.getFullname() != null ? s.getFullname() : "" %></td>
                <td><%= s.getEmail() != null ? s.getEmail() : "" %></td>
                <td><%= s.getMobile() != null ? s.getMobile() : "" %></td>
                <td>
                    <!-- Edit button points to UserController /login servlet -->
                    <a href="<%= request.getContextPath() %>/login?action=edit&id=<%= s.getId() %>" class="btn-edit">Edit</a>

                    <!-- Delete form posts to /login servlet -->
                    <form action="<%= request.getContextPath() %>/login" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="delete"/>
                        <input type="hidden" name="id" value="<%= s.getId() %>" />
                        <button type="submit" class="btn-delete" onclick="return confirm('Are you sure to delete this staff?');">Delete</button>
                    </form>
                </td>
            </tr>
        <%
                }
            } else {
        %>
            <tr><td colspan="5" class="no-data">No staff found.</td></tr>
        <%
            }
        %>
        </tbody>
    </table>
</body>
</html>

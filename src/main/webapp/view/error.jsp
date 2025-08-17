<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Error</title>
</head>
<body>
    <h2 style="color:red;">Oops! Something went wrong.</h2>
    <p><%= request.getParameter("error") != null ? request.getParameter("error") : "Unknown error." %></p>
    <a href="<%= request.getContextPath() %>/view/customerDashboard.jsp">Go Back</a>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>General Chat</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #e0eafc, #cfdef3);
            margin: 0;
            padding: 0;
        }

        .chat-container {
            max-width: 750px;
            margin: 50px auto;
            background: #ffffff;
            padding: 25px 30px;
            border-radius: 15px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
            animation: fadeIn 0.6s ease-in-out;
        }

        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(20px);}
            to {opacity: 1; transform: translateY(0);}
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 25px;
            font-weight: 600;
        }

        .messages-box {
            max-height: 400px;
            overflow-y: auto;
            background: #f2f4f7;
            padding: 15px;
            border-radius: 10px;
            border: 1px solid #ccc;
            display: flex;
            flex-direction: column;
        }

        .message {
            margin-bottom: 15px;
            padding: 12px 15px;
            border-radius: 10px;
            max-width: 80%;
            position: relative;
            box-shadow: 0 3px 8px rgba(0,0,0,0.08);
            animation: fadeInUp 0.4s ease;
        }

        .message-left {
            background-color: #e1f5fe;
            color: #333;
            align-self: flex-start;
        }

        .message-right {
            background-color: #d1e7dd;
            color: #222;
            align-self: flex-end;
        }

        @keyframes fadeInUp {
            from {opacity: 0; transform: translateY(10px);}
            to {opacity: 1; transform: translateY(0);}
        }

        .sender-name {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
            color: #2c3e50;
        }

        .timestamp {
            font-size: 0.8em;
            color: #777;
            margin-top: 8px;
            text-align: right;
        }

        form {
            margin-top: 20px;
        }

        form textarea {
            width: 100%;
            height: 80px;
            padding: 12px;
            border-radius: 10px;
            border: 1px solid #ccc;
            font-size: 1rem;
            resize: vertical;
        }

        form button {
            margin-top: 10px;
            padding: 10px 25px;
            font-size: 1rem;
            background-color: #007bff;
            border: none;
            color: white;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        form button:hover {
            background-color: #0056b3;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
<div class="chat-container">
    <h2>General Chat</h2>

    <!-- Staff: show customer select box -->
    <c:if test="${userType == 'staff'}">
        <form method="get" action="${pageContext.request.contextPath}/chat" style="margin-bottom: 20px; text-align: center;">
            <label for="chatWithUserId">Select Customer to Chat:</label>
            <select id="chatWithUserId" name="chatWithUserId" onchange="this.form.submit()">
                <option value="">-- Select Customer --</option>
                <c:forEach var="cust" items="${customers}">
                    <option value="${cust.id}" 
<c:if test="${not empty chatWithUserId}">
    <input type="hidden" name="chatWithUserId" value="${chatWithUserId}" />
</c:if>
>
                        <c:out value="${cust.fullname}" /> (ID: <c:out value="${cust.id}" />)
                    </option>
                </c:forEach>
            </select>
            <noscript><button type="submit">Load Chat</button></noscript>
        </form>
    </c:if>

    <div class="messages-box">
        <c:choose>
            <c:when test="${empty messages}">
                <p>No messages yet. Start the conversation!</p>
            </c:when>
            <c:otherwise>
                <c:forEach var="msg" items="${messages}">
                    <div class="message
                        <c:choose>
                            <c:when test="${msg.senderId == user.id}">
                                message-right
                            </c:when>
                            <c:otherwise>
                                message-left
                            </c:otherwise>
                        </c:choose>">

                        <span class="sender-name">
                            <c:out value="${msg.senderName}" />
                            <c:if test="${userType == 'staff'}">
                                &nbsp;<small>(ID: <c:out value="${msg.senderId}" />)</small>
                            </c:if>
                        </span>

                        <span class="message-text"><c:out value="${msg.message}" /></span>
                        <div class="timestamp">
                            <fmt:formatDate value="${msg.sentAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/chat">
        <c:if test="${not empty chatWithUserId}">
            <!-- Pass chatWithUserId so message goes to correct customer chat -->
            <input type="hidden" name="chatWithUserId" value="${chatWithUserId}" />
        </c:if>
        <textarea name="message" required placeholder="Type your message here..."></textarea>
        <button type="submit">Send</button>
    </form>
</div>
</body>
</html>

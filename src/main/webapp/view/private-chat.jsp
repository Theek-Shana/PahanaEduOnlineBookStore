<%@ page import="java.util.List" %>
<%@ page import="com.bookshop.model.ChatMessage" %>
<%@ page import="com.bookshop.model.User" %>
<%@ page session="true" %>

<%
    List<ChatMessage> messages = (List<ChatMessage>) request.getAttribute("messages");
    Integer chatCustomerId = (Integer) request.getAttribute("chatCustomerId");
    User loggedInUser = (User) session.getAttribute("user");
    String userType = (String) session.getAttribute("userType");

    if (loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/view/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Private Chat</title>
    <style>
        /* your existing CSS styling here */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            margin: 0;
            padding: 30px 0;
            display: flex;
            justify-content: center;
        }
        .chat-container {
            background: white;
            max-width: 700px;
            width: 100%;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 20px 25px;
            display: flex;
            flex-direction: column;
            height: 80vh;
        }
        h2 { margin: 0 0 15px; color: #333; }
        #chatMessages {
            flex-grow: 1;
            overflow-y: auto;
            padding-right: 10px;
            border: 1px solid #ddd;
            border-radius: 12px;
            background: #fafafa;
            margin-bottom: 20px;
        }
        .message {
            max-width: 65%;
            padding: 12px 18px;
            margin: 10px 0;
            border-radius: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            font-size: 15px;
            line-height: 1.4;
            word-wrap: break-word;
            position: relative;
        }
        .sent-by-me {
            background-color: #dcf8c6;
            margin-left: auto;
            text-align: right;
            border-bottom-right-radius: 0;
        }
        .sent-by-other {
            background-color: #e1e7fe;
            margin-right: auto;
            text-align: left;
            border-bottom-left-radius: 0;
        }
        .sender {
            font-weight: 700;
            margin-bottom: 6px;
            color: #555;
            font-size: 13px;
        }
        .time {
            font-size: 11px;
            color: #999;
            margin-top: 5px;
        }
        form {
            display: flex;
            gap: 12px;
        }
        textarea {
            flex-grow: 1;
            height: 70px;
            padding: 12px 15px;
            font-size: 15px;
            border-radius: 20px;
            border: 1px solid #ccc;
            resize: none;
            box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);
            transition: border-color 0.3s;
        }
        textarea:focus {
            border-color: #00796b;
            outline: none;
        }
        button {
            background-color: #00796b;
            color: white;
            border: none;
            padding: 0 25px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #004d40;
        }
        a.back-link {
            color: #00796b;
            font-weight: 600;
            text-decoration: none;
            margin-bottom: 15px;
            display: inline-block;
        }
        a.back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="chat-container">

    <a class="back-link" href="<%=request.getContextPath()%>/dashboard.jsp">← Back to Dashboard</a>

    <h2>Private Chat with Customer ID: <%= chatCustomerId %></h2>

    <div id="chatMessages">
        <%
            if (messages != null && !messages.isEmpty()) {
                for (ChatMessage msg : messages) {
                    boolean isSender = (msg.getSenderId() == loggedInUser.getId() && msg.getSenderType().equalsIgnoreCase(userType));
                    String messageClass = isSender ? "sent-by-me" : "sent-by-other";

                    // Show sender type as Staff or Customer
                    String senderLabel = msg.getSenderType().equalsIgnoreCase("staff") ? "Staff" : "Customer";

        %>
        <div class="message <%= messageClass %>">
            <div class="sender"><%= senderLabel %>:</div>
            <div class="text"><%= msg.getMessage() %></div>
            <div class="time"><%= msg.getSentAt() != null ? msg.getSentAt().toString() : "" %></div>
        </div>
        <%          }
            } else { %>
            <p>No messages yet.</p>
        <% } %>
    </div>

    <form method="post" action="<%=request.getContextPath()%>/private-chat">
        <input type="hidden" name="customerId" value="<%= chatCustomerId %>"/>
        <textarea name="message" placeholder="Type your message here..." required></textarea>
        <button type="submit">Send</button>
    </form>
</div>
<script>
    // Scroll chat to bottom on page load
    const chatMessages = document.getElementById('chatMessages');
    if(chatMessages) {
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }
</script>
</body>
</html>

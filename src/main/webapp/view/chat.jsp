<%@ page import="java.util.List" %>
<%@ page import="com.bookshop.model.ChatMessage" %>
<%@ page session="true" %>
<%
    List<ChatMessage> messages = (List<ChatMessage>) request.getAttribute("messages");
    int orderId = (int) request.getAttribute("orderId");
    String userType = (String) session.getAttribute("userType");
    int userId = ((com.bookshop.model.User) session.getAttribute("user")).getId();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Chat for Order #<%= orderId %></title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f9f9f9;
            margin: 0;
            padding: 30px 0;
            display: flex;
            justify-content: center;
        }
        .chat-container {
            background: white;
            max-width: 600px;
            width: 100%;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 25px 30px;
            display: flex;
            flex-direction: column;
            height: 80vh;
        }
        h2 {
            margin: 0 0 20px;
            color: #333;
        }
        a {
            color: #00796b;
            font-weight: 600;
            text-decoration: none;
            margin-bottom: 15px;
            display: inline-block;
        }
        a:hover {
            text-decoration: underline;
        }
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
            max-width: 70%;
            padding: 12px 18px;
            margin: 10px 0;
            border-radius: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            font-size: 15px;
            line-height: 1.4;
            word-wrap: break-word;
            position: relative;
        }
        .customer {
            background-color: #dcf8c6;
            margin-left: auto;
            text-align: right;
            border-bottom-right-radius: 0;
        }
        .staff {
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
    </style>
</head>
<body>
    <div class="chat-container">
        <h2>Chat about Order #<%= orderId %></h2>
        <a href="<%= request.getContextPath() %>/view/orders.jsp">← Back to Orders</a>

        <div id="chatMessages">
            <% if (messages == null || messages.isEmpty()) { %>
                <p style="padding: 15px; color: #777;">No messages yet.</p>
            <% } else {
                for (ChatMessage msg : messages) {
                    boolean isCustomer = "customer".equalsIgnoreCase(msg.getSenderType());
                    boolean isMe = msg.getSenderId() == userId;
            %>
                <div class="message <%= isCustomer ? "customer" : "staff" %>">
                    <div class="sender"><%= isCustomer ? "Customer" : "Staff" %> <%= isMe ? "(You)" : "" %></div>
                    <div class="text"><%= msg.getMessage() %></div>
                    <div class="time"><%= msg.getSentAt() %></div>
                </div>
            <%  }
            } %>
        </div>

        <form action="<%= request.getContextPath() %>/chat" method="post">
            <input type="hidden" name="orderId" value="<%= orderId %>" />
            <textarea name="message" placeholder="Type your message here..." required></textarea>
            <button type="submit">Send</button>
        </form>
    </div>

    <script>
        // Scroll chat to bottom on page load
        const chatMessagesDiv = document.getElementById('chatMessages');
        if(chatMessagesDiv){
            chatMessagesDiv.scrollTop = chatMessagesDiv.scrollHeight;
        }
    </script>
</body>
</html>

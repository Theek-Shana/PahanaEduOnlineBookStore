package com.bookshop.controller;

import com.bookshop.dao.DBConnection;
import com.bookshop.dao.OrderDAO;
import com.bookshop.model.Order;
import com.bookshop.model.OrderItem;

import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import java.util.Properties;

@WebServlet("/sendOrderEmail")
public class SendOrderEmailServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null) {
            response.getWriter().write("Order ID is required.");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr);
        } catch (NumberFormatException e) {
            response.getWriter().write("Invalid order ID.");
            return;
        }

        try (Connection conn = DBConnection.getInstance().getConnection()) {
            OrderDAO orderDAO = new OrderDAO(conn);
            Order order = orderDAO.getOrderById(orderId);

            if (order == null) {
                response.getWriter().write("Order not found.");
                return;
            }

            String toEmail = order.getCustomerEmail();
            if (toEmail == null || toEmail.isEmpty()) {
                response.getWriter().write("Customer email not found.");
                return;
            }


            String subject = "Your Bookshop Order Bill #" + order.getOrderId();

            // Build HTML content for the email (simple version)
            StringBuilder htmlContent = new StringBuilder();

            htmlContent.append("<html>");
            htmlContent.append("<head>");
            htmlContent.append("<style>");
            htmlContent.append("  body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color: #333; background-color: #f4f4f4; padding: 20px; }");
            htmlContent.append("  .container { max-width: 600px; margin: auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }");
            htmlContent.append("  h2 { color: #2E86C1; margin-bottom: 10px; }");
            htmlContent.append("  p { line-height: 1.5; }");
            htmlContent.append("  table { width: 100%; border-collapse: collapse; margin-top: 20px; }");
            htmlContent.append("  th, td { padding: 12px 15px; border: 1px solid #ddd; text-align: left; }");
            htmlContent.append("  th { background-color: #2E86C1; color: white; }");
            htmlContent.append("  tbody tr:nth-child(even) { background-color: #f9f9f9; }");
            htmlContent.append("  tfoot td { font-weight: bold; font-size: 1.1em; }");
            htmlContent.append("  .footer { margin-top: 30px; font-size: 0.9em; color: #777; }");
            htmlContent.append("  a { color: #2E86C1; text-decoration: none; }");
            htmlContent.append("  a:hover { text-decoration: underline; }");
            htmlContent.append("</style>");
            htmlContent.append("</head>");
            htmlContent.append("<body>");
            htmlContent.append("<div class='container'>");

            htmlContent.append("<h2>Thank you for your purchase!</h2>");

            htmlContent.append("<p>Dear <strong>").append(order.getCustomerName()).append("</strong>,</p>");
            htmlContent.append("<p>We have received your order <strong>#").append(order.getOrderId()).append("</strong> placed on <strong>");
                      // .append(formattedDate).append("</strong>. Below are the details:</p>");

            htmlContent.append("<table>");
            htmlContent.append("<thead>");
            htmlContent.append("<tr>");
            htmlContent.append("<th>Item</th>");
            htmlContent.append("<th>Quantity</th>");
            htmlContent.append("<th>Unit Price (LKR)</th>");
            htmlContent.append("<th>Subtotal (LKR)</th>");
            htmlContent.append("</tr>");
            htmlContent.append("</thead>");
            htmlContent.append("<tbody>");

            for (OrderItem item : order.getItems()) {
                double subtotal = item.getPrice() * item.getQuantity();
                htmlContent.append("<tr>");
                htmlContent.append("<td>").append(item.getBookTitle()).append("</td>");
                htmlContent.append("<td style='text-align:center;'>").append(item.getQuantity()).append("</td>");
                htmlContent.append("<td style='text-align:right;'>").append(String.format("%.2f", item.getPrice())).append("</td>");
                htmlContent.append("<td style='text-align:right;'>").append(String.format("%.2f", subtotal)).append("</td>");
                htmlContent.append("</tr>");
            }

            htmlContent.append("</tbody>");
            htmlContent.append("<tfoot>");
            htmlContent.append("<tr>");
            htmlContent.append("<td colspan='3' style='text-align:right;'>Total:</td>");
            htmlContent.append("<td style='text-align:right;'>").append(String.format("%.2f", order.getTotalAmount())).append("</td>");
            htmlContent.append("</tr>");
            htmlContent.append("</tfoot>");
            htmlContent.append("</table>");

            htmlContent.append("<p>If you have any questions, feel free to contact us at <a href='mailto:support@bookshop.com'>support@bookshop.com</a>.</p>");

            htmlContent.append("<p>Best regards,<br><strong>Bookshop Team</strong></p>");

            htmlContent.append("<div class='footer'>");
            htmlContent.append("<p>This is an automated message. Please do not reply directly to this email.</p>");
            htmlContent.append("</div>");

            htmlContent.append("</div>"); // container
            htmlContent.append("</body>");
            htmlContent.append("</html>");

            // Send the email
            sendEmail(toEmail, subject, htmlContent.toString());

            response.getWriter().write("Email sent successfully to " + toEmail);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Failed to send email: " + e.getMessage());
        }
    }

    private void sendEmail(String toEmail, String subject, String htmlContent) throws MessagingException {
        final String fromEmail = "theek9365@gmail.com";       // Replace with your email
        final String appPassword = "ofpprmjnteckkkdf";         // Replace with your app password

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587"); 
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, appPassword);
            }
        });

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(fromEmail));
        msg.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
        msg.setSubject(subject);
        msg.setContent(htmlContent, "text/html; charset=utf-8");

        Transport.send(msg);
    }
}

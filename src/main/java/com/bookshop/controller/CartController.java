package com.bookshop.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/cart")
public class CartController extends HttpServlet {
	  @Override
	    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	        HttpSession session = req.getSession();

	        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
	        if (cart == null) {
	            cart = new HashMap<>();
	        }

	        String itemIdStr = req.getParameter("bookId");  // ensure this matches your form input name
	        if (itemIdStr != null) {
	            try {
	                int itemId = Integer.parseInt(itemIdStr);
	                cart.put(itemId, cart.getOrDefault(itemId, 0) + 1);
	                session.setAttribute("cart", cart);

	                // Redirect back to dashboard with success message
	                resp.sendRedirect(req.getContextPath() + "/view/customerDashboard.jsp?message=added");
	                return;
	            } catch (NumberFormatException e) {
	                e.printStackTrace();
	            }
	        }

	        resp.sendRedirect(req.getContextPath() + "/view/customerDashboard.jsp?error=invalid_item");
	    }

	    // New method for removing item from cart
	    @Override
	    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	        HttpSession session = req.getSession();

	        String removeItemIdStr = req.getParameter("removeItemId");
	        if (removeItemIdStr != null) {
	            try {
	                int removeItemId = Integer.parseInt(removeItemIdStr);
	                Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
	                if (cart != null && cart.containsKey(removeItemId)) {
	                    cart.remove(removeItemId);
	                    session.setAttribute("cart", cart);
	                }
	                resp.sendRedirect(req.getContextPath() + "/view/cart.jsp?message=removed");
	                return;
	            } catch (NumberFormatException e) {
	                e.printStackTrace();
	            }
	        }
	        resp.sendRedirect(req.getContextPath() + "/view/cart.jsp?error=invalid_remove");
	    }
}

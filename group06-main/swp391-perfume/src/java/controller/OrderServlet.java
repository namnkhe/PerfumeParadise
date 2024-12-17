/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.FeedBackDAO;
import dal.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;
import model.Order;

/**
 *
 * @author DELL
 */
public class OrderServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet OrderServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OrderServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        processRequest(request, response);

        HttpSession session = request.getSession();
        Customer c = (Customer) session.getAttribute("account");
        OrderDAO od = new OrderDAO();
        List<Order> orders = od.getAllOrderByCusId(c.getId());
        if (orders.isEmpty()) {
            request.setAttribute("ms", "No order!");
        }
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("order.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra người dùng đã đăng nhập hay chưa
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("account");

        if (customer == null) {
            response.sendRedirect("login.jsp"); // Chuyển hướng đến trang đăng nhập nếu chưa đăng nhập
            return;
        }

        // Lấy action từ form
        String action = request.getParameter("action");

        if ("feedback".equals(action)) {
            // Xử lý phần feedback (rate + comment)

            // Lấy dữ liệu từ form
            String ratingStr = request.getParameter("rating");
            String comment = request.getParameter("comment");
            String orderIdStr = request.getParameter("orderId");
            String productIdStr = request.getParameter("productId");

            try {
                int rating = Integer.parseInt(ratingStr);
                int orderId = Integer.parseInt(orderIdStr);
                int productId = Integer.parseInt(productIdStr);
                int marketerId = customer.getId(); // Giả sử marketer là người dùng hiện tại
                String status = "pending"; // Trạng thái mặc định

                // Lưu feedback vào cơ sở dữ liệu
                FeedBackDAO feedbackDAO = new FeedBackDAO();
                feedbackDAO.saveFeedback(customer.getId(), productId, rating, comment, marketerId, status);

                // Gửi thông báo thành công
                request.setAttribute("ms", "Thank you for your feedback!");
            } catch (NumberFormatException e) {
                // Xử lý lỗi khi không thể parse dữ liệu
                request.setAttribute("ms", "Invalid input data!");
            } catch (SQLException e) {
                // Xử lý lỗi liên quan đến cơ sở dữ liệu
                request.setAttribute("ms", "Error saving feedback. Please try again later.");
            }

            // Redirect về lại trang order sau khi lưu feedback
            response.sendRedirect("order");
        } else {
            // Xử lý các request POST khác (nếu có)
            processRequest(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

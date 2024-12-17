/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CartDAO;
import dal.OrderDAO;
import dal.OrderDetailDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Customer;
import model.OrderDetail;
import utility.UtilityMail;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "VNPayCheckout", urlPatterns = {"/vnpay_checkout"})
public class VNPayCheckout extends HttpServlet {

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
        try {
            OrderDAO odao = new OrderDAO();
            CartDAO cartdao = new CartDAO();
            UtilityMail um = new UtilityMail();
            HttpSession session = request.getSession();
            Customer acc = (Customer) session.getAttribute("account");
            if (acc != null) {
                String responseCode = request.getParameter("vnp_ResponseCode");
                if ("00".equals(responseCode)) {
                    String orderId = request.getParameter("orderId");
                    odao.changePaymentStatus(Integer.parseInt(orderId), true);
                    cartdao.deleteCartByCustomerId(acc.getId());
                    String recipient = acc.getEmail();
                    String subject = "Order Confirmation - Perfume Paradise";
                    String purpose = "order_confirmation";
                    String customerName = acc.getFullname();

                    um.sendCustomEmail(recipient, subject, purpose, customerName, orderId);
                    response.sendRedirect("cartComplete?id=" + orderId);
                } else {
                    //thanh toan fail

                    request.getRequestDispatcher("fail.jsp").forward(request, response);

                }
            }
//            else {
//                request.getRequestDispatcher("login").forward(request, response);
//            }
        } catch (Exception e) {
            System.out.println("error");
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
        processRequest(request, response);
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
        processRequest(request, response);
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

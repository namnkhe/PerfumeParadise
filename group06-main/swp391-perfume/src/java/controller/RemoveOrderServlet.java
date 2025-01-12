/*
                                                     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
                                                     * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CartDAO;
import dal.OrderDAO;
import dal.OrderDetailDAO;
import dal.PerfumeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.CartDetail;
import model.OrderDetail;
import model.Perfume;

/**
 *
 * @author DELL
 */
public class RemoveOrderServlet extends HttpServlet {

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
            out.println("<title>Servlet RemoveOrderServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RemoveOrderServlet at " + request.getContextPath() + "</h1>");
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
        int id = Integer.parseInt(request.getParameter("id"));

        // Lấy danh sách chi tiết đơn hàng trước
        OrderDetailDAO odd = new OrderDetailDAO();
        List<OrderDetail> list = odd.getOrderDetailsByOrderID(id);

        // Xóa chi tiết đơn hàng
        odd.removeOrderDetailByOid(id);

        // Xóa đơn hàng
        OrderDAO od = new OrderDAO();
        od.removeOrderById(id);

        // Cập nhật hold cho từng sản phẩm
        PerfumeDAO pd = new PerfumeDAO();
        for (OrderDetail orderDetail : list) {
            Perfume perfume = orderDetail.getPerfume();
            // Cập nhật hold cho sản phẩm
            pd.updateHold(perfume.getId(), perfume.getHold() - orderDetail.getQuantity());
        }

        // Điều hướng lại về trang danh sách đơn hàng
        response.sendRedirect("order");
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

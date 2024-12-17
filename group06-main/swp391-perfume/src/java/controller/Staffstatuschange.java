/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.OrderDAO;
import dal.OrderDetailDAO;
import dal.PerfumeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.OrderDetail;
import model.Perfume;

/**
 *
 * @author DELL
 */
public class Staffstatuschange extends HttpServlet {

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
            out.println("<title>Servlet ChangeOrderStatusServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangeOrderStatusServlet at " + request.getContextPath() + "</h1>");
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
        String newStatus = request.getParameter("new_status");
        OrderDAO od = new OrderDAO();
        od.changeOrderStatusById(id, newStatus);
        if (newStatus.equals("denied")) {
            //change quantity of perfume
            OrderDetailDAO odd = new OrderDetailDAO();
            List<OrderDetail> list = odd.getOrderDetailsByOrderID(id);
            PerfumeDAO pd = new PerfumeDAO();
            Perfume p = new Perfume();
            for (OrderDetail orderDetail : list) {
                p = orderDetail.getPerfume();
//                pd.UpdatePerfume1(p.getId(), p.getName(), p.getPrice(), p.getSize(), p.getQuantity() +orderDetail.getQuantity(), p.getCategory().getId(), p.getBrand().getId());
            }
        }
        if (newStatus.equals("preparing")) {
            //change quantity of perfume
            OrderDetailDAO odd = new OrderDetailDAO();
            List<OrderDetail> list = odd.getOrderDetailsByOrderID(id);
            PerfumeDAO pd = new PerfumeDAO();
            Perfume p = new Perfume();
            for (OrderDetail orderDetail : list) {
                p = orderDetail.getPerfume();
                pd.UpdatePerfume1(p.getId(), p.getName(), p.getPrice(), p.getSize(), p.getQuantity() - orderDetail.getQuantity(), p.getCategory().getId(), p.getBrand().getId());
            }
        }
        response.sendRedirect("Staff");
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
        return "Change order status and update perfume stock if needed";
    }// </editor-fold>

}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.PerfumeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Perfume;
import java.sql.Date;
import java.util.List;

/**
 *
 * @author DELL
 */
public class SearchProductServlet extends HttpServlet {

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
            out.println("<title>Servlet SearchProductServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SearchProductServlet at " + request.getContextPath() + "</h1>");
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
        int u = Integer.parseInt(request.getParameter("u"));
        String bid_raw = request.getParameter("bid");
        String cid_raw = request.getParameter("cid");
        String minimumprice_raw = request.getParameter("minimumprice");
        String maximumprice_raw = request.getParameter("maximumprice");
        String fromdate_raw = request.getParameter("fromdate");
        String todate_raw = request.getParameter("todate");
        try {
            Double minimumprice = (minimumprice_raw == null || minimumprice_raw.trim().isEmpty()) ? null : Double.parseDouble(minimumprice_raw);
            Double maximumprice = (maximumprice_raw == null || maximumprice_raw.trim().isEmpty()) ? null : Double.parseDouble(maximumprice_raw);
            Integer bid = (bid_raw == null || bid_raw.trim().isEmpty()) ? null : Integer.parseInt(bid_raw);
            Integer cid = (cid_raw == null || cid_raw.trim().isEmpty()) ? null : Integer.parseInt(cid_raw);
            Date fromdate = (fromdate_raw == null || fromdate_raw.trim().isEmpty()) ? null : Date.valueOf(fromdate_raw);
            Date todate = (todate_raw == null || todate_raw.trim().isEmpty()) ? null : Date.valueOf(todate_raw);
            PerfumeDAO p = new PerfumeDAO();
            List<Perfume> products = p.getPerfumeByFilter(cid, bid, minimumprice, maximumprice, fromdate, todate);
            request.setAttribute("list", products);
            //chuyen trang admin or customer
            if (u == 1) {
                request.getRequestDispatcher("adminsearch.jsp").forward(request, response);
            }
            if (u == 0) {
                request.getRequestDispatcher("search.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
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

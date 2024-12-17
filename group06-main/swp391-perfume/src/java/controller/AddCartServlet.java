/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CartDAO;
import dal.FeedBackDAO;
import dal.PerfumeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.CartDetail;
import model.Customer;
import model.Feedback;
import model.Perfume;

/**
 *
 * @author DELL
 */
public class AddCartServlet extends HttpServlet {

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
            out.println("<title>Servlet AddCartServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddCartServlet at " + request.getContextPath() + "</h1>");
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
        String pid_raw = request.getParameter("pid");
        HttpSession session = request.getSession();
        Customer c = (Customer) session.getAttribute("account");
        CartDAO cartdao = new CartDAO();
        List<CartDetail> cart = cartdao.getCartDetailsByCusId(c.getId());
        int pid = Integer.parseInt(pid_raw);
        PerfumeDAO pdao = new PerfumeDAO();
        Perfume p = pdao.getPerfumeById(pid);
        FeedBackDAO dao = new FeedBackDAO();
        List<Feedback> feedList = dao.feedBackForm(pid);

        //check if quantity=0
        if (p.getAvailableQuantity() <= 0) {
            request.setAttribute("ms", "No item available");
            request.getRequestDispatcher("itemdetail.jsp").forward(request, response);
            return;
        } else if (!checkCartDetailInCart(p, cart)) {
            cartdao.addPerfume(c.getId(), pid, 1);
            request.setAttribute("ms", "Add to cart successfully");
        }
        request.setAttribute("feedList", feedList);
        request.setAttribute("perfume", p);
        request.getRequestDispatcher("itemdetail.jsp").forward(request, response);
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

    private boolean checkCartDetailInCart(Perfume p, List<CartDetail> cart) {
        for (CartDetail cartDetail : cart) {
            if (cartDetail.getPerfume().getId() == p.getId()) {
                return true;
            }
        }
        return false;
    }

}

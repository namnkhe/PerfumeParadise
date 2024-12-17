/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.AdminDAO12;
import dal.BrandDAO;
import dal.CategoryDAO;
import dal.CustomerDAO;
import dal.OrderDAO;
import dal.OrderDetailDAO;
import dal.PerfumeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.Brand;
import model.Category;
import model.Perfume;
import model.Selling;
import model.Stock;

/**
 *
 * @author ADMIN
 */
public class SaleManager extends HttpServlet {

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
            out.println("<title>Servlet Salemanager</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Salemanager at " + request.getContextPath() + "</h1>");
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
//          BrandDAO bd = new BrandDAO();
//        List<Brand> listBrand = new ArrayList<>();
//        listBrand = bd.getAllBrand();
//        CategoryDAO cd = new CategoryDAO();
//        List<Category> listC = new ArrayList<>();
//        listC = cd.getAllCategory();
//        PerfumeDAO pd = new PerfumeDAO();
//        List<Perfume> listP = new ArrayList<>();
//        String brandId = request.getParameter("bid");
//        String categoryId = request.getParameter("cid");
//        HttpSession session = request.getSession();
//        session.setAttribute("listC", listC);
//        session.setAttribute("listB", listBrand);
//        List<Perfume> perfumes=pd.getAllPerfume();
//        session.setAttribute("listP", perfumes);
//        request.getRequestDispatcher("salemanagerhome.jsp").forward(request, response);
//    OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
//        AdminDAO12 adminDAO = new AdminDAO12();
// String startDate = request.getParameter("startDate"); // Lấy startDate từ tham số request
//        String endDate = request.getParameter("endDate"); // Lấy endDate từ tham số request
// List<Selling> salesData = adminDAO.getSalesBetweenDates(startDate, endDate); // Lấy dữ liệu doanh thu trong khoảng thời gian
//        
//        // Chuyển dữ liệu sang JSP
//        request.setAttribute("salesData", salesData); // Gửi dữ liệu vào JSP
//        // Fetch total sales data
//        int totalCustomersCount = adminDAO.getTotalCustomers();
//        int totalProductsCount = adminDAO.getTotalProducts();
//        int totalOrdersCount = adminDAO.getTotalOrders(); // Optionally get the total number of orders
//       int totalRevenueAmount = orderDetailDAO.totalPrice();
//
//        // Set attributes for the JSP page
//        request.setAttribute("totalRevenueAmount", totalRevenueAmount);
//        request.setAttribute("totalCustomersCount", totalCustomersCount);
//        request.setAttribute("totalProductsCount", totalProductsCount);
//        request.setAttribute("totalOrdersCount", totalOrdersCount);
//     
        PerfumeDAO pd = new PerfumeDAO();
        request.setAttribute("pcount", pd.count());
        CustomerDAO cd = new CustomerDAO();
        request.setAttribute("ccount", cd.count());
        OrderDAO od = new OrderDAO();
        request.setAttribute("ocount", od.count());
        OrderDetailDAO odd = new OrderDetailDAO();
        request.setAttribute("totalprice", odd.totalPrice());
        List<Stock> stocks = odd.topStock();
        request.setAttribute("stocks", stocks);
        List<Selling> sellings = odd.sellingRecent();
        request.setAttribute("sellings", sellings);

        // Forward the request to the sales overview page for display
        request.getRequestDispatcher("salemanagerhome.jsp").forward(request, response);
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

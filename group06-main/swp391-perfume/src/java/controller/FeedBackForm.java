/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.FeedBackDAO;
import dal.PerfumeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import model.Feedback;
import model.Perfume;

/**
 *
 * @author phida
 */
@WebServlet(name = "FeedBackForm", urlPatterns = {"/FeedBackForm"})
public class FeedBackForm extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productIdParam = request.getParameter("pid");

        // Kiểm tra xem productIdParam có hợp lệ hay không
        if (productIdParam != null && !productIdParam.isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdParam);

                // Khởi tạo DAO
                PerfumeDAO pDao = new PerfumeDAO();
                FeedBackDAO fDao = new FeedBackDAO();

                // Lấy thông tin sản phẩm theo ID
                Perfume perfume = pDao.getPerfumeById(productId);

                // Lấy danh sách feedback cho sản phẩm này
                ArrayList<Feedback> feedbackList = fDao.feedBackForm(productId);

                // Kiểm tra xem có sản phẩm và phản hồi không
                if (perfume != null) {
                    // Đặt thông tin vào request
                    request.setAttribute("perfume", perfume);
                    request.setAttribute("feedbackList", feedbackList);

                    // Chuyển tiếp đến JSP
                    request.getRequestDispatcher("/productDetail.jsp").forward(request, response);
                } else {
                    // Xử lý trường hợp không tìm thấy sản phẩm
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found.");
                }
            } catch (NumberFormatException e) {
                // Xử lý lỗi định dạng số
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID format.");
            } catch (Exception e) {
                // Xử lý các lỗi khác
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request.");
            }
        } else {
            // Xử lý trường hợp không có productIdParam
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID is required.");
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
        response.setContentType("text/html;charset=UTF-8");
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

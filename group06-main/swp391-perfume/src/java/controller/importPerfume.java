package controller;

import dal.PerfumeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class importPerfume extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet importPerfume</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet importPerfume at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy các tham số từ request
        String productIdStr = request.getParameter("productId");
        String importPriceStr = request.getParameter("importPrice");
        String sizeStr = request.getParameter("size");
        String quantityStr = request.getParameter("quantity");

        try {
            // Kiểm tra và chuyển đổi các tham số sang kiểu dữ liệu phù hợp
            int productId = (productIdStr != null && !productIdStr.isEmpty()) ? Integer.parseInt(productIdStr) : 0;
            double importPrice = (importPriceStr != null && !importPriceStr.isEmpty()) ? Double.parseDouble(importPriceStr) : 0.0;
            int size = (sizeStr != null && !sizeStr.isEmpty()) ? Integer.parseInt(sizeStr) : 0;
            int quantity = (quantityStr != null && !quantityStr.isEmpty()) ? Integer.parseInt(quantityStr) : 0;

            // Kiểm tra nếu các giá trị cần thiết hợp lệ
            if (productId > 0 && importPrice > 0 && size > 0 && quantity > 0) {
                // Cập nhật số lượng sản phẩm trong kho
                PerfumeDAO pd = new PerfumeDAO();
                pd.importPerfume(productId, importPrice, size, quantity);

                // Chuyển hướng lại trang quản lý kho
                response.sendRedirect("inventoryManagement.jsp");
            }
        } catch (NumberFormatException e) {
            // Xử lý lỗi khi chuyển đổi dữ liệu không thành công
            request.setAttribute("error", "Định dạng dữ liệu không hợp lệ. Vui lòng nhập lại.");
            request.getRequestDispatcher("importPerfume.jsp").forward(request, response);
        }
    }
}

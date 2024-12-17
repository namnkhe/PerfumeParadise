package controller;

import dal.OrderDetailDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Selling;
import model.Stock;

public class MarketingDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderDetailDAO orderDetailDAO = new OrderDetailDAO();

        // Lấy tổng doanh thu
        int totalRevenue = orderDetailDAO.totalPrice();
        request.setAttribute("totalRevenue", totalRevenue);

        // Lấy dữ liệu bán hàng gần đây (7 ngày gần nhất)
        List<Selling> sellingRecent = orderDetailDAO.sellingRecent();
        request.setAttribute("sellingRecent", sellingRecent);

        // Lấy danh sách các sản phẩm bán chạy nhất (top 3)
        List<Stock> topStock = orderDetailDAO.topStock();
        request.setAttribute("topStock", topStock);

        // Chuyển hướng đến trang JSP để hiển thị
        request.getRequestDispatcher("adminhome.jsp").forward(request, response);
    }
}

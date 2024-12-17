package controller;

import dal.AdminDAO12;
import dal.FeedBackDAO;
import dal.OrderDetailDAO;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Selling;
import model.Stock;
import java.sql.Date;

public class AdminServlet12 extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Tạo đối tượng DAO để thao tác với dữ liệu
        OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
        AdminDAO12 adminDAO = new AdminDAO12();
        FeedBackDAO fb = new FeedBackDAO();
        // Lấy dữ liệu từ form tìm kiếm
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        List<Selling> sellingRecent;
        List<Stock> topStock;

        // Khởi tạo định dạng ngày
        SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
        Date startDate = null;
        Date endDate = null;

        // Kiểm tra nếu người dùng nhập khoảng thời gian tìm kiếm
        if (startDateStr != null && !startDateStr.isEmpty() && endDateStr != null && !endDateStr.isEmpty()) {
            try {
                // Chuyển đổi String sang Date
                startDate = new Date(sdf.parse(startDateStr).getTime());
                endDate = new Date(sdf.parse(endDateStr).getTime());

                // Lấy dữ liệu bán hàng và sản phẩm bán chạy trong khoảng thời gian tìm kiếm
                sellingRecent = adminDAO.getSalesBetweenDates(startDateStr, endDateStr);
                topStock = adminDAO.getTopStockBetweenDates(startDateStr, endDateStr);

            } catch (ParseException e) {
                e.printStackTrace();
                // Trong trường hợp lỗi, có thể xử lý và hiển thị thông báo lỗi cho người dùng
                request.setAttribute("errorMessage", "Invalid date format. Please use MM/dd/yyyy.");
                sellingRecent = adminDAO.getAllSales(); // Default to all sales
                topStock = adminDAO.getAllTopStock(); // Default to all top stock
            }

        } else {
            // Nếu không có tìm kiếm thì lấy toàn bộ dữ liệu
            sellingRecent = adminDAO.getAllSales();
            topStock = adminDAO.getAllTopStock();
        }

        // Lấy tổng doanh thu
        int totalCustomers = adminDAO.getTotalCustomers();
        int totalProducts = adminDAO.getTotalProducts();
        int totalOrders = adminDAO.getTotalOrders(); // Optionally get the total number of orders
        int totalPosts = 15; // Placeholder value
        int totalFeedbacks = fb.countAllFeedback(); // Placeholder value
        int totalRevenue = orderDetailDAO.totalPrice();
        request.setAttribute("totalRevenue", totalRevenue);

        // Lưu dữ liệu bán hàng gần đây và sản phẩm bán chạy nhất vào request
        request.setAttribute("sellingRecent", sellingRecent);
        request.setAttribute("topStock", topStock);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalPosts", totalPosts); // Placeholder
        request.setAttribute("totalFeedbacks", totalFeedbacks); // Placeholder
        // Chuyển hướng đến trang JSP để hiển thị
        request.getRequestDispatcher("adminhome.jsp").forward(request, response);
    }
}

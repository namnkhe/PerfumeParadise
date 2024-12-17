package controller;

import dal.PerfumeDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class InventoryUpdateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PerfumeDAO pd = new PerfumeDAO();
        int id = Integer.parseInt(request.getParameter("id"));
        request.setAttribute("item", pd.getPerfumeById(id)); // Lấy thông tin sản phẩm, bao gồm cả description
        request.getRequestDispatcher("inventoryupdateperfume.jsp").forward(request, response); // Chuyển tiếp đến trang JSP để hiển thị
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        int price = Integer.parseInt(request.getParameter("price"));
        int size = Integer.parseInt(request.getParameter("size"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int hold = Integer.parseInt(request.getParameter("hold")); // Lấy giá trị hold
        int importPrice = Integer.parseInt(request.getParameter("importPrice")); // Lấy giá trị importPrice
        String description = request.getParameter("description"); // Lấy thông tin description từ form

        // Cập nhật sản phẩm trong CSDL bao gồm cả description
        PerfumeDAO pd = new PerfumeDAO();
        pd.updatePerfumeForInventoryStaff(id, quantity, hold, importPrice, price, size);

        // Chuyển hướng sau khi cập nhật thành công
        response.sendRedirect("inventoryupdate?id=" + id);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for updating Perfume information including description";
    }
}

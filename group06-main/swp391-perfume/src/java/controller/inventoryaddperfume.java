package controller;

import dal.BrandDAO;
import dal.CategoryDAO;
import dal.PerfumeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.sql.Date;
import java.util.List;

@MultipartConfig
public class inventoryaddperfume extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách các Category và Brand
        CategoryDAO cdao = new CategoryDAO();
        BrandDAO bdao = new BrandDAO();

        // Truyền danh sách sang JSP
        request.setAttribute("listC", cdao.getAllCategory());
        request.setAttribute("listB", bdao.getAllBrand());

        // Chuyển tiếp đến trang addperfume.jsp
        request.getRequestDispatcher("inventoryaddperfume.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy các giá trị từ form
        String name = request.getParameter("name");
        int price = Integer.parseInt(request.getParameter("price"));
        int size = Integer.parseInt(request.getParameter("size"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int cid = Integer.parseInt(request.getParameter("cid"));
        int bid = Integer.parseInt(request.getParameter("bid"));
        String releaseDate_raw = request.getParameter("releaseDate");
        Date releaseDate = Date.valueOf(releaseDate_raw);

        // Lấy description từ form
        String description = request.getParameter("description");

        // Xử lý phần ảnh
        Part image = request.getPart("image");
        String path = request.getServletContext().getRealPath("/") + "images/perfume" + File.separator
                + image.getSubmittedFileName();
        try {
            FileOutputStream fos = new FileOutputStream(path);
            InputStream is = image.getInputStream();
            byte[] data = new byte[is.available()];
            is.read(data);
            fos.write(data);
            fos.flush();
            fos.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Gọi DAO để thêm sản phẩm
        PerfumeDAO pd = new PerfumeDAO();
        pd.addPerfume(name, price, size, quantity, cid, bid, releaseDate, image.getSubmittedFileName(), description);

        // Chuyển hướng về trang admin sau khi thêm thành công
        response.sendRedirect("Inventory");
    }

    @Override
    public String getServletInfo() {
        return "Servlet for adding new perfume";
    }
}

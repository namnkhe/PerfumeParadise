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
public class Saleupdateperfume extends HttpServlet {

    @Override

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        processRequest(request, response);
        request.getRequestDispatcher("addperfume.jsp").forward(request, response);
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

        String name = request.getParameter("name");
        int price = Integer.parseInt(request.getParameter("price"));
        int size = Integer.parseInt(request.getParameter("size"));
        int cid = Integer.parseInt(request.getParameter("cid"));
        int bid = Integer.parseInt(request.getParameter("bid"));
        String releaseDate_raw = request.getParameter("releaseDate");
        Date releaseDate = Date.valueOf(releaseDate_raw);

        // Lấy giá trị của description từ request
        String description = request.getParameter("description");

        // Lưu file hình ảnh và lấy tên file
        Part image = request.getPart("image");
        String fileName = image.getSubmittedFileName();
        String path = request.getServletContext().getRealPath("/") + "images/perfume" + File.separator + fileName;

        try {
            // Lưu file hình ảnh vào thư mục chỉ định
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

        // Gọi phương thức DAO với đúng thứ tự tham số
        PerfumeDAO pd = new PerfumeDAO();
        pd.addPerfume1(name, price, size, cid, bid, releaseDate, fileName, description); // truyền tên file và description vào

        response.sendRedirect("Sales");
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

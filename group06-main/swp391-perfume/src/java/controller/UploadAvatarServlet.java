package controller;

import dal.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import model.Customer;

@WebServlet(name = "UploadAvatarServlet", urlPatterns = {"/uploadAvatar"})
@MultipartConfig
public class UploadAvatarServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("account");

        // Kiểm tra xem người dùng đã đăng nhập hay chưa
        if (customer == null) {
            response.sendRedirect("login"); // Redirect to login if not logged in
            return;
        }

        // Nhận phần upload file
        Part filePart = request.getPart("avatar"); // Nhận ảnh từ form

        // Kiểm tra nếu người dùng không chọn file
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("mess", "Please select an image file.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        // Kiểm tra định dạng file
        String mimeType = filePart.getContentType();
        if (!mimeType.startsWith("image/")) {
            request.setAttribute("mess", "Uploaded file is not an image.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); // Lấy tên file
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads"; // Đường dẫn đến thư mục lưu trữ

        // Tạo thư mục nếu không tồn tại
        File uploads = new File(uploadPath);
        if (!uploads.exists()) {
            uploads.mkdir();
        }

        // Lưu ảnh vào thư mục
        filePart.write(uploadPath + File.separator + fileName);

        // Cập nhật đường dẫn ảnh vào cơ sở dữ liệu
        CustomerDAO customerDAO = new CustomerDAO();
        customerDAO.updateAvatar(customer.getId(), "uploads/" + fileName); // Cập nhật đường dẫn ảnh vào CSDL

        // Cập nhật lại thông tin tài khoản trong phiên
        customer.setImage("uploads/" + fileName);
        session.setAttribute("account", customer);

        // Redirect to profile page
        response.sendRedirect("profile"); // Redirect to profile page
    }
}

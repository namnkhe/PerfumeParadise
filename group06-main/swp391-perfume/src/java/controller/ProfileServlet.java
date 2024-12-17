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
import java.io.PrintWriter;
import java.nio.file.Paths;
import model.Customer;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
@MultipartConfig // Thêm annotation để xử lý file upload
public class ProfileServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet verifyOtpServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet verifyOtpServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CustomerDAO cd = new CustomerDAO();
        HttpSession session = request.getSession();

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String gender = request.getParameter("gender");

        Customer c = (Customer) session.getAttribute("account");

        try {
            int id = c.getId();

            // Kiểm tra định dạng số điện thoại
            if (phone == null || phone.isEmpty() || !phone.matches("\\d{10}")) {
                request.setAttribute("mess", "Wrong phone format! Phone number must be 10 digits.");
                request.getRequestDispatcher("profile.jsp").forward(request, response);
                return;
            }

            // Kiểm tra tên người dùng
            if (!username.equals(c.getUsername()) && cd.getCustomerByUsername(username) != null) {
                request.setAttribute("mess", "Username exists. Choose another username!");
                request.getRequestDispatcher("profile.jsp").forward(request, response);
                return;
            }

            // Kiểm tra email
            if (!email.equalsIgnoreCase(c.getEmail()) && cd.checkEmailExist(email)) {
                request.setAttribute("mess", "Email exists. Choose another email!");
                request.getRequestDispatcher("profile.jsp").forward(request, response);
                return;
            }

            // Xử lý tải lên ảnh đại diện
            Part filePart = request.getPart("avatar"); // Nhận ảnh từ form
            String avatarPath = null;

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); // Lấy tên file
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads"; // Đường dẫn đến thư mục lưu trữ

                // Tạo thư mục nếu không tồn tại
                File uploads = new File(uploadPath);
                if (!uploads.exists()) {
                    uploads.mkdir();
                }

                // Lưu ảnh vào thư mục
                filePart.write(uploadPath + File.separator + fileName);
                avatarPath = "uploads/" + fileName; // Đường dẫn tới file ảnh
            }

            // Cập nhật thông tin người dùng
            boolean profileUpdated = cd.updateProfile(id, username, name, phone, email, address, gender); // Cập nhật thông tin
            if (!profileUpdated) {
                request.setAttribute("mess", "Failed to update user profile. Please try again.");
                request.getRequestDispatcher("profile.jsp").forward(request, response);
                return;
            }

            if (avatarPath != null) {
                // Nếu có avatar mới, cập nhật đường dẫn vào cơ sở dữ liệu
                boolean avatarUpdated = cd.updateAvatar(id, avatarPath);
                if (!avatarUpdated) {
                    request.setAttribute("mess", "Failed to update avatar. Please try again.");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                    return;
                }
            }

            // Cập nhật lại thông tin tài khoản trong phiên
            Customer updatedCustomer = cd.getByCusId(c.getId());
            updatedCustomer.setImage(avatarPath != null ? avatarPath : updatedCustomer.getImage()); // Cập nhật avatar
            session.setAttribute("account", updatedCustomer);
            request.setAttribute("mess", "Updated Successfully");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace(); // Ghi lại lỗi
            request.setAttribute("mess", "Error updating profile: " + e.getMessage());
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for updating user profile.";
    }
}

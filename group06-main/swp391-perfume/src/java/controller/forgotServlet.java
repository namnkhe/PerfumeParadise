package controller;

import dal.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

public class forgotServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("forgot.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String customerEmail = (String) session.getAttribute("email"); // Retrieve email from session
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Check if email is null (in case the session has expired or user skipped OTP)
        if (customerEmail == null) {
            request.setAttribute("errorMessage", "Session expired. Please request password reset again.");
            request.getRequestDispatcher("forgot.jsp").forward(request, response);
            return;
        }

        // Validate that the new password and confirmation match
        if (newPassword == null || newPassword.isEmpty() || !newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match or are empty.");
            request.getRequestDispatcher("forgot.jsp").forward(request, response);
            return;
        }

        try {
            // Hash the new password before storing it
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

            // Update password in the database
            CustomerDAO cdao = new CustomerDAO();
            cdao.changePassword(customerEmail, hashedPassword);

            // Redirect to login page with a success message in session
            session.setAttribute("successMessage", "Password reset successful. Please log in.");
            response.sendRedirect("login");

        } catch (Exception e) {
            // Handle potential errors during password change
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("forgot.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for resetting user password.";
    }
}

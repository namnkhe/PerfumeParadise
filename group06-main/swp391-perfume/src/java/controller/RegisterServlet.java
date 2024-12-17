package controller;

import dal.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import org.mindrot.jbcrypt.BCrypt;
import utility.UtilityMail;

/**
 * Servlet for handling user registration.
 */
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Retrieve parameters from the request
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullname = request.getParameter("fullname");
            String gender = request.getParameter("gender");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            CustomerDAO cdao = new CustomerDAO();
            UtilityMail um = new UtilityMail();
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            // Check if the email already exists
            if (cdao.checkEmailExist(email)) {
                request.setAttribute("registerError", "Email exists. Choose another email!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Validate phone number format
            if (!phone.matches("\\d{10}")) {
                request.setAttribute("registerError", "Wrong phone format! Must be 10 digits.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            boolean status = false;

            // Add the new user
            if (cdao.insertUser(username, hashedPassword, fullname, phone, email, address, gender, status)) {
                // Mask the email for display
                String maskedEmail = um.maskEmail(email);

                // Set OTP-related message and generate OTP
                HttpSession session = request.getSession();
                String otpCode = um.generateOtpCode();
                String otpMessage = "We just sent an OTP to your email " + maskedEmail + ". The OTP will expire in 30 minutes.";

                // Store OTP and timestamp in the session for later verification
                session.setAttribute("otp", otpCode);
                session.setAttribute("otpCreationTime", LocalDateTime.now());
                session.setAttribute("email", email);
                session.setAttribute("purpose", "activate");

                // Attempt to send the OTP email
                try {
                    um.sendOtpEmail(email, otpCode, "activate");  // Send OTP email with the activation purpose

                    // Redirect to OTP verification page with success message
                    request.setAttribute("message", otpMessage);
                    request.setAttribute("type", "info");
                    request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);

                } catch (Exception e) {
                    // Handle any error that occurs during email sending
                    request.setAttribute("registerError", "Failed to send OTP email. Please try again.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                }
            } else {
                // Handle case where user creation fails
                request.setAttribute("registerError", "Something went wrong! Failed to create account.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (ServletException | IOException e) {
            e.printStackTrace();
            request.setAttribute("registerError", "An error occurred. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    /**
     * Masks the email, showing only the first character and domain.
     */
    @Override
    public String getServletInfo() {
        return "Servlet for user registration.";
    }
}

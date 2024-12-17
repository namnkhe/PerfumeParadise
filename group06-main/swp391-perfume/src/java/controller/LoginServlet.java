package controller;

import dal.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import model.Customer;
import org.mindrot.jbcrypt.BCrypt;
import utility.UtilityMail;

/**
 * Servlet for handling user login and password reset.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("account") == null) {
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String providedPassword = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");
        String forgot = request.getParameter("forgot");

        CustomerDAO cdao = new CustomerDAO();
        Customer customer = cdao.getCustomerByEmail(email);
        HttpSession session = request.getSession();
        UtilityMail mailUtility = new UtilityMail();

        if (forgot != null) {
            handleForgotPassword(request, response, session, email, customer, cdao, mailUtility);
            return;
        }

        handleLogin(request, response, session, email, providedPassword, rememberMe, customer, cdao, mailUtility);
    }

    /**
     * Handles the forgot password flow by sending an OTP for password reset.
     */
    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            String email, Customer customer, CustomerDAO cdao, UtilityMail mailUtility)
            throws ServletException, IOException {
        try {
            if (customer != null) {
                if (!cdao.checkActive(email)) {
                    request.setAttribute("error", "Your account is inactive. Please log in again to reactivate.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                // Mask the email for display
                String maskedEmail = mailUtility.maskEmail(email);
                String otpMessage = "We just sent an OTP to your email " + maskedEmail + ". Please use it to reset your password within 30 minutes.";

                // Generate OTP and set it in the session along with the creation time
                String otpCode = mailUtility.generateOtpCode();
                session.setAttribute("otp", otpCode);
                session.setAttribute("otpCreationTime", LocalDateTime.now());
                session.setAttribute("email", email);
                session.setAttribute("purpose", "reset");

                // Send OTP email for password reset
                mailUtility.sendOtpEmail(email, otpCode, "reset");

                // Forward to OTP verification page with success message
                request.setAttribute("message", otpMessage);
                request.setAttribute("type", "info");
                request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Invalid email for password reset.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    /**
     * Handles user login with optional account activation if required.
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            String email, String providedPassword, String rememberMe, Customer customer,
            CustomerDAO cdao, UtilityMail mailUtility) throws ServletException, IOException {
        try {
            if (customer != null) {
                String storedHashedPassword = customer.getPassword();
                if (BCrypt.checkpw(providedPassword, storedHashedPassword)) {
                    if (!cdao.checkActive(email)) {
                        // Mask the email for display
                        String maskedEmail = mailUtility.maskEmail(email);
                        String otpMessage = "Your account is not yet activated. An OTP has been sent to " + maskedEmail
                                + " for verification. The OTP will expire in 30 minutes.";

                        // Generate OTP and set it in the session along with the creation time
                        String otpCode = mailUtility.generateOtpCode();
                        session.setAttribute("otp", otpCode);
                        session.setAttribute("otpCreationTime", LocalDateTime.now());
                        session.setAttribute("email", email);
                        session.setAttribute("purpose", "activate");

                        // Send OTP email for account activation
                        mailUtility.sendOtpEmail(email, otpCode, "activate");

                        // Forward to OTP verification page with success message
                        request.setAttribute("message", otpMessage);
                        request.setAttribute("type", "info");
                        request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
                    } else {
                        // Complete login if account is active
                        completeLogin(request, response, session, email, rememberMe, customer);
                    }
                } else {
                    // Invalid password
                    request.setAttribute("error", "Invalid email or password.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                // Customer not found
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    /**
     * Completes the login process and handles "Remember Me" functionality.
     */
    private void completeLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            String email, String rememberMe, Customer customer)
            throws IOException {
        session.setAttribute("account", customer);

        if ("on".equals(rememberMe)) {
            Cookie emailCookie = new Cookie("email", email);
            emailCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
            response.addCookie(emailCookie);
        }

        response.sendRedirect("home"); // Redirect to the home page
    }

    @Override
    public String getServletInfo() {
        return "Servlet for handling user login and password reset.";
    }
}

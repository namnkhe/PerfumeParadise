package utility;

import dal.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Properties;
import java.util.Random;

/**
 * Utility class for OTP generation, email sending, and OTP verification.
 */
public class UtilityMail {

    private static final String FROM_EMAIL = "wuguangyao98@gmail.com";
    private static final String FROM_PASSWORD = "gdiqszxjoazurdkv";
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int SMTP_PORT = 587;

    /**
     * Generates a 6-digit OTP code.
     *
     * @return A 6-digit OTP code as a string.
     */
    public String generateOtpCode() {
        Random rand = new Random();
        int number = rand.nextInt(999999);
        return String.format("%06d", number);
    }

    /**
     * Sends an OTP verification email.
     *
     * @param toEmail Recipient's email address.
     * @param otpCode OTP code to be sent in the email.
     * @param purpose Purpose of the OTP (e.g., "activate", "reset", "resend").
     */
    public void sendOtpEmail(String toEmail, String otpCode, String purpose) {
        String emailContent = buildOtpEmailContent(otpCode, purpose);
        sendEmail(toEmail, "OTP Verification", emailContent);
    }

    /**
     * Sends a customized email based on purpose.
     *
     * @param toEmail Recipient's email address.
     * @param subject Email subject.
     * @param purpose Purpose of the email.
     * @param variables Additional information for the email.
     */
    public void sendCustomEmail(String toEmail, String subject, String purpose, String... variables) {
        String emailContent = buildEmailContent(purpose, variables);
        sendEmail(toEmail, subject, emailContent);
    }

    /**
     * Resends a new OTP to the user's email and updates the session.
     *
     * @param request HttpServletRequest object.
     * @param response HttpServletResponse object.
     * @param session HttpSession object.
     */
    public void resendOtp(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        String newOtp = generateOtpCode();
        session.setAttribute("otp", newOtp);
        session.setAttribute("otpCreationTime", LocalDateTime.now());

        String email = (String) session.getAttribute("email");
        sendOtpEmail(email, newOtp, "resend");

        String maskedEmail = maskEmail(email);
        request.setAttribute("message", "A new OTP has been sent to your email " + maskedEmail + ". The OTP will expire in 30 minutes.");
        request.setAttribute("type", "info");
        request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
    }

    /**
     * Verifies the OTP entered by the user.
     *
     * @param request HttpServletRequest object.
     * @param response HttpServletResponse object.
     * @param session HttpSession object.
     */
    public void verifyOtp(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        String enteredOtp = request.getParameter("otp");
        String sessionOtp = (String) session.getAttribute("otp");
        LocalDateTime otpCreationTime = (LocalDateTime) session.getAttribute("otpCreationTime");

        if (isOtpExpired(otpCreationTime)) {
            request.setAttribute("message", "OTP has expired. Please request a new one.");
            request.setAttribute("type", "error");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
            return;
        }

        if (enteredOtp != null && enteredOtp.equals(sessionOtp)) {
            session.removeAttribute("otp");

            String customerEmail = (String) session.getAttribute("email");
            if (customerEmail != null) {
                CustomerDAO cdao = new CustomerDAO();
                if (!cdao.checkActive(customerEmail)) {
                    cdao.updateCustomerStatus(customerEmail, true);
                }
            }

            request.setAttribute("message", "OTP verified successfully. Redirecting you in 5 seconds.");
            request.setAttribute("type", "success");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
        } else {
            request.setAttribute("message", "Invalid OTP. Please try again.");
            request.setAttribute("type", "error");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
        }
    }

    /**
     * Checks if the OTP has expired (30 minutes limit).
     *
     * @param otpCreationTime The time the OTP was created.
     * @return true if expired, otherwise false.
     */
    private boolean isOtpExpired(LocalDateTime otpCreationTime) {
        if (otpCreationTime == null) {
            return true;
        }
        return Duration.between(otpCreationTime, LocalDateTime.now()).toMinutes() > 30;
    }

    /**
     * Builds the HTML content of the OTP verification email based on purpose.
     */
    private String buildOtpEmailContent(String otpCode, String purpose) {
        String title;
        String message;

        switch (purpose.toLowerCase()) {
            case "activate" -> {
                title = "Activate Your Account";
                message = "Thank you for registering with us. Please enter the following code to activate your account:";
            }
            case "reset" -> {
                title = "Reset Your Password";
                message = "We received a request to reset your password. Please enter the following code to proceed:";
            }
            case "resend" -> {
                title = "Verify Your Identity";
                message = "You requested a new OTP. Please enter the following code to verify your identity:";
            }
            default -> {
                title = "Verify Your Identity";
                message = "Please enter the following code to verify your identity:";
            }
        }

        return buildHtmlContent(title, message, otpCode);
    }

    /**
     * Builds the HTML content based on purpose and variables.
     */
    private String buildEmailContent(String purpose, String... variables) {
        String title;
        String message;

        switch (purpose.toLowerCase()) {
            case "order_confirmation" -> {
                title = "Your Order is Confirmed!";
                String name = variables.length > 0 ? variables[0] : "Customer";
                message = "Thank you for your purchase, " + name + "!<br>Your order is being processed and will be on its way soon.";
            }
            case "password_reset" -> {
                title = "Reset Your Password";
                String resetCode = variables.length > 0 ? variables[0] : "N/A";
                message = "We received a request to reset your password. Your reset code is: <b>" + resetCode + "</b>.";
            }
            default -> {
                title = "Notification";
                message = "Hello, we have an update for you.";
            }
        }

        return buildHtmlContent(title, message, variables.length > 0 ? variables[0] : null);
    }

    /**
     * Sends an email with the specified subject and content.
     */
    private void sendEmail(String toEmail, String subject, String content) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", String.valueOf(SMTP_PORT));

        Session mailSession = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(content, "text/html");
            Transport.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Error sending email: " + e.getMessage(), e);
        }
    }

    /**
     * Masks an email for display by replacing characters with asterisks.
     */
    public String maskEmail(String email) {
        int numAsterisks = email.indexOf("@") - 1;
        String maskedSection = "*".repeat(numAsterisks);
        return email.charAt(0) + maskedSection + email.substring(email.indexOf("@"));
    }

    /**
     * Constructs HTML email content.
     */
    private String buildHtmlContent(String title, String message, String otpCode) {
        String otpSection = otpCode != null ? "<div style=\"background-color: #ABC; padding: 10px; letter-spacing: 3px;\"><h1>" + otpCode + "</h1></div>" : "";
        return "<div style=\"width: 50vw; padding: 20px; border: 3px solid black; border-radius: 10px; text-align: center;\">"
                + "<h1>" + title + "</h1><p>" + message + "</p>" + otpSection
                + "<p>If you have any questions, feel free to contact us.</p></div>";
    }
}

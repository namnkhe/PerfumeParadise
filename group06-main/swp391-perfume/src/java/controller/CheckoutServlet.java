/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.sun.nio.sctp.PeerAddressChangeNotification;
import config.Config;
import dal.CartDAO;
import dal.OrderDAO;
import dal.OrderDetailDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import model.CartDetail;
import model.Customer;
import config.Config;
import dal.PerfumeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import model.Address;
import model.Perfume;
import utility.UtilityMail;

/**
 *
 * @author DELL
 */
public class CheckoutServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CheckoutServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CheckoutServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        processRequest(request, response);
        HttpSession session = request.getSession();
        List<CartDetail> cart = (List<CartDetail>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("viewcart");
            return;
        }

        Customer customer = (Customer) session.getAttribute("account");
        int customerID = customer.getId();

        OrderDAO orderDAO = new OrderDAO();
        List<Address> listA = orderDAO.getPastOrderAddressByCusID(customerID);
        System.out.println(listA);
        // Set either past addresses or default address for the request attribute
        if (listA.isEmpty()) {
            request.setAttribute("address", customer.getAddress());
            System.out.println("Address: " + customer.getAddress());
        } else {
            request.setAttribute("listA", listA);
            System.out.println("Past Address: " + listA);
        }

        request.getRequestDispatcher("checkout.jsp").forward(request, response);

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
//        processRequest(request, response);

        String paymentMethod = request.getParameter("paymentMethod");
        OrderDAO odao = new OrderDAO();
        HttpSession session = request.getSession();
        Customer c = (Customer) session.getAttribute("account");
        String address = request.getParameter("address"); // Retrieve final address from the hidden input

        if (address == null || address.isEmpty()) {
            System.out.println("Error: Address is empty.");
            // Add handling for empty address if necessary

        } else {
            System.out.println("Billing address: " + address);
            if ("other".equals(address)) {
                address = request.getParameter("newAddressInput"); // Custom address if "Add new address" was selected
                System.out.println("Custom address provided: " + address);
            }
        }

        System.out.println("Billing address: " + address);

        // Ensure address selection is processed correctly
        int id = 1 + odao.getLastOrderId();
        PerfumeDAO pdao = new PerfumeDAO();
        UtilityMail um = new UtilityMail();
        if (paymentMethod.equals("COD")) {

            // Payment method is COD
            odao.insertOrder(id, c.getId(), address, "COD", true, id);
            CartDAO cartdao = new CartDAO();
            OrderDetailDAO od = new OrderDetailDAO();
            List<CartDetail> cart = (List<CartDetail>) session.getAttribute("cart");

// Insert into OrderDetail database
            for (CartDetail cartDetail : cart) {
                od.insertOrderDetail(id, cartDetail.getPerfume().getId(), cartDetail.getQuantity(), od.getStaffLeastOrder().getId());
                Perfume p = pdao.getPerfumeById(cartDetail.getPerfume().getId());
                pdao.updateHold(cartDetail.getPerfume().getId(), p.getHold() + cartDetail.getQuantity());
            }

// Clear the cart after placing the order
            cartdao.deleteCartByCustomerId(c.getId());

// Send order confirmation email
            String recipient = c.getEmail();
            String subject = "Order Confirmation - Perfume Paradise";
            String purpose = "order_confirmation";
            String customerName = c.getUsername();
            String orderId = String.valueOf(id);

            um.sendCustomEmail(recipient, subject, purpose, customerName, orderId);

// Redirect to cart completion page
            response.sendRedirect("cartComplete?id=" + id);
        } else {
            //vnpay
            CartDAO cartdao = new CartDAO();
            long totalPrice = cartdao.getTotalPriceByCustomerId(c.getId()); // Lấy tổng tiền từ giỏ hàng
            odao.insertOrder(id, c.getId(), address, "VNPay", false, totalPrice);

            OrderDetailDAO od = new OrderDetailDAO();
            List<CartDetail> cart = (List<CartDetail>) session.getAttribute("cart");
            //insert into OrderDetail database
            for (CartDetail cartDetail : cart) {
                od.insertOrderDetail(id, cartDetail.getPerfume().getId(), cartDetail.getQuantity(), od.getStaffLeastOrder().getId());
                Perfume p = pdao.getPerfumeById(cartDetail.getPerfume().getId());
                pdao.updateHold(cartDetail.getPerfume().getId(), p.getHold() + cartDetail.getQuantity());
            }
//            response.sendRedirect("order");
            cartdao.deleteCartByCustomerId(c.getId());

            //vnpay
            long amount = totalPrice * 2500000; // Chuyển đổi sang đơn vị nhỏ nhất của tiền tệ
            String vnp_Version = "2.1.0";
            String vnp_Command = "pay";
            String orderType = "other";

            String bankCode = "NCB";

            String vnp_TxnRef = Config.getRandomNumber(8);
            String vnp_IpAddr = Config.getIpAddress(request);

            String vnp_TmnCode = Config.vnp_TmnCode;

            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", vnp_Version);
            vnp_Params.put("vnp_Command", vnp_Command);
            vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(amount));
            vnp_Params.put("vnp_CurrCode", "VND");

            vnp_Params.put("vnp_BankCode", bankCode);
            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang:" + vnp_TxnRef);
            vnp_Params.put("vnp_OrderType", orderType);

            String locate = request.getParameter("language");
            if (locate != null && !locate.isEmpty()) {
                vnp_Params.put("vnp_Locale", locate);
            } else {
                vnp_Params.put("vnp_Locale", "vn");
            }
            String returnURL = Config.vnp_ReturnUrl + "?orderId=" + id + "&";
            vnp_Params.put("vnp_ReturnUrl", returnURL);
            vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

            cld.add(Calendar.MINUTE, 15);
            String vnp_ExpireDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

            List fieldNames = new ArrayList(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();
            Iterator itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = (String) itr.next();
                String fieldValue = (String) vnp_Params.get(fieldName);
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    //Build hash data
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    //Build query
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                    query.append('=');
                    query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }
            System.out.println("User Account: " + session.getAttribute("account"));
            String queryUrl = query.toString();

            String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hashData.toString());
            queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
            String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;

            response.sendRedirect(paymentUrl);
        }
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

package controller;

import dal.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;

public class updateCustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CustomerDAO cdao = new CustomerDAO();
        String idParam = request.getParameter("id");
        int id = 0;
        if (idParam != null && !idParam.isEmpty()) {
            id = Integer.parseInt(idParam);
        } else {
            response.sendRedirect("errorPage.jsp");
            return;
        }
        Customer c = cdao.getByCusId(id);
        request.setAttribute("c", c);
        request.getRequestDispatcher("updatecustomer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve form parameters
        int id = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String fullname = request.getParameter("fullname");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        // Update customer using DAO
        CustomerDAO cdao = new CustomerDAO();
        boolean isUpdated = cdao.updateProfile(id, username, fullname, phone, email, address, gender);

        // Redirect based on update result
        if (isUpdated) {
            response.sendRedirect("customerList");
        } else {
            response.sendRedirect("errorPage.jsp"); // redirect to an error page if update fails
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles the update of customer information.";
    }
}

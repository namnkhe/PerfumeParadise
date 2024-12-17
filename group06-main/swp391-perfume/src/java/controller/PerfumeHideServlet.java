package controller;

import dal.PerfumeDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class PerfumeHideServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the perfume ID from the request
        String perfumeIdParam = request.getParameter("id");
        if (perfumeIdParam != null) {
            try {
                int perfumeId = Integer.parseInt(perfumeIdParam);

                // Create an instance of PerfumeDAO
                PerfumeDAO perfumeDAO = new PerfumeDAO();

                // Call the method to update the perfume's visibility
                perfumeDAO.hidePerfume(perfumeId);

                // Redirect to a success page or back to the product list
                response.sendRedirect("Admin2");
            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid perfume ID");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Perfume ID is required");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // It's common to use POST for updates, but you can implement GET if needed
        doPost(request, response);
    }
}

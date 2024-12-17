package controller;

import dal.BrandDAO;
import dal.CategoryDAO;
import dal.PerfumeDAO;
import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Brand;
import model.Category;
import model.Perfume;

public class Admin1Servlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fetch brand and category lists for the search form
        BrandDAO bd = new BrandDAO();
        List<Brand> listBrand = bd.getAllBrand();
        CategoryDAO cd = new CategoryDAO();
        List<Category> listC = cd.getAllCategory();

        // Retrieve search parameters from the request
        String brandId = request.getParameter("brand");
        String categoryId = request.getParameter("category");
        String minPrice = request.getParameter("minPrice");
        String maxPrice = request.getParameter("maxPrice");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        // Convert parameters from String to appropriate data types
        Integer brandIdInt = parseInteger(brandId, "All");
        Integer categoryIdInt = parseInteger(categoryId, "All");
        Double minPriceDouble = parseDouble(minPrice);
        Double maxPriceDouble = parseDouble(maxPrice);
        Date startDate = parseDate(startDateStr);
        Date endDate = parseDate(endDateStr);

        // Fetch the filtered perfume list
        PerfumeDAO pd = new PerfumeDAO();
        List<Perfume> listP = pd.getPerfumeByFilter(categoryIdInt, brandIdInt, minPriceDouble, maxPriceDouble, startDate, endDate);

        // Check if the request is for JSON response by looking at the 'Accept' header
        String acceptHeader = request.getHeader("Accept");
        if (acceptHeader != null && acceptHeader.contains("application/json")) {
            response.setContentType("application/json;charset=UTF-8");

            // Use Gson to serialize the list to JSON
        } else {
            // Use request attributes to pass data to the JSP
            request.setAttribute("brands", listBrand);
            request.setAttribute("categories", listC);
            request.setAttribute("listP", listP);

            // Forward the request to the JSP for rendering HTML view
            request.getRequestDispatcher("adminhome1.jsp").forward(request, response);
        }
    }

    // Helper method to parse integers safely
    private Integer parseInteger(String value, String exclude) {
        if (value != null && !value.equals(exclude)) {
            try {
                return Integer.parseInt(value);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    // Helper method to parse doubles safely
    private Double parseDouble(String value) {
        if (value != null && !value.isEmpty()) {
            try {
                return Double.parseDouble(value);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    // Helper method to parse dates safely
    private Date parseDate(String dateStr) {
        if (dateStr == null || dateStr.isEmpty()) {
            return null;
        }
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            return new Date(sdf.parse(dateStr).getTime());
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);  // Reuse doGet logic for POST requests
    }

    @Override
    public String getServletInfo() {
        return "Servlet for searching perfumes with filters";
    }
}

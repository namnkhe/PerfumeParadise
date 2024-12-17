/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.SliderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Slide;

/**
 *
 * @author phida
 */
@WebServlet(name = "SliderController", urlPatterns = {"/SliderController"})
public class SliderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        SliderDAO slideDAO = new SliderDAO();
        String searchQuery = request.getParameter("search");   // search by title or backlink
        String status = request.getParameter("status");        // filter by status

        try {
            if (action == null) {
                action = "listSlide";
            }

            if (action.equals("listSlide")) {
                List<Slide> slides = slideDAO.getAllSlides(searchQuery, status);
                request.setAttribute("slides", slides);
                request.getRequestDispatcher("slideList.jsp").forward(request, response);
            }
            if (action.equals("showCarousel")) {
                List<Slide> carouselSlides = slideDAO.getAllSlides(null, "active"); // Assuming "active" filters active slides
                request.setAttribute("slides", carouselSlides);
                request.getRequestDispatcher("header.jsp").forward(request, response);
            }
        } catch (Exception e) {
            throw new ServletException("Unable to retrieve slides", e);
        }

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
        response.setContentType("text/html;charset=UTF-8");
        SliderDAO slideDAO = new SliderDAO();
        String action = request.getParameter("action");
        int slideId = Integer.parseInt(request.getParameter("slideId"));

        try {
            if (action.equals("Edit")) {
                Slide slider = slideDAO.getSlideById(slideId);
                request.setAttribute("slider", slider);
                request.getRequestDispatcher("editSlider.jsp").forward(request, response);
                return;
            }
            if ("hide".equals(action)) {
                slideDAO.updateSlideStatus(slideId, false);
            } else if ("show".equals(action)) {
                slideDAO.updateSlideStatus(slideId, true);
            } else if ("Edit Slide".equals(action)) {
                String title = request.getParameter("title");
                String imageUrl = request.getParameter("image_url");
                String description = request.getParameter("description");
                String link = request.getParameter("link");
                boolean isActive = Boolean.parseBoolean(request.getParameter("is_active"));
                int authorId = Integer.parseInt(request.getParameter("author_id"));

                Slide slide = new Slide(slideId, title, imageUrl, description, link, isActive, null, authorId);
                slideDAO.editSlide(slide);
                response.sendRedirect("SliderController");

            }
        } catch (Exception e) {
            throw new ServletException("Error updating slide", e);
        }

    }

}

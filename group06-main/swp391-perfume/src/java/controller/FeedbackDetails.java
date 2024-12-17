/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.FeedBackDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Feedback;

/**
 *
 * @author phida
 */
@WebServlet(name = "FeedbackDetails", urlPatterns = {"/FeedbackDetails"})
public class FeedbackDetails extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String feedbackIdParam = request.getParameter("feedbackId");

        if (feedbackIdParam != null) {
            try {
                int feedbackId = Integer.parseInt(feedbackIdParam);
                FeedBackDAO feedbackDAO = new FeedBackDAO();
                Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);

                if (feedback != null) {
                    request.setAttribute("feedback", feedback);
                } else {
                    request.setAttribute("message", "No feedback details available.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("message", "Invalid feedback ID.");
            }
        } else {
            request.setAttribute("message", "Feedback ID is required.");
        }

        request.getRequestDispatcher("feedbackDetails.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
        String status = request.getParameter("status");
        String comment = request.getParameter("comment");
        int rating = Integer.parseInt(request.getParameter("rating"));

        Feedback feedback = new Feedback();
        feedback.setId(feedbackId);
        feedback.setComment(comment);
        feedback.setRating(rating);
        feedback.setStatus(status);

        FeedBackDAO feedbackDAO = new FeedBackDAO();
        boolean isUpdated = feedbackDAO.updateFeedbackDetails(feedback);

        if (isUpdated) {
            response.sendRedirect("FeedBackList?message=Update successful!");
        } else {
            request.setAttribute("error", "Failed to update feedback details.");
            request.getRequestDispatcher("feedbackDetails.jsp?feedbackId=" + feedbackId).forward(request, response);
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

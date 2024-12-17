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
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Feedback;

/**
 *
 * @author phida
 */
@WebServlet(name = "FeedBackList", urlPatterns = {"/FeedBackList"})
public class FeedBackList extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchFullName = request.getParameter("searchFullName");
        String searchByName = request.getParameter("searchByName");
        String searchByRating = request.getParameter("searchByRating");

        FeedBackDAO feedBackDAO = new FeedBackDAO();
        List<Feedback> feedbackList;

        if (searchFullName != null && !searchFullName.isEmpty()
                && searchByName != null && !searchByName.isEmpty()
                && searchByRating != null && !searchByRating.isEmpty()) {
            try {
                int rating = Integer.parseInt(searchByRating);
                feedbackList = feedBackDAO.getFeedbackByFullNameAndProductNameAndRating(searchFullName, searchByName, rating);
            } catch (NumberFormatException e) {
                feedbackList = feedBackDAO.FeedBackList();
            }
        } else if (searchFullName != null && !searchFullName.isEmpty()
                && searchByName != null && !searchByName.isEmpty()) {
            feedbackList = feedBackDAO.getFeedbackByFullNameAndProductName(searchFullName, searchByName);
        } else if (searchFullName != null && !searchFullName.isEmpty()) {
            feedbackList = feedBackDAO.getFeedbackByFullName(searchFullName);
        } else if (searchByName != null && !searchByName.isEmpty()) {
            feedbackList = feedBackDAO.getFeedbackByProductName(searchByName);
        } else if (searchByRating != null && !searchByRating.isEmpty()) {
            try {
                int rating = Integer.parseInt(searchByRating);
                feedbackList = feedBackDAO.getFeedbackByRating(rating);
            } catch (NumberFormatException e) {
                feedbackList = feedBackDAO.FeedBackList();
            }
        } else {
            feedbackList = feedBackDAO.FeedBackList();
        }

        request.setAttribute("feedbackList", feedbackList);
        request.setAttribute("searchFullName", searchFullName);
        request.setAttribute("searchByName", searchByName);
        request.setAttribute("searchByRating", searchByRating);

        RequestDispatcher dispatcher = request.getRequestDispatcher("feedbackList.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Xử lý khi cập nhật một trạng thái duy nhất
        if ("updateStatus".equals(action)) {
            try {
                // Lấy feedbackId và trạng thái từ request
                int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
                String status = request.getParameter("status");

                FeedBackDAO feedBackDAO = new FeedBackDAO();
                boolean isUpdated = feedBackDAO.updateFeedbackStatus(feedbackId, status);

                // Thông báo kết quả cập nhật
                if (isUpdated) {
                    request.getSession().setAttribute("message", "Status updated successfully.");
                } else {
                    request.getSession().setAttribute("message", "Failed to update status.");
                }

                // Redirect về danh sách feedback
                response.sendRedirect(request.getContextPath() + "/FeedBackList");

            } catch (NumberFormatException e) {
                // Xử lý lỗi khi feedbackId không hợp lệ
                request.getSession().setAttribute("message", "Invalid feedback ID.");
                response.sendRedirect(request.getContextPath() + "/FeedBackList");
            }

        } else if ("updateStatuses".equals(action)) {

            FeedBackDAO feedBackDAO = new FeedBackDAO();
            List<Feedback> feedbackList = (List<Feedback>) request.getAttribute("feedbackList");

            if (feedbackList != null && !feedbackList.isEmpty()) {
                for (Feedback feedback : feedbackList) {
                    int feedbackId = feedback.getId();

                    String status = request.getParameter("status_" + feedbackId);

                    if (status != null) {
                        feedBackDAO.updateFeedbackStatus(feedbackId, status);
                    }
                }
            }

            response.sendRedirect(request.getContextPath() + "/FeedBackList");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}

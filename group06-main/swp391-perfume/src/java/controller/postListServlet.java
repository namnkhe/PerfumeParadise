package controller;

import dal.BlogDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Blog;

public class postListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BlogDAO bdao = new BlogDAO();
        // Set default values for pagination
        int postsPerPage = 10;
        int currentPage = 1;
        String pageParam = request.getParameter("page");

        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1; // If parsing fails, default to page 1
            }
        }

        if (currentPage < 1) {
            currentPage = 1; // Ensure currentPage is at least 1
        }

        // Retrieve all blogs with status 1
        List<Blog> allBlogs = bdao.getAllVisibleBlog();

        // Calculate total posts and total pages
        int totalPosts = allBlogs.size();
        int totalPages = (int) Math.ceil((double) totalPosts / postsPerPage);

        // Cap currentPage at totalPages if it exceeds valid bounds
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        // Calculate start and end indices for pagination
        int start = (currentPage - 1) * postsPerPage;
        int end = Math.min(start + postsPerPage, totalPosts);

        // Get the sublist of blogs for the current page
        List<Blog> listB = allBlogs.subList(start, end);

        // Set attributes for the JSP page
        request.setAttribute("listB", listB);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        // Forward to JSP
        request.getRequestDispatcher("postlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet to display a paginated list of blog posts.";
    }
}

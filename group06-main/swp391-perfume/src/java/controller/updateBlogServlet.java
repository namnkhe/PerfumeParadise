package controller;

import dal.BlogDAO;
import java.io.IOException;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import model.Admin;

@MultipartConfig
public class updateBlogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        BlogDAO bdao = new BlogDAO();
        int id = Integer.parseInt(request.getParameter("id"));
        request.setAttribute("blog", bdao.getBlogByID(id));
        request.getRequestDispatcher("updateblog.jsp").forward(request, response); // Forward to JSP page
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();

        int id = Integer.parseInt(request.getParameter("id"));
        String blogTitle = request.getParameter("blogTitle");
        String blogContent = request.getParameter("blogContent");
        String actionType = request.getParameter("actionType"); // Get the action type (submit or saveDraft)
        Admin admin = (Admin) session.getAttribute("admin");

        if (admin == null) {
            response.sendRedirect("adminlogin");
            return;
        }

        int updatedBy = admin.getId();
        Date updatedAt = new Date(new java.util.Date().getTime()); // java.sql.Date

        if (blogTitle == null || blogTitle.isEmpty() || blogContent == null || blogContent.isEmpty()) {
            request.setAttribute("error", "Title and Content cannot be empty.");
            request.getRequestDispatcher("updateblog.jsp").forward(request, response);
            return;
        }

        Part image = request.getPart("image");
        String newImageFileName = null;

        // Get the current image from the hidden form field
        String currentImage = request.getParameter("currentImage");

        if (image != null && image.getSize() > 0) {
            // If a new image is uploaded, process and save it
            newImageFileName = image.getSubmittedFileName();
            String path = request.getServletContext().getRealPath("/") + "images/blog" + File.separator + newImageFileName;

            try (FileOutputStream fos = new FileOutputStream(path); InputStream is = image.getInputStream()) {

                byte[] data = new byte[is.available()];
                is.read(data);
                fos.write(data);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            // No new image uploaded, retain the old image
            newImageFileName = currentImage;
        }

        BlogDAO bdao = new BlogDAO();

        if ("submit".equals(actionType)) {
            // Handle the "Submit" action (publish the blog)
            boolean status = true; // Mark as published
            bdao.updateBlog(id, blogTitle, blogContent, updatedBy, updatedAt, status, newImageFileName);
            response.sendRedirect("blogList"); // Redirect to blog list after submission

        } else if ("saveDraft".equals(actionType)) {
            // Handle the "Save Draft" action
            boolean status = false; // Mark as draft
            bdao.updateBlog(id, blogTitle, blogContent, updatedBy, updatedAt, status, newImageFileName);
            response.sendRedirect("blogList"); // Redirect to blog list after saving draft
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description of updateBlogServlet";
    }
}

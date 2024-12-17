package controller;

import dal.BlogDAO;
import java.io.IOException;
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
import java.util.Date;
import model.Admin;

@MultipartConfig
public class addBlogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("addblog.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();

        String blogTitle = request.getParameter("blogTitle");
        String blogContent = request.getParameter("blogContent");
        String actionType = request.getParameter("actionType"); // Get the action type (submit or saveDraft)
        Admin admin = (Admin) session.getAttribute("admin");

        if (admin == null) {
            response.sendRedirect("adminlogin");
            return;
        }

        int createdBy = admin.getId();
        Date createdAt = new Date(); // java.util.Date
        java.sql.Date sqlCreatedAt = new java.sql.Date(createdAt.getTime()); // Convert to java.sql.Date
        boolean status = true;

        if (blogTitle == null || blogTitle.isEmpty() || blogContent == null || blogContent.isEmpty()) {
            request.setAttribute("error", "Title and Content cannot be empty.");
            request.getRequestDispatcher("addblog.jsp").forward(request, response);
            return;
        }

        // Xử lý phần ảnh
        Part image = request.getPart("image");
        String path = request.getServletContext().getRealPath("/") + "images/blog" + File.separator
                + image.getSubmittedFileName();
        try {
            FileOutputStream fos = new FileOutputStream(path);
            InputStream is = image.getInputStream();
            byte[] data = new byte[is.available()];
            is.read(data);
            fos.write(data);
            fos.flush();
            fos.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        BlogDAO bdao = new BlogDAO();

        if ("submit".equals(actionType)) {
            // Handle the "Submit" action
            bdao.addBlog(blogTitle, blogContent, createdBy, sqlCreatedAt, status, image.getSubmittedFileName());
            request.setAttribute("success", "Blog submitted successfully.");
            response.sendRedirect("blogList"); // Redirect to the blog list after submission

        } else if ("saveDraft".equals(actionType)) {
            // Handle the "Save Draft" action
            status = false; // Mark the blog as draft (or invisible)
            bdao.addBlog(blogTitle, blogContent, createdBy, sqlCreatedAt, status, image.getSubmittedFileName());
            request.setAttribute("success", "Blog saved as draft.");
            response.sendRedirect("blogList"); // Redirect to the blog list after saving as draft
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet to add or save blog posts";
    }
}

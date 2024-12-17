/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.AdminDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Admin;

/**
 *
 * @author phida
 */
public class StaffController extends HttpServlet {

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
            out.println("<title>Servlet StaffController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StaffController at " + request.getContextPath() + "</h1>");
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
        response.setContentType("text/html;charset=UTF-8");

        String service = request.getParameter("service");
        String id = request.getParameter("id");
        String username = request.getParameter("username");
        String roleParam = request.getParameter("role");

        int role = (roleParam != null && !"All".equals(roleParam)) ? Integer.parseInt(roleParam) : -1;

        AdminDAO adminDAO = new AdminDAO();

        try {
            if (service == null) {
                service = "listAdmin";
            }

            if ("listAdmin".equals(service)) {
                List<Admin> list = adminDAO.getAllAdmins();
                request.setAttribute("adminList", list);
                request.getRequestDispatcher("userList.jsp").forward(request, response);
            }
            if ("addAdmin".equals(service)) {
                // Lấy dữ liệu từ form
                String password = request.getParameter("password");

                // Tạo đối tượng Admin mới
                Admin admin = new Admin();
                admin.setUsername(username);
                admin.setPassword(password);
                admin.setRole(role);

                adminDAO.addAdmin(admin);
                response.sendRedirect("StaffController?service=listAdmin");
            }

            if ("search".equals(service)) {
                List<Admin> list = adminDAO.searchAdmins(username, role);
                request.setAttribute("adminList", list);

                request.getRequestDispatcher("userList.jsp").forward(request, response);
            }

//        if ("update".equals(service)) {
//            Admin admin = adminDAO.getAdminById(Integer.parseInt(id));
//            request.setAttribute("admin", admin);
//            request.getRequestDispatcher("updateAdmin.jsp").forward(request, response);
//        }
            if ("delete".equals(service)) {
                adminDAO.deleteAdmin(Integer.parseInt(id));
                response.sendRedirect("StaffController");
            }
        } catch (SQLException ex) {
            Logger.getLogger(StaffController.class.getName()).log(Level.SEVERE, null, ex);
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String username = request.getParameter("username");
        String roleP = request.getParameter("role");
        String password = request.getParameter("password");
        String service = request.getParameter("service");
        AdminDAO adminDAO = new AdminDAO();

        try {
            if ("update".equals(service)) {
                Admin admin = adminDAO.getAdminById(Integer.parseInt(id));
                admin.setId(Integer.parseInt(id));
                admin.setUsername(username);
                int role = Integer.parseInt(roleP);
                admin.setRole(role);
                adminDAO.updateAdmin(admin);
                response.sendRedirect("StaffController");
            }
            if ("addAdmin".equals(service)) {

                if (adminDAO.checkUsernameExist(username)) {
                    request.setAttribute("errorMessage", "Username already exists. Please choose another one.");
                    request.setAttribute("username", username);
                    request.setAttribute("role", roleP);

                    List<Admin> adminList = adminDAO.getAllAdmins();
                    request.setAttribute("adminList", adminList);

                    request.getRequestDispatcher("userList.jsp").forward(request, response);
                    return;
                }

                Admin admin = new Admin();
                admin.setUsername(username);
                admin.setPassword(password);
                int role = Integer.parseInt(roleP);
                admin.setRole(role);
                adminDAO.addAdmin(admin);
                response.sendRedirect("StaffController?service=listAdmin");
            }
        } catch (SQLException e) {
            System.out.println(e);
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

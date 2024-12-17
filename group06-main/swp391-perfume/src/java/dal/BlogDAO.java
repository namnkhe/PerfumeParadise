/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Blog;

/**
 *
 * @author Administrator
 */
public class BlogDAO extends DBContext {

    PreparedStatement stm; //thực hiện các câu lệnh SQL
    ResultSet rs; //lưu trữ và xử lí dữ liệu

    public Blog getBlogByID(int id) {
        String sql = """
                     SELECT 
                                          Blogs.id, 
                                          Blogs.title, 
                                          Blogs.content,
                                          Creator.username AS created_by_name, 
                                          Updater.username AS updated_by_name, 
                                          Blogs.created_at, 
                                          Blogs.updated_at,
                                          Blogs.status,
                                          Blogs.image
                                      FROM 
                                          Blogs 
                                      LEFT JOIN 
                                          Admins AS Creator ON Blogs.created_by = Creator.id 
                                      LEFT JOIN 
                                          Admins AS Updater ON Blogs.updated_by = Updater.id where Blogs.id = ?""";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String title = rs.getString(2);
                String content = rs.getString(3);
                String brief = getBlogBrief(content);
                String created_by = rs.getString(4);
                String updated_by = rs.getString(5);
                Date created_at = rs.getDate(6);
                Date updated_at = rs.getDate(7);
                boolean status = rs.getBoolean(8);
                String image = rs.getString(9);
                Blog b = new Blog(id, title, content, brief, created_by, updated_by, created_at, updated_at, status, image);
                return b;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Blog> getAllBlog() {
        List<Blog> listB = new ArrayList<>();

        try {
            String sql = """
                 SELECT 
                     Blogs.id, 
                     Blogs.title, 
                     Blogs.content,
                     Creator.username AS created_by_name, 
                     Updater.username AS updated_by_name, 
                     Blogs.created_at, 
                     Blogs.updated_at,
                     Blogs.status,
                     Blogs.image
                 FROM 
                     Blogs 
                 LEFT JOIN 
                     Admins AS Creator ON Blogs.created_by = Creator.id 
                 LEFT JOIN 
                     Admins AS Updater ON Blogs.updated_by = Updater.id""";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            while (rs.next()) {
                int id = rs.getInt(1);
                String title = rs.getString(2);
                String content = rs.getString(3);
                String brief = getBlogBrief(content);
                String created_by = rs.getString(4);
                String updated_by = rs.getString(5);
                Date created_at = rs.getDate(6);
                Date updated_at = rs.getDate(7);
                boolean status = rs.getBoolean(8);
                String image = rs.getString(9);
                Blog b = new Blog(id, title, content, brief, created_by, updated_by, created_at, updated_at, status, image);
                listB.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Use proper logging instead of printStackTrace in production
        }
        return listB;
    }

    public List<Blog> getAllVisibleBlog() {
        List<Blog> listB = new ArrayList<>();

        try {
            String sql = """
                 SELECT 
                     Blogs.id, 
                     Blogs.title, 
                     Blogs.content,
                     Creator.username AS created_by_name, 
                     Updater.username AS updated_by_name, 
                     Blogs.created_at, 
                     Blogs.updated_at,
                     Blogs.status,
                     Blogs.image
                 FROM 
                     Blogs 
                 LEFT JOIN 
                     Admins AS Creator ON Blogs.created_by = Creator.id 
                 LEFT JOIN 
                     Admins AS Updater ON Blogs.updated_by = Updater.id
                 where status = 1""";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            while (rs.next()) {
                int id = rs.getInt(1);
                String title = rs.getString(2);
                String content = rs.getString(3);
                String brief = getBlogBrief(content);
                String created_by = rs.getString(4);
                String updated_by = rs.getString(5);
                Date created_at = rs.getDate(6);
                Date updated_at = rs.getDate(7);
                boolean status = rs.getBoolean(8);
                String image = rs.getString(9);
                Blog b = new Blog(id, title, content, brief, created_by, updated_by, created_at, updated_at, status, image);
                listB.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Use proper logging instead of printStackTrace in production
        }
        return listB;
    }

    public void changeStatus(int id, boolean status) {
        try {
            String sql = "update Blogs set status = ? where ID = ?";
            stm = connection.prepareStatement(sql);
            stm.setBoolean(1, status);
            stm.setInt(2, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteBlog(int id) {
        try {
            String sql = "delete from Blogs where ID = ?";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void updateBlog(int id, String blogTitle, String blogContent, int updatedBy, Date updatedAt, boolean status, String submittedFileName) {
        try {
            String sql = "update Blogs set title = ?, content = ?, updated_by = ?, updated_at = ?, status = ?, image = ? where ID = ?";
            stm = connection.prepareStatement(sql);
            stm.setString(1, blogTitle);
            stm.setString(2, blogContent);
            stm.setInt(3, updatedBy);
            stm.setDate(4, new java.sql.Date(updatedAt.getTime()));  // Chuyển đổi từ java.util.Date sang java.sql.Date
            stm.setBoolean(5, status);
            stm.setString(6, submittedFileName);
            stm.setInt(7, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void addBlog(String blogTitle, String blogContent, int createdBy, Date sqlCreatedAt, boolean status, String submittedFileName) {
        try {
            String sql = "insert into Blogs(title, content, created_by, created_at, status, image) values (?,?,?,?,?,?)";
            stm = connection.prepareStatement(sql);
            stm.setString(1, blogTitle);
            stm.setString(2, blogContent);
            stm.setInt(3, createdBy);
            stm.setDate(4, new java.sql.Date(sqlCreatedAt.getTime()));  // Chuyển đổi từ java.util.Date sang java.sql.Date
            stm.setBoolean(5, status);
            stm.setString(6, submittedFileName);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    private String getBlogBrief(String blogContent) {
        // Split the content by period followed by a space to separate sentences.
        String[] sentences = blogContent.split("\\.\\s+");

        // Initialize an empty string for the brief content.
        StringBuilder blogBrief = new StringBuilder();

        // Take the first 5 sentences or less if there are fewer sentences.
        for (int i = 0; i < Math.min(2, sentences.length); i++) {
            blogBrief.append(sentences[i]).append(". ");
        }

        // Return the brief content, trimming any extra spaces.
        return blogBrief.toString().trim();
    }

    public int getTotalBlogCount() {
        int total = 0;

        try {
            String sql = "select count(*) as total from Blogs";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public List<Blog> getPaginatedBlogs(int start, int limit) {
        List<Blog> listB = new ArrayList<>();
        try {
            String sql = """
                 SELECT 
                         Blogs.id, 
                         Blogs.title, 
                         Blogs.content,
                         Creator.username AS created_by_name, 
                         Updater.username AS updated_by_name, 
                         Blogs.created_at, 
                         Blogs.updated_at,
                         Blogs.status,
                         Blogs.image
                     FROM 
                         Blogs 
                     LEFT JOIN 
                         Admins AS Creator ON Blogs.created_by = Creator.id 
                     LEFT JOIN 
                         Admins AS Updater ON Blogs.updated_by = Updater.id
                     ORDER BY 
                         Blogs.created_at DESC
                     OFFSET 
                         ? ROWS FETCH NEXT ? ROWS ONLY""";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, start);
            stm.setInt(2, limit);
            rs = stm.executeQuery();
            while (rs.next()) {
                int id = rs.getInt(1);
                String title = rs.getString(2);
                String content = rs.getString(3);
                String brief = getBlogBrief(content); // Assuming getBlogBrief is a utility to generate a brief summary
                String created_by = rs.getString(4);
                String updated_by = rs.getString(5);
                Date created_at = rs.getDate(6);
                Date updated_at = rs.getDate(7);
                boolean status = rs.getBoolean(8);
                String image = rs.getString(9);

                Blog b = new Blog(id, title, content, brief, created_by, updated_by, created_at, updated_at, status, image);
                listB.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listB;
    }

    public int getTotalVisibleBlogCount() {
        int total = 0;

        try {
            String sql = "select count(*) as total from Blogs where status = 1";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // It's good practice to close your resources
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (stm != null) {
                try {
                    stm.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return total;
    }

    public List<Blog> getPaginatedVisibleBlogs(int start, int limit) {
        List<Blog> listB = new ArrayList<>();
        try {
            String sql = """
            SELECT 
                Blogs.id, 
                Blogs.title, 
                Blogs.content,
                Creator.username AS created_by_name, 
                Updater.username AS updated_by_name, 
                Blogs.created_at, 
                Blogs.updated_at,
                Blogs.status,
                Blogs.image
            FROM 
                Blogs 
            LEFT JOIN 
                Admins AS Creator ON Blogs.created_by = Creator.id 
            LEFT JOIN 
                Admins AS Updater ON Blogs.updated_by = Updater.id
            WHERE 
                status = 1
            ORDER BY 
                created_at DESC
            OFFSET 
                ? ROWS
            FETCH NEXT 
                ? ROWS ONLY
        """;
            stm = connection.prepareStatement(sql);
            stm.setInt(1, start);
            stm.setInt(2, limit);
            rs = stm.executeQuery();

            while (rs.next()) {
                int id = rs.getInt(1);
                String title = rs.getString(2);
                String content = rs.getString(3);
                String brief = getBlogBrief(content); // Assuming getBlogBrief is a utility to generate a brief summary
                String created_by = rs.getString(4);
                String updated_by = rs.getString(5);
                Date created_at = rs.getDate(6);
                Date updated_at = rs.getDate(7);
                boolean status = rs.getBoolean(8);
                String image = rs.getString(9);

                Blog b = new Blog(id, title, content, brief, created_by, updated_by, created_at, updated_at, status, image);
                listB.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // It's good practice to close your resources
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (stm != null) {
                try {
                    stm.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        return listB;
    }

    public List<Blog> getFourLatestBlog() {
        List<Blog> listB = new ArrayList<>();
        try {
            String sql = "SELECT TOP 4 *\n"
                    + "FROM [dbo].[Blogs]\n"
                    + "WHERE [status] = 1\n"
                    + "ORDER BY \n"
                    + "    COALESCE([updated_at], [created_at]) DESC";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            while (rs.next()) {
                int id = rs.getInt(1);
                String title = rs.getString(2);
                String content = rs.getString(3);
                String brief = getBlogBrief(content); // Assuming getBlogBrief is a utility to generate a brief summary
                String created_by = rs.getString(4);
                String updated_by = rs.getString(5);
                Date created_at = rs.getDate(6);
                Date updated_at = rs.getDate(7);
                boolean status = rs.getBoolean(8);
                String image = rs.getString(9);

                Blog b = new Blog(id, title, content, brief, created_by, updated_by, created_at, updated_at, status, image);
                listB.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listB;
    }

}

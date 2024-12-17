/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.util.List;
import model.Slide;
import org.apache.tomcat.dbcp.dbcp2.SQLExceptionList;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Perfume;

/**
 *
 * @author phida
 */
public class SliderDAO extends DBContext {

    public List<Slide> getAllSlides(String searchQuery, String status) {
        List<Slide> slides = new ArrayList<>();
        String query = "SELECT * FROM Sliders WHERE 1=1"; // Base query

        // Add conditions for filtering and search
        if (searchQuery != null && !searchQuery.isEmpty()) {
            query += " AND (title LIKE ? OR link LIKE ?)";
        }
        if (status != null && !status.isEmpty()) {
            query += " AND is_active = ?";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(query);
            int index = 1;
            if (searchQuery != null && !searchQuery.isEmpty()) {
                ps.setString(index++, "%" + searchQuery + "%");
                ps.setString(index++, "%" + searchQuery + "%");
            }
            if (status != null && !status.isEmpty()) {
                ps.setBoolean(index++, Boolean.parseBoolean(status));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                slides.add(new Slide(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("image_url"),
                        rs.getString("description"),
                        rs.getString("link"),
                        rs.getBoolean("is_active"),
                        rs.getString("created_at"),
                        rs.getInt("author_id")
                ));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return slides;
    }

    public void updateSlideStatus(int slideId, boolean status) throws SQLException {
        String query = "UPDATE Sliders SET is_active = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setBoolean(1, status);
            ps.setInt(2, slideId);
            ps.executeUpdate();
        }
    }

    public void editSlide(Slide slide) throws SQLException {
        String query = "UPDATE Sliders SET title = ?, image_url = ?, description = ?, link = ?, is_active = ?, author_id = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, slide.getTitle());
            ps.setString(2, slide.getImage_url());
            ps.setString(3, slide.getDescription());
            ps.setString(4, slide.getLink());
            ps.setBoolean(5, slide.isIs_active());
            ps.setInt(6, slide.getAuthor_id());
            ps.setInt(7, slide.getID());
            ps.executeUpdate();
        }
    }

    public Slide getSlideById(int id) {
        String sql = "select * from sliders where ID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Slide slider = new Slide(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4),
                        rs.getString(5), rs.getBoolean(6), rs.getString(7), rs.getInt(8));
                return slider;
            }
        } catch (SQLException e) {
            Logger.getLogger(SliderDAO.class.getName()).log(Level.SEVERE, null, e);

        }
        return null;

    }

    public List<Slide> getAllActiveSlides() {
        List<Slide> slides = new ArrayList<>();
        String query = "SELECT * FROM Sliders WHERE is_active = 1"; // Adjust table and column names as needed
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Slide slide = new Slide(
                        rs.getInt("ID"),
                        rs.getString("title"),
                        rs.getString("image_url"),
                        rs.getString("description"),
                        rs.getString("link"),
                        rs.getBoolean("is_active"),
                        rs.getString("create_at"),
                        rs.getInt("author_id")
                );
                slides.add(slide);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return slides;
    }

}

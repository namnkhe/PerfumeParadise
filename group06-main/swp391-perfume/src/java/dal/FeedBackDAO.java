/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.Customer;
import model.Feedback;
import model.Perfume;

/**
 *
 * @author phida
 */
public class FeedBackDAO extends DBContext {

    public List<Feedback> FeedBackList() {
        List<Feedback> feedList = new ArrayList<>();
        String sql = "select f.id, c.username, p.name, f.rating, f.status from Feedback f \n"
                + "join Customers c on f.cusid = c.ID\n"
                + "join Perfumes p on p.ID = f.pid";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Feedback feed = new Feedback();
                feed.setId(rs.getInt("ID"));
                feed.setRating(rs.getInt("rating"));
                feed.setStatus(rs.getString("status"));

                Customer c = new Customer();
                c.setUsername(rs.getString("username"));
                feed.setCustomer(c);

                Perfume p = new Perfume();
                p.setName(rs.getString("name"));
                feed.setProduct(p);

                feedList.add(feed);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return feedList;
    }

    public List<Feedback> getFeedbackByFullName(String fullName) {
        List<Feedback> feedbackList = new ArrayList<>();
        String query = "SELECT f.id, c.username AS customer_name, p.name AS product_name, f.rating, f.status "
                + "FROM Feedback f "
                + "JOIN Customers c ON f.cusId = c.id "
                + "JOIN Perfumes p ON f.ID = p.id "
                + "WHERE c.username LIKE ?";

        try {
            PreparedStatement st = connection.prepareStatement(query);
            st.setString(1, "%" + fullName + "%");
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Customer customer = new Customer();
                customer.setUsername(rs.getString("customer_name"));

                Perfume product = new Perfume();
                product.setName(rs.getString("product_name"));

                Feedback feedback = new Feedback();
                feedback.setId(rs.getInt("id"));
                feedback.setCustomer(customer);
                feedback.setProduct(product);
                feedback.setRating(rs.getInt("rating"));
                feedback.setStatus(rs.getString("status"));

                feedbackList.add(feedback);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return feedbackList;
    }

    public List<Feedback> getFeedbackByProductName(String productName) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT f.id, c.id AS customer_id, c.username AS customer_name, "
                + "p.id AS product_id, p.name AS product_name, f.rating, f.status "
                + "FROM Feedback f "
                + "JOIN Customers c ON f.cusId = c.id "
                + "JOIN Perfumes p ON f.Id = p.id "
                + "WHERE p.name LIKE ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + productName + "%");  // Using wildcard for partial matches
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                // Create Customers object
                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                customer.setUsername(rs.getString("customer_name"));

                // Create Perfumes object
                Perfume product = new Perfume();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("product_name"));

                // Create Feedbacks object
                Feedback feedback = new Feedback();
                feedback.setId(rs.getInt("id"));
                feedback.setCustomer(customer);
                feedback.setProduct(product);
                feedback.setRating(rs.getInt("rating"));
                feedback.setStatus(rs.getString("status"));

                feedbackList.add(feedback);  // Add to the list
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return feedbackList;
    }

    public List<Feedback> getFeedbackByFullNameAndProductNameAndRating(String fullName, String productName, int rating) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT f.id, c.username AS customer_name, p.name AS product_name, f.rating, f.status "
                + "FROM Feedback f "
                + "JOIN Customers c ON f.cusId = c.id "
                + "JOIN Perfumes p ON f.Id = p.id "
                + "WHERE c.username LIKE ? AND p.name LIKE ? AND f.rating = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);

            st.setString(1, "%" + fullName + "%");
            st.setString(2, "%" + productName + "%");
            st.setInt(3, rating);
            ResultSet resultSet = st.executeQuery();

            while (resultSet.next()) {
                Feedback feedback = new Feedback();
                feedback.setId(resultSet.getInt("id"));
                Customer customer = new Customer();
                customer.setUsername(resultSet.getString("customer_name"));
                feedback.setCustomer(customer);

                Perfume product = new Perfume();
                product.setName(resultSet.getString("product_name"));
                feedback.setProduct(product);

                feedback.setRating(resultSet.getInt("rating"));
                feedback.setStatus(resultSet.getString("status"));
                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    public boolean updateFeedbackStatus(int feedbackId, String status) {
        String sql = "UPDATE Feedback SET status = ? WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, feedbackId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Feedback> getFeedbackByFullNameAndProductName(String customerName, String productName) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT f.id, c.username AS customer_name, p.name AS product_name, f.rating, f.status "
                + "FROM Feedback f "
                + "JOIN Customers c ON f.cusId = c.id "
                + "JOIN Perfumes p ON f.Id = p.id "
                + "WHERE p.name LIKE ? AND c.username LIKE ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);

            st.setString(1, "%" + productName + "%");
            st.setString(2, "%" + customerName + "%");

            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setId(rs.getInt("id"));

                Customer customer = new Customer();
                customer.setUsername(rs.getString("customer_name"));
                feedback.setCustomer(customer);

                Perfume product = new Perfume();
                product.setName(rs.getString("product_name"));
                feedback.setProduct(product);

                feedback.setRating(rs.getInt("rating"));
                feedback.setStatus(rs.getString("status"));

                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    public List<Feedback> getFeedbackByRating(int rating) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT f.id, c.username AS customer_name, p.name AS product_name, f.rating, f.status "
                + "FROM Feedback f "
                + "JOIN Customers c ON f.cusId = c.id "
                + "JOIN Perfumes p ON f.Id = p.id "
                + "WHERE f.rating = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, rating);
            ResultSet resultSet = st.executeQuery();

            while (resultSet.next()) {
                Feedback feedback = new Feedback();
                feedback.setId(resultSet.getInt("id"));
                Customer customer = new Customer();
                customer.setUsername(resultSet.getString("customer_name"));
                feedback.setCustomer(customer);

                Perfume product = new Perfume();
                product.setName(resultSet.getString("product_name"));
                feedback.setProduct(product);

                feedback.setRating(resultSet.getInt("rating"));
                feedback.setStatus(resultSet.getString("status"));
                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    public Feedback getFeedbackById(int feedbackId) {
        Feedback feedback = null;
        String sql = "SELECT f.id, f.comment, f.rating, f.status, "
                + "c.id AS customer_id, c.username AS customer_name, c.email, c.phone, c.avatarUrl, "
                + "p.id AS product_id, p.name AS product_name "
                + "FROM Feedback f "
                + "JOIN Customers c ON f.cusid = c.id "
                + "JOIN Perfumes p ON f.pid = p.id "
                + "WHERE f.id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, feedbackId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                feedback = new Feedback();
                feedback.setId(rs.getInt("id"));
                feedback.setComment(rs.getString("comment"));
                feedback.setRating(rs.getInt("rating"));
                feedback.setStatus(rs.getString("status"));

                Customer customer = new Customer();
                customer.setId(rs.getInt("customer_id"));
                customer.setUsername(rs.getString("customer_name"));
                customer.setEmail(rs.getString("email"));
                customer.setPhone(rs.getString("phone"));
                //customer.setAvarta(rs.getString("image")); 
                feedback.setCustomer(customer);

                Perfume product = new Perfume();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("product_name"));
                feedback.setProduct(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedback;
    }

    public boolean updateFeedbackDetails(Feedback feedback) {
        String sql = "UPDATE Feedback SET comment = ?, rating = ?, status = ? WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, feedback.getComment());
            st.setInt(2, feedback.getRating());
            st.setString(3, feedback.getStatus());
            st.setInt(4, feedback.getId());

            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public ArrayList<Feedback> feedBackForm(int perfumesID) {
        PerfumeDAO pDao = new PerfumeDAO();
//    perfumesID = pDao.getPerfumeById(perfumesID);
        String sql = "SELECT c.avatarUrl, c.username, f.rating, f.comment "
                + "FROM Feedback f "
                + "JOIN Customers c ON c.id = f.cusid "
                + "WHERE f.pid = ?";
        ArrayList<Feedback> feedbackList = new ArrayList<>();

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, perfumesID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Customer customer = new Customer();
                customer.setAvatarUrl(rs.getString("avatarUrl"));
                customer.setUsername(rs.getString("username"));

                Feedback feedback = new Feedback();
                feedback.setCustomer(customer);
                feedback.setRating(rs.getInt("rating"));
                feedback.setComment(rs.getString("comment"));

                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return feedbackList;
    }

    public void saveFeedback(int cusid, int pid, int rating, String comment, int marketer_id, String status) throws SQLException {
        // Lệnh SQL để lưu feedback vào bảng Feedback
        String sql = "INSERT INTO Feedback (cusid, pid, rating, comment, created_at, marketer_id, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, cusid); // ID khách hàng
            ps.setInt(2, pid); // ID sản phẩm
            ps.setInt(3, rating); // Đánh giá sao
            ps.setString(4, comment); // Bình luận
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
            String createdAt = sdf.format(new Date());  // Ngày hiện tại
            ps.setString(5, createdAt);
            ps.setInt(6, marketer_id); // ID marketer (người đánh giá)
            ps.setString(7, status); // Trạng thái feedback (pending, approved, etc.)
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int countAllFeedback() {
        int count = 0;
        String sql = "SELECT COUNT(*) AS total FROM Feedback";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public static void main(String[] args) {
        FeedBackDAO f = new FeedBackDAO();

        List<Feedback> feedbacks = f.feedBackForm(3);
        for (Feedback feedback : feedbacks) {
            System.out.println(feedback);
        }
    }

}

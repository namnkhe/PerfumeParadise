package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;

/**
 *
 * @author chi
 */
public class CustomerDAO extends DBContext {

    PreparedStatement ps;
    ResultSet rs;

    public Customer getByUserNamePassword(String username, String password) {
        try {
            String sql = "SELECT * FROM Customers WHERE username = ? AND [password] = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Customer account = new Customer();
                account.setId(rs.getInt("ID"));
                account.setUsername(username);
                account.setPassword(password);
                account.setFullname(rs.getString("fullname"));
                account.setPhone(rs.getString("phone"));
                account.setEmail(rs.getString("email"));
                account.setAddress(rs.getString("address"));
                account.setGender(rs.getString("gender"));
                account.setAvatarUrl(rs.getString("avatarUrl")); // Thiết lập avatarUrl
                return account;
            }
        } catch (SQLException ex) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public Customer getByCusId(int id) {
        try {
            String sql = "SELECT * FROM Customers WHERE ID=?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Customer account = new Customer();
                account.setId(rs.getInt("ID"));
                account.setUsername(rs.getString("username"));
                account.setPassword(rs.getString("password"));
                account.setFullname(rs.getString("fullname"));
                account.setPhone(rs.getString("phone"));
                account.setEmail(rs.getString("email"));
                account.setAddress(rs.getString("address"));
                account.setGender(rs.getString("gender"));
                account.setAvatarUrl(rs.getString("avatarUrl")); // Thiết lập avatarUrl
                return account;
            }
        } catch (SQLException ex) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean updateProfile(int id, String username, String fullname, String phone, String email, String address, String gender) {
        String sql = "UPDATE Customers SET username=?, phone=?, fullname=?, email=?, address=?, gender=? WHERE ID=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, phone);
            ps.setString(3, fullname);
            ps.setString(4, email);
            ps.setString(5, address);
            ps.setString(6, gender); // Cập nhật giới tính
            ps.setInt(7, id);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return false;
    }

    public boolean updateAvatar(int id, String avatarPath) {
        String sql = "UPDATE Customers SET image = ? WHERE ID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, avatarPath);
            ps.setInt(2, id);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return false;
    }

    public void changePassword(String email, String newPassword) {
        String query = "UPDATE Customers SET [password] = ? WHERE email = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setString(1, newPassword);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, null, e);
        }
    }

    public boolean insertUser(String username, String password, String fullname, String phone, String email, String address, String gender, boolean status) {
        String sql = "INSERT INTO Customers (username, [password], [fullname], [phone], email, [address], [gender], isActive) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, fullname);
            ps.setString(4, phone);
            ps.setString(5, email);
            ps.setString(6, address);
            ps.setString(7, gender); // Thêm giới tính vào đây
            ps.setBoolean(8, false);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace(); // Ghi lại lỗi nếu có
        }
        return false;
    }

    public Customer getCustomerByUsername(String user) {
        try {
            String sql = "SELECT * FROM Customers WHERE [username] = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, user);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("ID"));
                c.setEmail(rs.getString("email"));
                c.setFullname(rs.getString("fullname")); // Sử dụng fullname
                c.setPassword(rs.getString("password"));
                c.setPhone(rs.getString("phone"));
                c.setUsername(user);
                c.setAddress(rs.getString("address")); // Thêm địa chỉ
                c.setGender(rs.getString("gender")); // Thêm giới tính
                c.setImage(rs.getString("image")); // Thêm ảnh đại diện
                return c;
            }
        } catch (SQLException ex) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean checkEmailExist(String email) {
        try {
            String sql = "SELECT * FROM Customers WHERE [email] = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, email);
            ResultSet rs = stm.executeQuery();
            return rs.next(); // Trả về true nếu tồn tại
        } catch (SQLException ex) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public int count() {
        try {
            String sql = "SELECT count(*) as [count] FROM Customers";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException ex) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public Customer getCustomerByEmail(String email) {
        try {
            String sql = "SELECT * FROM Customers WHERE email=?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Customer account = new Customer();
                account.setId(rs.getInt("ID"));
                account.setUsername(rs.getString("username"));
                account.setPassword(rs.getString("password"));
                account.setFullname(rs.getString("fullname"));
                account.setPhone(rs.getString("phone"));
                account.setEmail(rs.getString("email"));
                account.setAddress(rs.getString("address"));
                account.setGender(rs.getString("gender"));
                account.setAvatarUrl(rs.getString("avatarUrl")); // Thiết lập avatarUrl
                return account;
            }
        } catch (SQLException ex) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public Customer getByEmailAndPassword(String email, String password) {
        try {
            String sql = "SELECT * FROM Customers WHERE email=? and password=?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Customer account = new Customer();
                account.setId(rs.getInt("ID"));
                account.setUsername(rs.getString("username"));
                account.setPassword(rs.getString("password"));
                account.setFullname(rs.getString("fullname"));
                account.setPhone(rs.getString("phone"));
                account.setEmail(rs.getString("email"));
                account.setAddress(rs.getString("address"));
                account.setGender(rs.getString("gender"));
                account.setAvatarUrl(rs.getString("avatarUrl")); // Thiết lập avatarUrl
                return account;
            }
        } catch (SQLException ex) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public List<Customer> getCustomerList() {
        List<Customer> listC = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Customers";
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setId(rs.getInt("ID"));
                customer.setUsername(rs.getString("username"));
                customer.setPassword(rs.getString("password"));
                customer.setFullname(rs.getString("fullname"));
                customer.setPhone(rs.getString("phone"));
                customer.setEmail(rs.getString("email"));
                customer.setAddress(rs.getString("address"));
                customer.setGender(rs.getString("gender"));
                customer.setAvatarUrl(rs.getString("avatarUrl")); // Thiết lập avatarUrl
                listC.add(customer);

            }

        } catch (SQLException ex) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return listC;
    }

    public void updateCustomerStatus(String customerEmail, boolean isActive) {
        String sql = "UPDATE Customers SET isActive = ? WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setString(2, customerEmail);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean checkActive(String email) {
        try {
            String sql = "select * from Customers where email = ? and isActive = 'true'";
            ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

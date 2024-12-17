/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import com.oracle.wls.shaded.org.apache.bcel.generic.AALOAD;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Admin;

/**
 *
 * @author DELL
 */
public class AdminDAO extends DBContext {

    public List<Admin> getAllStaff() {
        List<Admin> list = new ArrayList<>();
        String sql = "SELECT * FROM Admins where [role]=" + 4;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Admin a = new Admin();
                a.setId(rs.getInt("ID"));
                a.setRole(1);
                a.setUsername(rs.getString("username"));
                list.add(a);
            }
        } catch (SQLException e) {
        }
        return list;
    }

    public void createStaff(String username, String password) {
        String sql = "insert into Admins (username,[password],[role])\n"
                + "Values(?,?,1\n"
                + ")";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.executeUpdate();
        } catch (Exception e) {
        }
    }

    public void deleteStaff(String username) {
        String sql = "delete from Admins where username=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.executeUpdate();
        } catch (Exception e) {
        }
    }

    public boolean checkUsernameExist(String u) {
        try {
            String sql = "SELECT * FROM Admins where [username] = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, u);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public Admin getByUserNamePassword(String u, String p) {
        try {
            String sql = "Select * from Admins where username = ? and password = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, u);
            ps.setString(2, p);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Admin account = new Admin();
                account.setId(rs.getInt(1));
                account.setUsername(u);
                account.setPassword(p);
                account.setRole(rs.getInt("role"));
                return account;
            }
            rs.close();
        } catch (SQLException ex) {
        }
        return null;
    }

    public List<Admin> getAllAdmins() {
        List<Admin> list = new ArrayList<>();
        String sql = "SELECT * FROM Admins";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Admin a = new Admin();
                a.setId(rs.getInt("ID"));
                a.setRole(rs.getInt("role"));
                a.setUsername(rs.getString("username"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addAdmin(Admin admin) throws SQLException {
        String sql = "INSERT INTO Admins (username, password, role) VALUES (?, ?, ?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, admin.getUsername());
            ps.setString(2, admin.getPassword());
            ps.setInt(3, admin.getRole());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    public void updateAdmin(Admin admin) {
        String sql = "UPDATE Admins SET username = ?, role = ? WHERE id = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, admin.getUsername());
            statement.setInt(2, admin.getRole());
            statement.setInt(3, admin.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteAdmin(int id) {
        String sql = "DELETE FROM Admins WHERE id = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public Admin getAdminById(int id) throws SQLException {
        Admin admin = null;
        String sql = "SELECT * FROM Admins WHERE id = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                admin = new Admin();
                admin.setId(resultSet.getInt("id"));
                admin.setUsername(resultSet.getString("username"));
                admin.setRole(resultSet.getInt("role"));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return admin;
    }

    public String getStaffNameById(int id) {
        String sql = "select username from Admins where ID = ?";
        String username = "";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                username = rs.getString("username");
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return username;
    }

    public void promote(String username) {
        String sql = "update Admins set [role]=0 where username=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.executeUpdate();
        } catch (Exception e) {
        }
    }

    public List<Admin> searchAdmins(String username, int role) {
        List<Admin> admins = new ArrayList<>();
        String sql = "SELECT * FROM Admins WHERE username LIKE ?";

        if (role != -1) {
            sql += " AND role = ?";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + username + "%");

            if (role != -1) {
                ps.setInt(2, role);
            }

            try {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Admin admin = new Admin();
                    admin.setId(rs.getInt("id"));
                    admin.setUsername(rs.getString("username"));
                    admin.setRole(rs.getInt("role"));
                    admins.add(admin);
                }
            } catch (SQLException e) {
                System.out.println(e);

            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return admins;
    }

    public static void main(String[] args) {
        AdminDAO dao = new AdminDAO();
        List<Admin> list = dao.searchAdmins("kim", -1);
        for (Admin admin : list) {
            System.out.println(admin);
        }
    }

}

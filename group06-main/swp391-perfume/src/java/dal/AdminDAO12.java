/*
     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
     * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Admin;
import model.Selling;
import model.Stock;

/**
 *
 * @author DELL
 */
public class AdminDAO12 extends DBContext {

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

    // Lấy tổng số sản phẩm
    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) FROM Perfumes"; // Thay thế bảng sản phẩm của bạn, ở đây là Perfumes
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy tổng số khách hàng
    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) FROM Customers";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy xu hướng khách hàng mới trong 7 ngày gần nhất
    public int[] getCustomerTrend() {
        String sql = "SELECT COUNT(*) as customerCount FROM Customers WHERE DATEDIFF(day, signupDate, GETDATE()) <= 7 GROUP BY signupDate";
        int[] trendData = new int[7];
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            int index = 0;
            while (rs.next() && index < 7) {
                trendData[index] = rs.getInt("customerCount");
                index++;
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trendData;
    }

    // Lấy tổng số đơn hàng
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM Orders";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Selling> getSalesBetweenDates(String startDate, String endDate) {
        List<Selling> list = new ArrayList<>();
        String sql = "SELECT SUM(od.quantity * price) as 'totalprice', orderdate "
                + "FROM Orders o, OrderDetails od, Perfumes p "
                + "WHERE o.ID = od.oid AND o.status = 'complete' AND p.ID = od.pid "
                + "AND orderdate BETWEEN ? AND ? "
                + "GROUP BY orderdate ORDER BY orderdate";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, startDate); // Ensure the date format matches SQL format (yyyy-MM-dd)
            ps.setString(2, endDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Selling s = new Selling();
                s.setDate(rs.getDate("orderdate"));  // Store the order date
                s.setTotalprice(rs.getInt("totalprice")); // Store the total price of the order
                list.add(s);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Stock> getTopStockBetweenDates(String startDate, String endDate) {
        List<Stock> list = new ArrayList<>();
        String sql = "SELECT SUM(od.quantity) as [count], p.name "
                + "FROM OrderDetails od, Perfumes p, Orders o "
                + "WHERE o.ID = od.oid AND o.status = 'complete' AND p.ID = od.pid "
                + "AND orderdate BETWEEN ? AND ? "
                + "GROUP BY p.name ORDER BY [count] DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, startDate); // Ensure date is in correct SQL format
            ps.setString(2, endDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Stock s = new Stock();
                s.setPerfume_name(rs.getString("name"));
                s.setQuantity(rs.getInt("count"));
                list.add(s);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy doanh thu mà không lọc theo ngày
    public List<Selling> getAllSales() {
        List<Selling> list = new ArrayList<>();
        String sql = "SELECT sum(od.quantity*price) as 'totalprice', orderdate "
                + "FROM Orders o, OrderDetails od, Perfumes p "
                + "WHERE o.ID=od.oid AND o.status='complete' AND p.ID=od.pid "
                + "GROUP BY orderdate ORDER BY orderdate";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Selling s = new Selling();
                s.setDate(rs.getDate("orderdate"));
                s.setTotalprice(rs.getInt("totalprice"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    // Lấy sản phẩm bán chạy nhất mà không lọc theo ngày
    public List<Stock> getAllTopStock() {
        List<Stock> list = new ArrayList<>();
        String sql = "SELECT sum(od.quantity) as [count], p.name "
                + "FROM OrderDetails od, Perfumes p, Orders o "
                + "WHERE o.ID=od.oid AND o.status='complete' AND p.ID=od.pid "
                + "GROUP BY p.name ORDER BY [count] DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Stock s = new Stock();
                s.setPerfume_name(rs.getString("name"));
                s.setQuantity(rs.getInt("count"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    // Lấy tổng doanh thu từ đơn hàng
    public int getTotalRevenue() {
        String sql = "SELECT SUM(p.price * od.quantity) FROM Orders o JOIN OrderDetails od ON o.ID = od.oid JOIN Perfumes p ON p.ID = od.pid";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}

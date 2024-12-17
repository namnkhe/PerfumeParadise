/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.util.List;
import model.CartDetail;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Perfume;

/**
 *
 * @author DELL
 */
public class CartDAO extends DBContext {

    public List<CartDetail> getCartDetailsByCusId(int cusid) {
        List<CartDetail> list = new ArrayList<>();
        try {
            String sql = "SELECT * from CartDetails where cusid=" + cusid;
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                CartDetail c = new CartDetail();
                c.setId(rs.getInt("ID"));
                c.setCusid(cusid);
                PerfumeDAO pdao = new PerfumeDAO();
                Perfume p = pdao.getPerfumeById(rs.getInt("pid"));
                c.setPerfume(p);
                c.setQuantity(rs.getInt("quantity"));
                list.add(c);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public void addPerfume(int cusid, int pid, int quantity) {
        try {
            String sql = "insert into CartDetails (cusid,pid,quantity)\n"
                    + "Values(?,?,?\n"
                    + ")";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, cusid);
            statement.setInt(2, pid);
            statement.setInt(3, quantity);
            statement.executeUpdate();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public void removeCartDetailById(int id) {
        try {
            String sql = "delete from CartDetails \n"
                    + "where ID=" + id;
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.executeUpdate();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public boolean updateCartDetailById(int id, int quantity) {
        try {
            String sql = "update CartDetails \n set quantity=? "
                    + "where ID=" + id;
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, quantity);
            statement.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

    public int getTotalPriceByCustomerId(int cusid) {
        int totalPrice = 0;  // Khởi tạo giá trị tổng tiền
        try {
            // Câu truy vấn để tính tổng tiền giỏ hàng của một khách hàng
            String sql = "SELECT SUM(c.quantity * p.price) AS totalPrice "
                    + "FROM CartDetails c JOIN Perfumes p ON c.pid = p.ID "
                    + "WHERE c.cusid = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, cusid);  // Thiết lập giá trị customerId cho câu truy vấn

            // Thực thi câu truy vấn và nhận kết quả
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                totalPrice = rs.getInt("totalPrice");  // Lấy tổng tiền từ kết quả truy vấn
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return totalPrice;  // Trả về tổng tiền
    }

    public void deleteCartByCustomerId(int cusid) {
        try {
            String sql = "delete from CartDetails \n "
                    + "where cusid=" + cusid;
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.executeUpdate();
        } catch (Exception e) {
            System.out.println(e);
        }
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.util.List;
import model.Admin;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author phida
 */
public class UserDAO extends DBContext {

    public List<Admin> getAllOrderByCusId(int cusid) {
        List<Admin> list = new ArrayList<>();
        try {
            String sql = "SELECT * from Orders where cusid=" + cusid;
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                Admin a = new Admin();
                a.setId(rs.getInt("ID"));
                a.setUsername(rs.getString("username"));
                a.setPassword(rs.getString("password"));
                a.setRole(rs.getInt("role"));
                list.add(a);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;

    }
}


/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Brand;

/**
 *
 * @author chi
 */
public class BrandDAO extends DBContext {

    public List<Brand> getAllBrand() {
        List<Brand> list = new ArrayList<>();

        try {
            String sql = "SELECT * FROM Brands";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                Brand a = new Brand();
                a.setId(rs.getInt(1));
                a.setName(rs.getString(2));
                a.setImage(rs.getString(3));
                list.add(a);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public Brand getBrandById(int id) {
        String sql = " select * from .[dbo].[Brands] \n"
                + "  where ID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Brand a = new Brand();
                a.setId(rs.getInt("ID"));
                a.setImage(rs.getString("image"));
                a.setName(rs.getString("name"));
                return a;
            }
        } catch (Exception e) {
        }
        return null;
    }

    public void addBrand(String name, String image) {
        String sql = "Insert into [dbo].[Brands]\n"
                + "   (name,image)"
                + " values(?,?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = connection;
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, image);
            ps.executeUpdate();
        } catch (Exception e) {
        }
    }
}

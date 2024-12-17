package dal;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import model.Perfume;

public class PerfumeDAO extends DBContext {

    PreparedStatement stm;
    ResultSet rs;

    public int count() {
        try {
            String sql = "SELECT count(*) as [count] FROM Perfumes";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    public List<Perfume> getAllPerfume() {
        List<Perfume> list = new ArrayList<>();
        try {
            String sql = "SELECT * from Perfumes";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                Perfume a = new Perfume();
                BrandDAO bdao = new BrandDAO();
                CategoryDAO catedao = new CategoryDAO();
                a.setId(rs.getInt(1));
                a.setBrand(bdao.getBrandById(rs.getInt("bid")));
                a.setCategory(catedao.getCateById(rs.getInt("cid")));
                a.setImage(rs.getString("image"));
                a.setName(rs.getString("name"));
                a.setQuantity(rs.getInt("quantity"));
                a.setSize(rs.getInt("size"));
                a.setReleaseDate(rs.getString("releaseDate"));
                a.setPrice(rs.getInt("price"));
                a.setDescription(rs.getString("description")); // Thêm phần mô tả
                // Set Hold and ImportPrice
                a.setHold(rs.getInt("Hold"));
                a.setImportPrice(rs.getInt("ImportPrice"));
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Perfume> getLastPerfume() {
        List<Perfume> list = new ArrayList<>();
        try {
            String sql = "SELECT top 4 * FROM Perfumes  WHERE active = 1 ORDER BY releaseDate desc";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                Perfume a = new Perfume();
                BrandDAO bdao = new BrandDAO();
                CategoryDAO catedao = new CategoryDAO();
                a.setId(rs.getInt(1));
                a.setBrand(bdao.getBrandById(rs.getInt("bid")));
                a.setCategory(catedao.getCateById(rs.getInt("cid")));
                a.setImage(rs.getString("image"));
                a.setName(rs.getString("name"));
                a.setQuantity(rs.getInt("quantity"));
                a.setSize(rs.getInt("size"));
                a.setReleaseDate(rs.getString("releaseDate"));
                a.setPrice(rs.getInt("price"));
                a.setDescription(rs.getString("description")); // Thêm phần mô tả
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ArrayList<Perfume> getPerfumeByFilter(Integer cid, Integer bid, Double minimumprice, Double maximumprice, Date fromdate, Date todate) {
        ArrayList<Perfume> list = new ArrayList<>();
        String sql = "select * from [Perfumes] p where 1=1";
        if (cid != null && cid > 0) {
            sql += " and cid=" + cid;
        }
        if (bid != null && bid > 0) {
            sql += " and bid=" + bid;
        }
        if (fromdate != null) {
            sql += " and releaseDate>='" + fromdate + "'";
        }
        if (todate != null) {
            sql += " and releaseDate<='" + todate + "'";
        }
        if (minimumprice != null) {
            sql += " and price>=" + minimumprice;
        }
        if (maximumprice != null) {
            sql += " and price<=" + maximumprice;
        }
        try {
            Connection conn = connection;
            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Perfume a = new Perfume();
                a.setId(rs.getInt(1));
                BrandDAO bdao = new BrandDAO();
                CategoryDAO catedao = new CategoryDAO();
                a.setBrand(bdao.getBrandById(rs.getInt("bid")));
                a.setCategory(catedao.getCateById(rs.getInt("cid")));
                a.setImage(rs.getString("image"));
                a.setName(rs.getString("name"));
                a.setQuantity(rs.getInt("quantity"));
                a.setSize(rs.getInt("size"));
                a.setReleaseDate(rs.getString("releaseDate"));
                a.setPrice(rs.getInt("price"));

                list.add(a);
            }
        } catch (Exception e) {
        }
        return list;
    }

    public List<Perfume> getPerfumesByBrand(int bid) {
        List<Perfume> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Perfumes where bid = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, bid);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                Perfume a = new Perfume();
                BrandDAO bdao = new BrandDAO();
                CategoryDAO catedao = new CategoryDAO();
                a.setId(rs.getInt(1));
                a.setBrand(bdao.getBrandById(rs.getInt("bid")));
                a.setCategory(catedao.getCateById(rs.getInt("cid")));
                a.setImage(rs.getString("image"));
                a.setName(rs.getString("name"));
                a.setQuantity(rs.getInt("quantity"));
                a.setSize(rs.getInt("size"));
                a.setReleaseDate(rs.getString("releaseDate"));
                a.setPrice(rs.getInt("price"));
                a.setDescription(rs.getString("description")); // Thêm phần mô tả
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Perfume> getTopSellingPerfume() {
        List<Perfume> list = new ArrayList<>();
        try {
            String sql = "with t as (select top 4 sum(quantity) as totalquantity,pid from OrderDetails where oid in(select ID from Orders where [status]='complete') group by pid order by totalquantity desc)\n"
                    + "select * from Perfumes where ID in (select pid from t)";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                Perfume a = new Perfume();
                BrandDAO bdao = new BrandDAO();
                CategoryDAO catedao = new CategoryDAO();
                a.setId(rs.getInt(1));
                a.setBrand(bdao.getBrandById(rs.getInt("bid")));
                a.setCategory(catedao.getCateById(rs.getInt("cid")));
                a.setImage(rs.getString("image"));
                a.setName(rs.getString("name"));
                a.setQuantity(rs.getInt("quantity"));
                a.setSize(rs.getInt("size"));
                a.setPrice(rs.getInt("price"));
                a.setReleaseDate(rs.getString("releaseDate"));
                a.setDescription(rs.getString("description")); // Thêm phần mô tả
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Perfume getPerfumeById(int pid) {
        String sql = "SELECT * FROM [Perfumes] WHERE ID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, pid);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Perfume a = new Perfume();
                BrandDAO bdao = new BrandDAO();
                CategoryDAO catedao = new CategoryDAO();
                a.setId(rs.getInt(1));
                a.setBrand(bdao.getBrandById(rs.getInt("bid")));
                a.setCategory(catedao.getCateById(rs.getInt("cid")));
                a.setImage(rs.getString("image"));
                a.setName(rs.getString("name"));
                a.setQuantity(rs.getInt("quantity"));
                a.setSize(rs.getInt("size"));
                a.setPrice(rs.getInt("price"));
                a.setReleaseDate(rs.getString("releaseDate"));
                a.setDescription(rs.getString("description")); // Thêm phần mô tả
                // Thêm phần hold và importprice
                a.setHold(rs.getInt("hold")); // Đảm bảo Perfume class có setter cho hold
                a.setImportPrice(rs.getInt("importprice")); // Đảm bảo Perfume class có setter cho importprice
                return a;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void UpdatePerfume1(int id, String name, int price, int size, int quantity, int cid, int bid) {
        String sql = "UPDATE [dbo].[Perfumes]\n"
                + "   SET [cid] = ?\n"
                + "      ,[bid] = ?\n"
                + "      ,[name] = ?\n"
                + "      ,[size] = ?\n"
                + "      ,[price] = ?\n"
                + "      ,[quantity] = ?\n"
                + " WHERE ID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = connection;
            ps = conn.prepareStatement(sql);
            ps.setInt(1, cid);
            ps.setInt(2, bid);
            ps.setString(3, name);
            ps.setInt(4, size);
            ps.setInt(5, price);
            ps.setInt(6, quantity);
            ps.setInt(7, id);
            ps.executeUpdate();
        } catch (Exception e) {
        }
    }

    public void updateHold(int Id, int Hold) {
        String sql = "UPDATE [dbo].[Perfumes] SET hold = ? WHERE ID = ?";
        try (Connection conn = connection; PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, Hold);
            ps.setInt(2, Id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Perfume> getAllPerfumePaging(int pageIndex, int pageSize) {
        List<Perfume> list = new ArrayList<>();
        String sql = "SELECT * FROM ( "
                + "SELECT ROW_NUMBER() OVER (ORDER BY ID) as rownum, * "
                + "FROM Perfumes "
                + ") as temp WHERE rownum BETWEEN ? AND ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            // Tính toán vị trí bắt đầu và kết thúc của trang hiện tại
            int start = (pageIndex - 1) * pageSize + 1;
            int end = pageIndex * pageSize;
            statement.setInt(1, start);
            statement.setInt(2, end);

            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                Perfume a = new Perfume();
                BrandDAO bdao = new BrandDAO();
                CategoryDAO catedao = new CategoryDAO();
                a.setId(rs.getInt("ID"));
                a.setBrand(bdao.getBrandById(rs.getInt("bid")));
                a.setCategory(catedao.getCateById(rs.getInt("cid")));
                a.setImage(rs.getString("image"));
                a.setName(rs.getString("name"));
                a.setQuantity(rs.getInt("quantity"));
                a.setSize(rs.getInt("size"));
                a.setPrice(rs.getInt("price"));
                a.setReleaseDate(rs.getString("releaseDate"));
                a.setDescription(rs.getString("description"));
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void UpdatePerfume2(int id, String name, int price, int size, int quantity, int hold, int cid, int bid) {
        String sql = "UPDATE [dbo].[Perfumes]\n"
                + "   SET [cid] = ?,\n"
                + "       [bid] = ?,\n"
                + "       [name] = ?,\n"
                + "       [size] = ?,\n"
                + "       [price] = ?,\n"
                + "       [quantity] = ?,\n"
                + "       [hold] = ?\n" // Thêm hold vào câu lệnh SQL
                + " WHERE ID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = connection;
            ps = conn.prepareStatement(sql);
            ps.setInt(1, cid);
            ps.setInt(2, bid);
            ps.setString(3, name);
            ps.setInt(4, size);
            ps.setInt(5, price);
            ps.setInt(6, quantity);
            ps.setInt(7, hold); // Truyền giá trị hold vào đây
            ps.setInt(8, id);   // Truyền ID ở cuối

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace(); // In ra lỗi nếu có
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void updatePerfumeForInventoryStaff(int id, int quantity, int hold, int importPrice, int price, int size) {
        String sql = "UPDATE [dbo].[Perfumes] "
                + "SET quantity = ?, hold = ?, importPrice = ?, price = ?, size = ? "
                + "WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = connection;
            ps = conn.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, hold);
            ps.setInt(3, importPrice);
            ps.setInt(4, price);
            ps.setInt(5, size);
            ps.setInt(6, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void UpdatePerfume(int id, String name, int price, int size, int quantity, int cid, int bid, String description) {
        String sql = "UPDATE [dbo].[Perfumes]\n"
                + "SET [cid] = ?, [bid] = ?, [name] = ?, [size] = ?, [price] = ?, [quantity] = ?, [description] = ?\n"
                + "WHERE ID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, cid);
            ps.setInt(2, bid);
            ps.setString(3, name);
            ps.setInt(4, size);
            ps.setInt(5, price);
            ps.setInt(6, quantity);
            ps.setString(7, description); // Thêm description
            ps.setInt(8, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void UpdatePerfume5(int id, String name, int price, int size, int cid, int bid, String description) {
        String sql = "UPDATE [dbo].[Perfumes]\n"
                + "SET [cid] = ?, [bid] = ?, [name] = ?, [size] = ?, [price] = ?, [description] = ?\n"
                + "WHERE ID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, cid);
            ps.setInt(2, bid);
            ps.setString(3, name);
            ps.setInt(4, size);
            ps.setInt(5, price);
            ps.setString(6, description); // Thêm description
            ps.setInt(7, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void addPerfume1(String name, int price, int size, int cid, int bid, Date releaseDate, String image, String description) {
        String sql = "INSERT INTO [dbo].[Perfumes] (cid, bid, name, size, price, releaseDate, image, description, quantity) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, cid);
            ps.setInt(2, bid);
            ps.setString(3, name);
            ps.setInt(4, size);
            ps.setInt(5, price);
            ps.setDate(6, releaseDate);
            ps.setString(7, image);
            ps.setString(8, description);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void addPerfume(String name, int price, int size, int quantity, int cid, int bid, Date releaseDate, String image, String description) {
        String sql = "INSERT INTO [dbo].[Perfumes] (cid, bid, name, size, price, quantity, releaseDate, image, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, cid);
            ps.setInt(2, bid);
            ps.setString(3, name);
            ps.setInt(4, size);
            ps.setInt(5, price);
            ps.setInt(6, quantity);
            ps.setDate(7, releaseDate);
            ps.setString(8, image);
            ps.setString(9, description); // Thêm description
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ArrayList<Perfume> getPerfume() {

        ArrayList<Perfume> list = new ArrayList<>();
        String sql = "SELECT * FROM [Perfumes]";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = connection;
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Perfume a = new Perfume();
                BrandDAO bdao = new BrandDAO();
                CategoryDAO catedao = new CategoryDAO();
                a.setId(rs.getInt("ID"));
                a.setBrand(bdao.getBrandById(rs.getInt("bid")));
                a.setCategory(catedao.getCateById(rs.getInt("cid")));
                a.setImage(rs.getString("image"));
                a.setName(rs.getString("name"));
                a.setQuantity(rs.getInt("quantity"));
                a.setSize(rs.getInt("size"));
                a.setPrice(rs.getInt("price"));
                a.setReleaseDate(rs.getString("releaseDate"));
                a.setDescription(rs.getString("description")); // Thêm description
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return list;
    }

    public void hidePerfume(int id) {
        String sql = "UPDATE [Perfumes] SET active = 0 WHERE ID = ?"; // Assuming you have an 'active' column
        try (Connection conn = connection; PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int getAllPerfume1() {
        int total = 0;  // Biến để lưu tổng số lượng nước hoa
        try {
            String sql = "SELECT COUNT(*) AS total FROM Perfumes";  // Câu lệnh SQL để đếm số lượng sản phẩm nước hoa
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");  // Lấy số lượng từ kết quả truy vấn
            }
        } catch (SQLException e) {
            e.printStackTrace();  // In ra lỗi nếu có
        }
        return total;  // Trả về tổng số lượng nước hoa
    }

    public void importPerfume(int productId, double importPrice, int size, int quantity) {
        String sql = "UPDATE Perfumes SET quantity = quantity + ?, ImportPrice = ? WHERE ID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setDouble(2, importPrice);
            ps.setInt(3, productId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Perfume> searchKeyword(String keyword) {
        String sql = "SELECT * FROM Perfumes p WHERE p.name LIKE N'%" + keyword + "%'\n"
                + "UNION\n"
                + "(SELECT * FROM Perfumes x WHERE x.bid IN (SELECT ID FROM Brands b WHERE b.name LIKE N'%" + keyword + "%'))\n"
                + "UNION\n"
                + "(SELECT * FROM Perfumes y WHERE y.cid IN (SELECT ID FROM Categories c WHERE c.name LIKE N'%" + keyword + "%'))";

        List<Perfume> list = new ArrayList<>();
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                Perfume a = new Perfume();
                BrandDAO bdao = new BrandDAO();
                CategoryDAO catedao = new CategoryDAO();
                a.setId(rs.getInt("ID"));
                a.setBrand(bdao.getBrandById(rs.getInt("bid")));
                a.setCategory(catedao.getCateById(rs.getInt("cid")));
                a.setImage(rs.getString("image"));
                a.setName(rs.getString("name"));
                a.setQuantity(rs.getInt("quantity"));
                a.setSize(rs.getInt("size"));
                a.setPrice(rs.getInt("price"));
                a.setReleaseDate(rs.getString("releaseDate"));
                a.setDescription(rs.getString("description")); // Thêm description
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }

        return list;
    }

}

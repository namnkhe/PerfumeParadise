/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.Address;
import model.Customer;
import model.Order;

/**
 *
 * @author chi
 */
public class OrderDAO extends DBContext {

    PreparedStatement stm;
    ResultSet rs;

    public void insertOrder(int id, int cusid, String address, String paymentMethod, boolean paymentStatus, long totalAmount) {
        try {
            // Câu lệnh SQL để chèn dữ liệu vào bảng Orders
            String sql = "INSERT INTO Orders (ID, cusid, [address], orderdate, [status], paymentMethod, paymentStatus, totalAmount) "
                    + "VALUES (?, ?, ?, ?, 'confirming', ?, ?, ?)";

            java.sql.Date currentDate = new java.sql.Date(new Date().getTime()); // Lấy ngày hiện tại

            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);                 // ID của đơn hàng
            stm.setInt(2, cusid);              // ID khách hàng
            stm.setString(3, address);         // Địa chỉ giao hàng
            stm.setDate(4, currentDate);       // Ngày đặt hàng
            stm.setString(5, paymentMethod);   // Phương thức thanh toán (VNPay, COD, ...)
            stm.setBoolean(6, paymentStatus);  // Trạng thái thanh toán (true = đã thanh toán, false = chưa thanh toán)
            stm.setLong(7, totalAmount);        // Tổng số tiền của đơn hàng

            stm.executeUpdate();               // Thực thi câu truy vấn
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public List<Order> getAllOrderByCusId(int cusid) {
        List<Order> list = new ArrayList<>();
        try {
            String sql = "SELECT * from Orders where cusid=" + cusid;
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            while (rs.next()) {
                Order c = new Order();
                c.setId(rs.getInt("ID"));
                CustomerDAO cus = new CustomerDAO();
                c.setCustomer(cus.getByCusId(cusid));
                c.setAddress(rs.getString("address"));
                c.setOrderdate(rs.getDate("orderdate"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;

    }

    public Order getOrderById(int id) {
        String sql = "SELECT o.ID as orderId, o.address as orderAddress, o.orderdate, o.status, "
                + "c.ID as customerId, c.username, c.password, c.fullname, c.phone, c.email, "
                + "c.address as customerAddress, c.gender, c.avatarUrl "
                + "FROM Orders o "
                + "JOIN Customers c ON o.cusid = c.ID "
                + "WHERE o.ID = ?";
        Order order = null;

        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id); // Set the ID parameter
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                // Create and populate Order object
                order = new Order();
                order.setId(rs.getInt("orderId"));
                order.setAddress(rs.getString("orderAddress"));
                order.setOrderdate(rs.getDate("orderdate"));
                order.setStatus(rs.getString("status"));

                // Create and populate Customer object
                Customer customer = new Customer();
                customer.setId(rs.getInt("customerId"));
                customer.setUsername(rs.getString("username"));
                customer.setPassword(rs.getString("password"));
                customer.setFullname(rs.getString("fullname"));
                customer.setPhone(rs.getString("phone"));
                customer.setEmail(rs.getString("email"));
                customer.setAddress(rs.getString("customerAddress"));
                customer.setGender(rs.getString("gender"));
                customer.setAvatarUrl(rs.getString("avatarUrl"));

                // Set the Customer object in the Order
                order.setCustomer(customer);
            }
        } catch (SQLException e) {
            System.out.println("Error in getOrderById: " + e.getMessage());
        } finally {
            // Close resources to avoid leaks
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stm != null) {
                    stm.close();
                }
            } catch (Exception e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }
        return order;
    }

    public int getLastOrderId() {
        try {
            String sql = "SELECT MAX(ID) from Orders";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return 0;
    }

    public void changeOrderStatusById(int id, String status) {
        try {
            String sql = "update Orders set status = ? where ID=" + id;
            stm = connection.prepareStatement(sql);
            stm.setString(1, status);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void removeOrderById(int id) {
        try {
            String sql = "delete from Orders where ID=" + id;
            stm = connection.prepareStatement(sql);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        try {
            String sql = "SELECT * from Orders";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            while (rs.next()) {
                Order c = new Order();
                c.setId(rs.getInt("ID"));
                CustomerDAO cus = new CustomerDAO();
                c.setCustomer(cus.getByCusId(rs.getInt("cusid")));
                c.setAddress(rs.getString("address"));
                c.setOrderdate(rs.getDate("orderdate"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public int count() {
        try {
            String sql = "SELECT count(*) as [count] FROM Orders where [status]='complete'";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException ex) {
        }
        return 0;
    }

    public List<Order> getOrderByStatus(String status) {
        List<Order> list = new ArrayList<>();
        try {
            String sql = "SELECT * from Orders where [status] = ?";
            stm = connection.prepareStatement(sql);
            stm.setString(1, status);
            rs = stm.executeQuery();
            while (rs.next()) {
                Order c = new Order();
                c.setId(rs.getInt("ID"));
                CustomerDAO cus = new CustomerDAO();
                c.setCustomer(cus.getByCusId(rs.getInt("cusid")));
                c.setAddress(rs.getString("address"));
                c.setOrderdate(rs.getDate("orderdate"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<Order> getOrderByStatus1(String status) {
        List<Order> list = new ArrayList<>();
        try {
            String sql = "SELECT * from Orders o join OrderDetails od on o.ID=od.oid\n"
                    + "	where [status] = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                Order c = new Order();
                c.setId(rs.getInt("ID"));
                CustomerDAO cus = new CustomerDAO();
                c.setCustomer(cus.getByCusId(rs.getInt("cusid")));
                c.setAddress(rs.getString("address"));
                c.setOrderdate(rs.getDate("orderdate"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public void changePaymentStatus(int id, boolean status) {
        try {
            String sql = "update Orders set paymentStatus = ? where ID=" + id;
            stm = connection.prepareStatement(sql);
            stm.setBoolean(1, status);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public List<Order> getFilteredOrders(int id, String address, String orderDate, String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE cusid = ?";
        List<Object> params = new ArrayList<>();
        params.add(id);

        if (address != null && !address.isEmpty()) {
            sql += " AND (address LIKE ? OR address LIKE ? OR address LIKE ? OR SOUNDEX(address) = SOUNDEX(?))";
            params.add(address + "%"); // Starts with
            params.add("%" + address); // Ends with
            params.add("%" + address + "%"); // Contains
            params.add(address); // Soundex match for similar-sounding addresses
        }
        if (orderDate != null && !orderDate.isEmpty()) {
            sql += " AND orderdate = ?";
            params.add(orderDate);
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND status = ?";
            params.add(status);
        }

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                // Populate order details from result set
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public int getTotalOrderCount() {
        int total = 0;

        try {
            String sql = "select count(*) as total from Orders";
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

    public List<Order> getPaginatedOrders(int start, int ordersPerPage) {
        List<Order> listO = new ArrayList<>();

        try {
            String sql = "SELECT * FROM orders ORDER BY orderdate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, start);
            stm.setInt(2, ordersPerPage);
            rs = stm.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("ID"));
                CustomerDAO cus = new CustomerDAO();
                o.setCustomer(cus.getByCusId(rs.getInt("cusid")));
                o.setAddress(rs.getString("address"));
                o.setOrderdate(rs.getDate("orderdate"));
                o.setStatus(rs.getString("status"));
                listO.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listO;
    }

    public List<Address> getPastOrderAddressByCusID(int customerID) {
        List<Address> listA = new ArrayList<>();

        try {
            String sql = "SELECT * \n"
                    + "FROM (\n"
                    + "    SELECT *, ROW_NUMBER() OVER(PARTITION BY address ORDER BY orderdate DESC) AS row_num\n"
                    + "    FROM [dbo].[Orders]\n"
                    + "    WHERE cusid = ?\n" // Added condition to filter by customer ID
                    + ") AS subquery\n"
                    + "WHERE row_num = 1\n"
                    + "ORDER BY id DESC;";

            stm = connection.prepareStatement(sql);
            stm.setInt(1, customerID);  // Bind the customer ID parameter
            rs = stm.executeQuery();

            while (rs.next()) {
                String name = rs.getString("address"); // Column name for address
                String addedAt = String.valueOf(rs.getDate("orderdate")); // Column name for orderdate
                int cusID = rs.getInt("cusid"); // Column name for cusid
                Address a = new Address(name, addedAt, cusID);
                listA.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listA;
    }

    public List<Order> getOrdersByStaffId(int staffId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT DISTINCT o.*\n"
                + "FROM Orders o\n"
                + "INNER JOIN OrderDetails od ON o.id = od.oid\n"
                + "WHERE od.staffID = ?;";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, staffId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order c = new Order();
                c.setId(rs.getInt("ID"));
                CustomerDAO cus = new CustomerDAO();
                c.setCustomer(cus.getByCusId(rs.getInt("cusid")));
                c.setAddress(rs.getString("address"));
                c.setOrderdate(rs.getDate("orderdate"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}

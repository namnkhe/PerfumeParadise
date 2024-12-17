package model;

/**
 * Lớp đại diện cho thông tin người dùng
 *
 * @author DELL
 */
public class Customer {

    private int id;              // ID của người dùng
    private String username;     // Tên đăng nhập
    private String password;     // Mật khẩu
    private String fullname;     // Họ và tên
    private String gender;       // Giới tính
    private String phone;        // Số điện thoại
    private String email;        // Địa chỉ email
    private String address;      // Địa chỉ
    private String image;      // Đường dẫn tới ảnh đại diện
    private boolean isActive;

    public Customer() {
    }

    public Customer(int id, String username, String password, String fullname, String gender, String phone, String email, String address, String avatarURL, boolean isActive) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullname = fullname;
        this.gender = gender;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.image = image;
        this.isActive = isActive;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    // Phương thức getter và setter cho avatarUrl
    public String getAvatarUrl() {
        return image; // Sử dụng thuộc tính image như avatar
    }

    public void setAvatarUrl(String avatarUrl) {
        this.image = avatarUrl; // Cập nhật thuộc tính image
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

}

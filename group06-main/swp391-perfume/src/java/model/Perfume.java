package model;

import java.sql.Date;

public class Perfume {

    int id;
    String name;
    int quantity;
    int size;
    int price;
    String image;
    String releaseDate;
    String description; // Thêm trường description
    Brand brand;
    Category category;
    int hold;  // Số lượng sản phẩm đang được giữ
    int importPrice;  // Giá nhập kho

    public int getHold() {
        return hold;
    }

    public void setHold(int hold) {
        if (hold < 0) {
            this.hold = 0; // Đặt hold bằng 0 nếu hold được đặt âm
        } else if (hold > this.quantity) {
            this.hold = this.quantity; // Đặt hold bằng quantity nếu hold vượt quá
        } else {
            this.hold = hold; // Gán hold nếu hợp lệ
        }
    }

    // Tính toán AvailableQuantity
    public int getAvailableQuantity() {
        return quantity - hold; // Tính số lượng có sẵn
    }

    public int getImportPrice() {
        return importPrice;
    }

    public void setImportPrice(int importPrice) {
        this.importPrice = importPrice;
    }

    // Constructor mặc định
    public Perfume() {
    }

    // Constructor đầy đủ, bao gồm description
    public Perfume(int id, String name, int quantity, int size, int price, String image, String releaseDate, String description, Brand brand, Category category) {
        this.id = id;
        this.name = name;
        this.quantity = quantity;
        this.size = size;
        this.price = price;
        this.image = image;
        this.releaseDate = releaseDate;
        this.description = description; // Gán giá trị cho description
        this.brand = brand;
        this.category = category;
        this.hold = 0; // Khởi tạo hold mặc định là 0
    }

    // Getter và Setter cho tất cả các thuộc tính
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public Brand getBrand() {
        return brand;
    }

    public void setBrand(Brand brand) {
        this.brand = brand;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public String getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(String releaseDate) {
        this.releaseDate = releaseDate;
    }

    // Getter và Setter cho description
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}

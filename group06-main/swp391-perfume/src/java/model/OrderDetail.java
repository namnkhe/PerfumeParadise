/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author DELL
 */
public class OrderDetail {

    int id;
    Order order;
    Perfume perfume;
    int quantity;
    int staffID;

    public int getStaffID() {
        return staffID;
    }

    public void setStaffID(int staffID) {
        this.staffID = staffID;
    }

    public OrderDetail(int id, Order order, Perfume perfume, int quantity, int staffID) {
        this.id = id;
        this.order = order;
        this.perfume = perfume;
        this.quantity = quantity;
        this.staffID = staffID;
    }

    public int getTotal() {
        return this.quantity * this.perfume.price;
    }

    public OrderDetail(int id, Order order, Perfume perfume, int quantity) {
        this.id = id;
        this.order = order;
        this.perfume = perfume;
        this.quantity = quantity;
    }

    public OrderDetail() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public Perfume getPerfume() {
        return perfume;
    }

    public void setPerfume(Perfume perfume) {
        this.perfume = perfume;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

}

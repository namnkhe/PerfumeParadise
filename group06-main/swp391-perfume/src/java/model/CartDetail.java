/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author DELL
 */
public class CartDetail {

    int id;
    int cusid;
    Perfume p;
    int quantity;

    public CartDetail() {
    }

    public CartDetail(int id, int cusid, Perfume p, int quantity) {
        this.id = id;
        this.cusid = cusid;
        this.p = p;
        this.quantity = quantity;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCusid() {
        return cusid;
    }

    public void setCusid(int cusid) {
        this.cusid = cusid;
    }

    public Perfume getPerfume() {
        return p;
    }

    public void setPerfume(Perfume p) {
        this.p = p;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getTotal() {
        return this.quantity * this.p.price;
    }

}

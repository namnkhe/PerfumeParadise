/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author DELL
 */
public class Selling {

    int totalprice;
    Date orderdate;

    public Selling() {
    }

    public Selling(int totalprice, Date date) {
        this.totalprice = totalprice;
        this.orderdate = date;
    }

    public int getTotalprice() {
        return totalprice;
    }

    public void setTotalprice(int totalprice) {
        this.totalprice = totalprice;
    }

    public Date getDate() {
        return orderdate;
    }

    public void setDate(Date date) {
        this.orderdate = date;
    }

}

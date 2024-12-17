/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author phida
 */
public class Feedback {

    private int id;
    private Customer customer;
    private Perfume product;
    private String comment;
    private Date created_at;
    private int marketer_id;
    private String status;
    private int rating;

    public Feedback() {
    }

    public Feedback(int id, Customer customer, Perfume product, String comment, Date created_at, int marketer_id, String status, int rating) {
        this.id = id;
        this.customer = customer;
        this.product = product;
        this.comment = comment;
        this.created_at = created_at;
        this.marketer_id = marketer_id;
        this.status = status;
        this.rating = rating;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Perfume getProduct() {
        return product;
    }

    public void setProduct(Perfume product) {
        this.product = product;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }

    public int getMarketer_id() {
        return marketer_id;
    }

    public void setMarketer_id(int marketer_id) {
        this.marketer_id = marketer_id;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

}

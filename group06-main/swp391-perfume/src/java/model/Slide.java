/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author phida
 */
public class Slide {

    private int ID;
    private String title;
    private String image_url;
    private String description;
    private String link;
    private boolean is_active;
    private String create_at;
    private int author_id;

    public Slide() {
    }

    public Slide(int ID, String title, String image_url, String description, String link, boolean is_active, String create_at, int author_id) {
        this.ID = ID;
        this.title = title;
        this.image_url = image_url;
        this.description = description;
        this.link = link;
        this.is_active = is_active;
        this.create_at = create_at;
        this.author_id = author_id;
    }

    public Slide(int ID, String title, String image_url, String description, String link, boolean is_active, String create_at) {
        this.ID = ID;
        this.title = title;
        this.image_url = image_url;
        this.description = description;
        this.link = link;
        this.is_active = is_active;
        this.create_at = create_at;
        this.author_id = author_id;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public boolean isIs_active() {
        return is_active;
    }

    public void setIs_active(boolean is_active) {
        this.is_active = is_active;
    }

    public String getCreate_at() {
        return create_at;
    }

    public void setCreate_at(String create_at) {
        this.create_at = create_at;
    }

    public int getAuthor_id() {
        return author_id;
    }

    public void setAuthor_id(int author_id) {
        this.author_id = author_id;
    }

    @Override
    public String toString() {
        return "Slide{" + "ID=" + ID + ", title=" + title + ", image_url=" + image_url + ", description=" + description + ", link=" + link + ", is_active=" + is_active + ", create_at=" + create_at + ", author_id=" + author_id + '}';
    }

}

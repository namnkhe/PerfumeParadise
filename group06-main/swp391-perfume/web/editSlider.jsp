<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Slide" %>
<%@page import="dal.SliderDAO" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Slide</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .form-container {
                max-width: 600px;
                margin: auto;
                padding: 20px;
                border: 1px solid #ccc;
                border-radius: 5px;
                background-color: #f9f9f9;
            }

            .form-header {
                margin-bottom: 20px;
                text-align: center;
            }

            .slide-image {
                width: 150px; /* Resize the image */
                height: auto; /* Maintain aspect ratio */
                object-fit: cover; /* Ensure the image doesn't get distorted */
                border-radius: 5px; /* Optional: rounding corners */
                vertical-align: middle; /* Align vertically in the middle */
                margin-right: 10px; /* Add some space to the right of the image */
            }
        </style>
    </head>

    <body>
        <div class="form-container">
            <h2 class="form-header">Edit Slide</h2>
            <%
                Slide slide = (Slide) request.getAttribute("slider");
            %>
            <form action="SliderController" method="post">
                <input type="hidden" name="slideId" value="<%= slide.getID() %>">
                <input type="hidden" name="author_id" value="<%= slide.getAuthor_id() %>">

                <div class="mb-3">
                    <label for="slideTitle" class="form-label">Title:</label>
                    <input type="text" id="slideTitle" name="title" class="form-control" value="<%= slide.getTitle() %>" required>
                </div>

                <div class="mb-3">
                    <label for="imageUrl" class="form-label">Image URL:</label>
                    <input type="text" id="imageUrl" name="image_url" class="form-control" value="<%= slide.getImage_url() %>" required>
                </div>

                <!-- Display the current slide image -->
                <div class="mb-3">
                    <label for="currentImage" class="form-label" style="display: block">Current Image:</label>
                    <img src="<%= slide.getImage_url() %>" alt="Slide Image" class="slide-image">
                    <button type="button" class="btn btn-secondary mt-2" data-bs-toggle="modal" data-bs-target="#changeImageModal">Change Image</button>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Description:</label>
                    <textarea id="description" name="description" class="form-control" required><%= slide.getDescription() %></textarea>
                </div>

                <div class="mb-3">
                    <label for="link" class="form-label">Backlink:</label>
                    <input type="text" id="link" name="link" class="form-control" value="<%= slide.getLink() %>" required>
                </div>

                <div class="mb-3">
                    <label for="status" class="form-label">Status:</label>
                    <select id="status" name="is_active" class="form-select">
                        <option value="true" <%= slide.isIs_active() ? "selected" : "" %>>Active</option>
                        <option value="false" <%= !slide.isIs_active() ? "selected" : "" %>>Inactive</option>
                    </select>
                </div>

                <div class="d-flex justify-content-between">
                    <input type="submit" name="action" value="Edit Slide" class="btn btn-primary">
                    <a href="SliderController" class="btn btn-secondary">Back to Slide List</a>
                </div>
            </form>
        </div>

        <!-- Modal for Change Image -->
        <div class="modal fade" id="changeImageModal" tabindex="-1" aria-labelledby="changeImageModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="changeImageModalLabel">Change Slide Image</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="uploadImage" method="post" enctype="multipart/form-data"> <!-- Ensure enctype is set -->
                        <div class="modal-body">
                            <input type="file" name="slideImage" accept="image/*" required>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-primary">Upload New Image</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>

</html>
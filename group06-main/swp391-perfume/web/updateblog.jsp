<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Blog</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <style>
            body {
                display: flex;
                background-color: #f5f7fa;
                min-height: 100vh;
                flex-direction: column;
            }
            .main-container {
                flex-grow: 1;
                padding: 20px;
                display: flex;
                justify-content: center;
                align-items: flex-start;
            }
            .content-wrapper {
                width: 100%;
                max-width: 900px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
                padding: 2rem;
            }
            h2 {
                font-size: 2rem;
                font-weight: bold;
                color: #333;
                margin-bottom: 1.5rem;
                text-align: center;
            }
            .form-label {
                font-size: 1rem;
                font-weight: 600;
                color: #555;
            }
            .form-control, .form-select {
                padding: 15px;
                border-radius: 5px;
                font-size: 1rem;
                box-shadow: none;
                border: 1px solid #ced4da;
            }
            .form-control:focus, .form-select:focus {
                border-color: #80bdff;
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
            }
            .btn-custom {
                width: 45%;
                padding: 12px 20px;
                font-size: 16px;
                border-radius: 30px;
                font-weight: 600;
                transition: all 0.3s ease;
            }
            .btn-custom:hover {
                opacity: 0.9;
            }
            .text-center {
                display: flex;
                justify-content: space-between;
                margin-top: 20px;
            }
            .alert {
                font-size: 0.9rem;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <jsp:include page="template/sidebar.jsp" />

        <!-- Main Content -->
        <main class="main-container">
            <div class="content-wrapper">
                <h2>Update Blog</h2>

                <!-- Form to update blog -->
                <form action="updateBlog?id=${blog.id}" method="POST" class="p-4 bg-light border rounded shadow-sm" id="blogForm" enctype="multipart/form-data">
                    <!-- Hidden field to distinguish between "submit" and "save draft" -->
                    <input type="hidden" id="actionType" name="actionType" value="submit">

                    <!-- Hidden field to store the current image name -->
                    <input type="hidden" name="currentImage" value="${blog.image}">

                    <div class="mb-3">
                        <label for="title" class="form-label">Title:</label>
                        <input type="text" id="title" name="blogTitle" class="form-control" placeholder="Enter blog title" required value="${blog.title}">
                    </div>

                    <div class="mb-3">
                        <label for="content" class="form-label">Content:</label>
                        <textarea id="content" name="blogContent" class="form-control" rows="10" placeholder="Write your blog content here..." required>${blog.content}</textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Current Image:</label>
                        <div>
                            <img src="images/blog/${blog.image}" alt="Current Blog Image" style="max-width: 100%; height: auto;">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Select New Image (Optional):</label>
                        <input type="file" class="form-control" name="image" accept="image/*">
                    </div>

                    <div class="text-center">
                        <button type="button" class="btn btn-success btn-custom" id="submitBtn">
                            <i class="fas fa-check-circle"></i> Submit
                        </button>
                        <button type="button" class="btn btn-secondary btn-custom" id="saveDraftBtn">
                            <i class="fas fa-save"></i> Save Draft
                        </button>
                    </div>
                </form>

            </div>
        </main>

        <!-- JavaScript to handle button clicks -->
        <script>
            document.getElementById('submitBtn').addEventListener('click', function () {
                const imageInput = document.querySelector('input[name="image"]');
                const currentImage = document.querySelector('input[name="currentImage"]').value;

                // Check if the new image is selected or if an existing image is available
                if (!imageInput.files.length && !currentImage) {
                    alert('Please select an image before submitting.');
                    return;
                }

                // Show confirmation dialog before submission
                if (confirm('Are you sure you want to submit the blog?')) {
                    document.getElementById('actionType').value = 'submit';
                    document.getElementById('blogForm').submit();
                }
            });

            document.getElementById('saveDraftBtn').addEventListener('click', function () {
                // No image check for saving as a draft
                if (confirm('Are you sure you want to save this as a draft?')) {
                    document.getElementById('actionType').value = 'saveDraft';
                    document.getElementById('blogForm').submit();
                }
            });
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

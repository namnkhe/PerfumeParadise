<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add New Blog</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                display: flex;
                min-height: 100vh;
                flex-direction: column;
            }
            .main-container {
                flex-grow: 1;
                padding-left: 250px; /* Reserve space for the sidebar */
            }
            .form-container {
                max-width: 1200px; /* Increase the horizontal max width */
                width: 100%; /* Ensure it spans the available width */
                background-color: #fff;
                padding: 3rem; /* Add padding for a more spacious look */
                border-radius: 8px;
                box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
                margin: auto;
                min-height: 80vh; /* Vertically expand to 80% of the viewport height */
                display: flex;
                flex-direction: column;
                justify-content: space-between; /* Ensure buttons are at the bottom */
            }
            .button-container {
                display: flex;
                justify-content: space-around;
                margin-top: 20px;
            }
            .btn-custom {
                width: 40%;
                padding: 12px 20px;
                font-size: 16px;
                border-radius: 30px;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <jsp:include page="template/sidebar.jsp" />

        <!-- Main Content -->
        <main class="main-container">
            <div class="d-flex justify-content-center">
                <div class="form-container">
                    <h2 class="text-center mb-4">Add New Blog</h2>

                    <!-- Display error message if any -->
                    <div class="alert alert-danger" role="alert" style="${empty error ? 'display: none;' : ''}">
                        ${error}
                    </div>

                    <!-- Display success message if any -->
                    <div class="alert alert-success" role="alert" style="${empty success ? 'display: none;' : ''}">
                        ${success}
                    </div>

                    <!-- Form to add a new blog -->
                    <form action="addBlog" method="POST" class="p-4 bg-light border rounded shadow-sm" id="blogForm" enctype="multipart/form-data">
                        <!-- Hidden field to distinguish between "submit" and "save draft" -->
                        <input type="hidden" id="actionType" name="actionType" value="submit">

                        <div class="mb-3">
                            <label for="title" class="form-label">Title:</label>
                            <input type="text" id="title" name="blogTitle" class="form-control" placeholder="Enter blog title" required>
                        </div>

                        <div class="mb-3">
                            <label for="content" class="form-label">Content:</label>
                            <textarea id="content" name="blogContent" class="form-control" rows="12" placeholder="Write your blog content here..." required></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Select Image:</label>
                            <input type="file" class="form-control" name="image" accept="image/*" required>
                        </div>

                        <div class="text-center button-container">
                            <!-- Two buttons for submit and save draft -->
                            <button type="button" class="btn btn-success btn-custom" id="submitBtn">
                                <i class="fas fa-check-circle"></i> Submit
                            </button>
                            <button type="button" class="btn btn-secondary btn-custom" id="saveDraftBtn">
                                <i class="fas fa-save"></i> Save Draft
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>

        <!-- JavaScript to handle button clicks -->
        <script>
            document.getElementById('submitBtn').addEventListener('click', function () {
                const imageInput = document.querySelector('input[name="image"]');

                // Check if a new image is selected
                if (!imageInput.files.length) {
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

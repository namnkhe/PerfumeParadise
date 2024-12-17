<%@page import="java.util.List"%>
<%@ page import="model.Slide" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Slide Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <style>
            body {
                display: flex;
                min-height: 100vh;
                flex-direction: column;
            }
            .content {
                margin-left: 250px;
                padding: 20px;
                width: calc(100% - 250px);
            }
            .table th, .table td {
                vertical-align: middle;
            }
            .actions-btn {
                display: flex;
                gap: 10px;
            }
            .no-data {
                text-align: center;
                font-size: 18px;
                color: #6c757d;
            }
            .add-slide-btn {
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <jsp:include page="template/sidebar.jsp" />

        <!-- Main content -->
        <div class="content">
            <h1>Slide Management</h1>

            <!-- Add Slide Button -->
            <div class="add-slide-btn">
                <a href="addSlide" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add New Slide
                </a>
            </div>

            <!-- Slide List Table -->
            <form action="SliderController" method="get" class="mb-3">
                Search: <input type="text" name="search" class="form-control d-inline w-auto" value="${param.search}" />
                Status:
                <select name="status" class="form-select d-inline w-auto">
                    <option value="">All</option>
                    <option value="true" ${param.status == 'true' ? 'selected' : ''}>Active</option>
                    <option value="false" ${param.status == 'false' ? 'selected' : ''}>Inactive</option>
                </select>
                <input type="submit" class="btn btn-secondary" value="Filter" />
            </form>

            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Image</th>
                        <th>Backlink</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% List<Slide> list = (List<Slide>)request.getAttribute("slides");
                        if (list != null && !list.isEmpty()) {
                            for(Slide slide: list) {
                    %>
                    <tr>
                        <td><%= slide.getID() %></td>
                        <td><%= slide.getTitle() %></td>
                        <td><img src="<%= slide.getImage_url() %>" alt="Image" width="100"></td>
                        <td><%= slide.getLink() %></td>
                        <td><%= slide.isIs_active() ? "Active" : "Inactive" %></td>
                        <td class="actions-btn">
                            <!-- Hide/Show Button -->
                            <form action="SliderController" method="post" style="display:inline;">
                                <input type="hidden" name="slideId" value="<%= slide.getID() %>">
                                <c:choose>
                                    <c:when test="${slide.isIs_active()}">
                                        <input type="hidden" name="action" value="hide">
                                        <input type="submit" class="btn btn-warning btn-sm" value="Hide">
                                    </c:when>
                                    <c:otherwise>
                                        <input type="hidden" name="action" value="show">
                                        <input type="submit" class="btn btn-success btn-sm" value="Show">
                                    </c:otherwise>
                                </c:choose>
                            </form>

                            <form action="SliderController" method="post" style="display:inline;">
                                <input type="hidden" name="slideId" value="<%= slide.getID() %>">
                                <input type="submit" value="Edit">
                                <input type="hidden" name="action" value="Edit">
                            </form>
                        </td>
                    </tr>
                    <% 
                            }
                        } else { 
                    %>
                    <tr>
                        <td colspan="6" class="no-data">No slides available at the moment.</td>
                    </tr>
                    <% 
                        } 
                    %>
                </tbody>
            </table>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </body>
</html>
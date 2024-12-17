<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PerfumeParadise Homepage</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/48a04e355d.js" crossorigin="anonymous"></script>
        <link href="css/style.css" rel="stylesheet">
    </head>

    <body>
        <jsp:include page="template/header.jsp"/>
        <div class="container-fluid">
            <hr/>
            <div class="row">
                <div class="col-sm-3 search">
                    <form action="searchproduct" method="get" class="form-horizontal">
                        <input type="hidden" value="0" name="u"/>
                        <jsp:include page="template/searchbar.jsp"/>
                    </form>

                    <!-- Hot Posts Section -->
                    <h2>Hot Posts</h2>
                    <div class="row">
                        <c:forEach items="${listBL}" var="post">
                            <div class="col-12 mb-2">
                                <div class="card shadow-0">
                                    <a href="postDetails?id=${post.id}" class="img-wrap">
                                        <img src="${post.image}" class="card-img-top" alt="${post.title}">
                                    </a>
                                    <div class="card-body">
                                        <h4 class="card-title">${post.image}</h4>
                                        <p class="card-text">${post.brief}</p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="col-sm-9 content">
                    <h2>Brand</h2>
                    <div class="row">
                        <c:forEach items="${listB}" var="b">
                            <div class="col-sm-6 col-md-3 pt-2">
                                <div class="card my-2 shadow-0">
                                    <div class="mask">
                                        <a href="searchproduct?bid=${b.id}&u=0">
                                            <img class="card-img-top" style="aspect-ratio: 1 / 1" src="images/brand/${b.image}" width="90%" alt="${b.name}"/>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <hr/>

                    <h2>New Release</h2>
                    <div class="row">
                        <c:forEach items="${newrelease}" var="item">
                            <div class="col-sm-3">
                                <div class="card my-2 shadow-0">
                                    <div class="mask" style="height: 50px;">
                                        <div class="d-flex justify-content-start align-items-start h-100 m-2">
                                            <a href="productfilter?bid=${item.brand.id}" class="img-wrap">
                                                <h6><span class="badge bg-success pt-2">${item.brand.name}</span></h6>
                                            </a> 
                                        </div>
                                    </div>
                                    <a href="itemdetail?id=${item.id}" class="img-wrap">
                                        <img src="images/perfume/${item.image}" class="card-img-top" style="aspect-ratio: 1 / 1"> 
                                    </a>
                                    <div class="card-body p-0 pt-3" style="text-align: center">
                                        <h6 class="card-title">${item.name}</h6>
                                        <p class="card-text mb-0" style="color: #FF5733; font-weight: bold; font-size: 1.2em; background-color: #FFE6E6; padding: 5px; border-radius: 5px;">${item.price}$</p>


                                        <p class="text-muted">Size: ${item.size}ml</p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <hr/>

                    <h2>Best Seller</h2>
                    <div class="row">
                        <c:forEach items="${bestseller}" var="item">
                            <div class="col-sm-3">
                                <div class="card my-2 shadow-0">
                                    <div class="mask" style="height: 50px;">
                                        <div class="d-flex justify-content-start align-items-start h-100 m-2">
                                            <a href="productfilter?bid=${item.brand.id}" class="img-wrap">
                                                <h6><span class="badge bg-success pt-2">${item.brand.name}</span></h6>
                                            </a> 
                                        </div>
                                    </div>
                                    <a href="itemdetail?id=${item.id}" class="img-wrap">
                                        <img src="images/perfume/${item.image}" class="card-img-top" style="aspect-ratio: 1 / 1"> 
                                    </a>
                                    <div class="card-body p-0 pt-3" style="text-align: center">
                                        <h6 class="card-title">${item.name}</h6>
                                        <p class="card-text mb-0" style="color: #FF5733; font-weight: bold; font-size: 1.2em; background-color: #FFE6E6; padding: 5px; border-radius: 5px;">${item.price}$</p>

                                        <p class="text-muted">Size: ${item.size}ml</p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="template/footer.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </body>
</html>

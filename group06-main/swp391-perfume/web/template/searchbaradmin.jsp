<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .search-form {
        display: flex;
        gap: 10px;
        align-items: center;
        padding: 10px;
        background-color: #f9f9f9;
        border-radius: 8px;
        justify-content: flex-start;
        flex-wrap: nowrap;
    }
    .search-form .form-group {
        flex: 1;
        min-width: 120px; /* Adjust width as necessary */
    }
    .search-buttons {
        display: flex;
        gap: 5px;
    }
    .form-control {
        padding: 5px;
        font-size: 14px;
    }
</style>

<form action="searchproduct" method="get" class="search-form">
    <input type="hidden" name="u" value="1"/>

    <div class="form-group">
        <label>Brand</label>
        <select name="bid" class="form-control">
            <option value="0">All</option>
            <c:forEach items="${sessionScope.listB}" var="b">
                <option value="${b.id}">${b.name}</option>
            </c:forEach>
        </select>
    </div>

    <div class="form-group">
        <label>Category</label>
        <select name="cid" class="form-control">
            <option value="0">All</option>
            <c:forEach items="${sessionScope.listC}" var="c">
                <option value="${c.id}">${c.name}</option>
            </c:forEach>
        </select>
    </div>

    <div class="form-group">
        <label>Min Price</label>
        <input type="number" min="0" name="minimumprice" class="form-control" placeholder="$"/>
    </div>

    <div class="form-group">
        <label>Max Price</label>
        <input type="number" min="0" name="maximumprice" class="form-control" placeholder="$"/>
    </div>

    <div class="form-group">
        <label>From</label>
        <input type="date" name="fromdate" class="form-control" placeholder="dd/mm/yyyy"/>
    </div>

    <div class="form-group">
        <label>To</label>
        <input type="date" name="todate" class="form-control" placeholder="dd/mm/yyyy"/>
    </div>

    <div class="search-buttons">
        <input type="submit" value="Search" class="btn btn-primary btn-sm"/>
        <input type="reset" value="Reset" class="btn btn-secondary btn-sm"/>
    </div>
</form>

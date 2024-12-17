<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>

        <div class="form-group row">
            <label class="col-sm-4 control-label">Brand</label>
            <select name="bid">
                <option value="0">All</option>
                <c:forEach items="${sessionScope.listB}" var="b">
                    <option value="${b.id}">${b.name}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group row">
            <label class="col-sm-4 control-label">Category</label>

            <select name="cid">
                <option value="0">All</option>
                <c:forEach items="${sessionScope.listC}" var="c">
                    <option value="${c.id}">${c.name}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group row">
            <label class="control-label">Minimum Price:</label>
            <input type="number" min='0' name="minimumprice"/>
        </div>
        <div class="form-group row">
            <label class="control-label">Maximum Price:</label>
            <input type="number" min='0' name="maximumprice"/>
        </div>
        <div class="form-group row">
            <label class="col-sm-3 control-label">From:</label>
            <input type="date" name="fromdate"/>
        </div>
        <div class="form-group row">
            <label class="col-sm-3 control-label">To:</label>
            <input type="date" name="todate"/>
        </div>
        <div class="form-group row">   
            <div class="col"><input type="submit" value="Search"/></div>
            <div class="col"><input type="reset" value="Reset"/></div>
        </div>
    </body>
</html>

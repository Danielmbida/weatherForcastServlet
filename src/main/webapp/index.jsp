<%@ page import="java.util.List" %>
<%@ page import="org.example.demo.business.StationMeteo" %>
<%@ page import="org.example.demo.database.StationMeteoDAO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>JSP - Hello World</title>

    <!-- Bootstrap CSS from WebJar, using scriptlet for context -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/webjars/bootstrap/5.2.3/css/bootstrap.min.css"/>
</head>
<body>
<h1><%= "Hello World!" %></h1>
<br/>
<a href="hello-servlet">Hello Servlet</a>

<%
    StationMeteoDAO dao = new StationMeteoDAO();
    List<StationMeteo> list = dao.getAllStationMeteo();
%>
<h2><%= "Liste des stations" %></h2>
<table class="table table-striped table-bordered">
    <thead>
    <tr>
        <th>id</th>
        <th>latitude</th>
        <th>longitude</th>
    </tr>
    </thead>
    <tbody>
    <% for (StationMeteo s : list) { %>
    <tr>
        <td><%= s.getOpenWeatherMapId() %></td>
        <td><%= s.getLatitude() %></td>
        <td><%= s.getLongitude() %></td>
    </tr>
    <% } %>
    </tbody>
</table>

<!-- Bootstrap JS bundle from WebJar -->
<script src="<%= request.getContextPath() %>/webjars/bootstrap/5.2.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>

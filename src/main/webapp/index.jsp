<%@ page import="java.util.List" %>
<%@ page import="org.example.demo.business.StationMeteo" %>
<%@ page import="org.example.demo.database.StationMeteoDAO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>JSP - Hello World</title>
</head>
<body>
<h1><%= "Hello World!" %>
</h1>
<br/>
<a href="hello-servlet">Hello Servlet</a>

<%
    StationMeteoDAO stationMeteoDAO = new StationMeteoDAO();
    List<StationMeteo> stationMeteoList = stationMeteoDAO.getAllStationMeteo();
%>
<h2><%= "Liste des stations" %></h2>
<table border="1">
    <th>id</th>
    <th>latitude</th>
    <th>longitude</th>

    <% for (StationMeteo station : stationMeteoList) { %>
    <tr>
        <td><%= station.getOpenWeatherMapId() %></td>
        <td><%= station.getLatitude() %></td>
        <td><%= station.getLongitude() %></td>
    </tr>
    <% } %>
</table>
</body>
</html>
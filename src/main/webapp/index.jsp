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
<h1><%= "Liste des stations" %></h1>
<br/>
<%
    StationMeteoDAO stationMeteoDAO = new StationMeteoDAO();
    List<StationMeteo> stationMeteoList = stationMeteoDAO.getAllStationMeteo();
%>
<table border="1">
    <th>Nom de la station</th>
    <th>Pays</th>
    <th>Latitude</th>
    <th>Longitude</th>
    <th>action</th>

    <% for (StationMeteo station : stationMeteoList) { %>

    <tr>
       <td><%= station.getNom() %></td>
        <td><%= station.getPays().getNom() %></td>
        <td><%= station.getLatitude() %></td>
        <td><%= station.getLongitude() %></td>
        <td><a href="station-details?name=<%= station.getNom() %>">detail</a></td>
    </tr>
    <% } %>
</table>
<button>Ajouter une station</button>
</body>
</html>
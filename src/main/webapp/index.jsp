<%@ page import="java.util.List" %>
<%@ page import="org.example.demo.business.StationMeteo" %>
<%@ page import="org.example.demo.database.StationMeteoDAO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>JSP - Hello World</title>
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/webjars/bootstrap/5.2.3/css/bootstrap.min.css"/>
</head>
<body>
<h1><%= "Liste des stations" %></h1>
<br/>
<%
    StationMeteoDAO dao = new StationMeteoDAO();
    List<StationMeteo> stationMeteoList = dao.getAllStationMeteo();
%>
<table class="table table-striped table-bordered">
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
            <% } %>
<button>Ajouter une station</button>
</body>
<script src="<%= request.getContextPath() %>/webjars/bootstrap/5.2.3/js/bootstrap.bundle.min.js"></script>
</html>

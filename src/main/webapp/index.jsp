<%@ page import="java.util.List" %>
<%@ page import="org.example.demo.business.StationMeteo" %>
<%@ page import="org.example.demo.database.StationMeteoDAO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>JSP - Meteo</title>
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/webjars/bootstrap/5.2.3/css/bootstrap.min.css"/>
</head>
<body>
<% if (request.getAttribute("error") != null) { %>
<div class="alert alert-danger alert-dismissible fade show" role="alert">
    <%= request.getAttribute("error") %>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Fermer"></button>
</div>
<% } else if (request.getAttribute("success") != null) { %>
<div class="alert alert-success alert-dismissible fade show" role="alert">
    <%= request.getAttribute("success") %>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Fermer"></button>
</div>
<% } %>
<%
    StationMeteoDAO dao = new StationMeteoDAO();
    List<StationMeteo> stationMeteoList = dao.getAllStationMeteo();
%>
<div class="container mt-5">
    <div class="row mb-3">
        <div class="col text-start">
            <h1><%= "Liste des stations" %></h1>
        </div>
        <div class="col text-end">
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addStationModal">
                Ajouter une station
            </button>
        </div>
    </div>


    <div class="row">
        <table class="table table-striped table-bordered">
            <thead>
            <tr>
                <th>Nom de la station</th>
                <th>Pays</th>
                <th>Latitude</th>
                <th>Longitude</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <% for (StationMeteo station : stationMeteoList) { %>
            <tr>
                <td><%= station.getNom() %></td>
                <td><%= station.getPays().getNom() %></td>
                <td><%= station.getLatitude() %></td>
                <td><%= station.getLongitude() %></td>
                <td><a href="station-details?name=<%= station.getNom() %>">Détail</a></td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>

    <div class="row mt-3">
        <div class="col text-end">
            <div class="d-inline-block me-2">
                <form method="post" action="hot-stations" class="d-inline">
                    <button type="submit" class="btn btn-warning">Voir les lieux les plus chauds</button>
                </form>
            </div>
            <div class="d-inline-block">
                <form method="post" action="cold-stations" class="d-inline">
                <button type="submit" class="btn btn-success">
                    Voir les lieux les plus froid
                </button>
                </form>
            </div>
        </div>
    </div>

</div>
<jsp:include page="addStationModal.jsp" />
</body>
<script src="<%= request.getContextPath() %>/webjars/bootstrap/5.2.3/js/bootstrap.bundle.min.js"></script>
</html>

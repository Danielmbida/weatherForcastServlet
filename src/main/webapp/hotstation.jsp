<%@ page import="java.util.List" %>
<%@ page import="org.example.demo.business.StationMeteo" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Lieux les plus chauds</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/webjars/bootstrap/5.2.3/css/bootstrap.min.css"/>
</head>
<body>
<% if (request.getAttribute("success") != null) { %>
<div class="alert alert-success alert-dismissible fade show" role="alert">
  <%= request.getSession().getAttribute("success") %>
  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Fermer"></button>
</div>
<% }%>
<div class="container mt-5">
  <h1>🌡️ Top 3 des lieux les plus chauds</h1>

  <table class="table table-bordered table-striped mt-4">
    <thead>
    <tr>
      <th>Nom</th>
      <th>Pays</th>
      <th>Latitude</th>
      <th>Longitude</th>
      <th>Température actuelle</th>
      <th>Détail</th>
    </tr>
    </thead>
    <tbody>
    <%
      List<StationMeteo> stations = (List<StationMeteo>) request.getAttribute("topHotStations");
      if (stations != null) {
        for (StationMeteo station : stations) {
          java.util.Date lastDate = null;
          org.example.demo.business.Meteo lastMeteo = null;
          for (var entry : station.getDonneesMeteo().entrySet()) {
            if (lastDate == null || entry.getKey().after(lastDate)) {
              lastDate = entry.getKey();
              lastMeteo = entry.getValue();
            }
          }
    %>
    <tr>
      <td><%= station.getNom() %></td>
      <td><%= station.getPays().getNom() %></td>
      <td><%= station.getLatitude() %></td>
      <td><%= station.getLongitude() %></td>
      <td><%= (lastMeteo != null) ? lastMeteo.getTemperature() + "°C" : "N/A" %></td>
      <td><a href="station-details?name=<%= station.getNom() %>">Détail</a></td>
    </tr>
    <%     }
    } else { %>
    <tr>
      <td colspan="6" class="text-center text-muted">Aucune donnée à afficher</td>
    </tr>
    <% } %>
    </tbody>
  </table>

  <div class="row mt-4">
    <div class="col text-start">
      <a href="index.jsp" class="btn btn-secondary">← Retour à la liste complète</a>
    </div>
    <div class="col text-end">
      <form method="post" action="refresh-all-stations">
        <input type="hidden" name="redirectTo" value="<%= "hot-stations" %>" />
        <button type="submit" class="btn btn-outline-primary">
          🔄 Rafraîchir toutes les stations
        </button>
      </form>
    </div>
  </div>
</div>
<script src="<%= request.getContextPath() %>/webjars/bootstrap/5.2.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>

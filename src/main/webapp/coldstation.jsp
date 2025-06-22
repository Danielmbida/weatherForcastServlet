<%@ page import="java.util.List" %>
<%@ page import="ch.heg.ig.scl.business.StationMeteo" %>
<%@ page import="ch.heg.ig.scl.business.Meteo" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stations les plus froides - WeatherStation Pro</title>

    <!-- Bootswatch MINTY Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.2/dist/minty/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <link rel="stylesheet" href="stylesheet/coldStation.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow">
    <div class="container">
        <a class="navbar-brand fw-bold" href="index.jsp">
            <i class="bi bi-cloud-sun me-2"></i>
            WeatherStation Pro
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item me-3">
                    <a class="nav-link fw-bold fs-5" href="index.jsp#stations">
                        <i class="bi bi-list-ul me-1"></i>Stations
                    </a>
                </li>
                <li class="nav-item me-2">
                    <form method="post" action="refresh-all-stations" class="d-inline">
                        <input type="hidden" name="redirectTo" value="cold-stations">
                        <button type="submit" class="btn btn-outline-light btn-sm">
                            <i class="bi bi-arrow-clockwise"></i> Actualiser
                        </button>
                    </form>
                </li>
                <li class="nav-item">
                    <a href="index.jsp" class="btn btn-outline-light btn-sm">
                        <i class="bi bi-house"></i> Accueil
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="bg-primary text-white py-5">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <h1 class="display-4 fw-bold mb-3">Stations les plus froides</h1>
                <p class="lead mb-4">
                    Analyse des températures minimales enregistrées par notre réseau de stations météorologiques.
                </p>
            </div>
            <div class="col-lg-4 text-center">
                <i class="bi bi-thermometer-low display-1 opacity-75"></i>
            </div>
        </div>
    </div>
</div>

<div class="container my-5">
    <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>
        <%= request.getSession().getAttribute("success") %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>
        <%= request.getAttribute("error") %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="card text-center h-100">
                <div class="card-body">
                    <div class="display-4 text-info mb-3">
                        <i class="bi bi-thermometer-low"></i>
                    </div>
                    <h3 class="text-info">TOP 3</h3>
                    <p class="text-muted mb-0">Stations froides</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-center h-100">
                <div class="card-body">
                    <div class="display-4 text-primary mb-3">
                        <i class="bi bi-snow"></i>
                    </div>
                    <h3 class="text-primary">Temps réel</h3>
                    <p class="text-muted mb-0">Données actuelles</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-center h-100">
                <div class="card-body">
                    <div class="display-4 text-success mb-3">
                        <i class="bi bi-clock-fill"></i>
                    </div>
                    <h3 class="text-success">24/7</h3>
                    <p class="text-muted mb-0">Surveillance</p>
                </div>
            </div>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-12 text-center mb-4">
            <h2 class="display-6">Top 3 des stations les plus froides</h2>
            <p class="text-muted">Classement des températures les plus basses en temps réel</p>
        </div>
    </div>

    <div class="row g-4">
        <%
            List<StationMeteo> stations = (List<StationMeteo>) request.getAttribute("topColdStations");
            if (stations != null && !stations.isEmpty()) {
                int rang = 1;
                for (StationMeteo station : stations) {
                    java.util.Date lastDate = null;
                    Meteo lastMeteo = null;
                    if (station.getDonneesMeteo() != null) {
                        for (var entry : station.getDonneesMeteo().entrySet()) {
                            if (lastDate == null || entry.getKey().after(lastDate)) {
                                lastDate = entry.getKey();
                                lastMeteo = entry.getValue();
                            }
                        }
                    }
        %>
        <div class="col-lg-4 col-md-6">
            <div class="card h-100 border-info">
                <div class="card-header bg-info text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="mb-1">
                                <i class="bi bi-broadcast-pin me-2"></i>
                                <%= station.getNom() %>
                            </h5>
                            <small class="opacity-75">
                                <i class="bi bi-geo-alt me-1"></i>
                                <%= station.getPays().getNom() %>
                            </small>
                        </div>
                        <div class="text-end">
                                <span class="badge bg-light text-dark fs-6">
                                    #<%= rang %>
                                </span>
                        </div>
                    </div>
                </div>

                <div class="card-body">
                    <% if (lastMeteo != null) { %>
                    <div class="text-center mb-3">
                        <div class="h2 text-info fw-bold mb-1">
                            <i class="bi bi-thermometer-half me-2"></i>
                            <%= String.format("%.1f", lastMeteo.getTemperature()) %>°C
                        </div>
                        <small class="text-muted">Température actuelle</small>
                    </div>

                    <div class="mb-3">
                            <span class="badge bg-secondary rounded-pill">
                                <i class="bi bi-cloud me-1"></i>
                                <%= lastMeteo.getDescription() %>
                            </span>
                    </div>

                    <div class="row g-2 text-muted small">
                        <div class="col-6">
                            <i class="bi bi-moisture text-info me-1"></i>
                            <%= String.format("%.0f", lastMeteo.getHumidite()) %>% humidité
                        </div>
                        <div class="col-6">
                            <i class="bi bi-speedometer2 text-warning me-1"></i>
                            <%= lastMeteo.getPression() %> hPa
                        </div>
                    </div>
                    <% } else { %>
                    <div class="text-center text-muted">
                        <i class="bi bi-exclamation-circle"></i>
                        Aucune donnée météo disponible
                    </div>
                    <% } %>

                    <hr>

                    <div class="row g-2 text-muted small">
                        <div class="col-6">
                            <i class="bi bi-globe2 text-success me-1"></i>
                            Lat: <%= String.format("%.3f", station.getLatitude()) %>°
                        </div>
                        <div class="col-6">
                            <i class="bi bi-globe2 text-success me-1"></i>
                            Lng: <%= String.format("%.3f", station.getLongitude()) %>°
                        </div>
                    </div>
                </div>

                <div class="card-footer">
                    <div class="d-grid">
                        <a href="station-details?name=<%= station.getNom() %>"
                           class="btn btn-primary">
                            <i class="bi bi-eye me-2"></i>Voir les détails
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <%
                rang++;
            }
        } else {
        %>
        <div class="col-12">
            <div class="card">
                <div class="card-body text-center py-5">
                    <div class="display-1 text-muted mb-4">
                        <i class="bi bi-thermometer-low"></i>
                    </div>
                    <h3 class="text-muted mb-3">Aucune donnée à afficher</h3>
                    <p class="text-muted mb-4">Impossible de récupérer les stations froides</p>
                    <a href="index.jsp" class="btn btn-primary btn-lg">
                        <i class="bi bi-arrow-left me-2"></i>Retour à l'accueil
                    </a>
                </div>
            </div>
        </div>
        <% } %>
    </div>

    <div class="row mt-5">
        <div class="col-md-6">
            <a href="index.jsp" class="btn btn-secondary btn-lg w-100">
                <i class="bi bi-arrow-left me-2"></i>
                Retour à l'accueil
            </a>
        </div>
        <div class="col-md-6">
            <a href="hot-stations" class="btn btn-danger btn-lg w-100">
                <i class="bi bi-thermometer-high me-2"></i>
                Voir les stations chaudes
            </a>
        </div>
    </div>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    setTimeout(function() {
        var alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            var bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);
</script>
</body>
</html>
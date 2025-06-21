<%@ page import="java.util.List" %>
<%@ page import="org.example.demo.business.StationMeteo" %>
<%@ page import="org.example.demo.database.StationMeteoDAO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WeatherStation Pro - Stations Météo</title>

    <!-- Bootswatch MINTY Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.2/dist/minty/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        .card {
            border-radius: 15px !important;
        }

        .card:hover {
            transform: translateY(-5px);
            transition: all 0.3s ease;
        }

        .btn {
            border-radius: 10px !important;
        }

        .btn:hover {
            transform: translateY(-2px);
            transition: all 0.3s ease;
        }

        .modal-content {
            border-radius: 15px !important;
        }

        .alert {
            border-radius: 10px !important;
        }

        .navbar {
            position: sticky;
            top: 0;
            z-index: 1030;
        }
    </style>
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
                    <a class="nav-link fw-bold fs-5" href="#stations">
                        <i class="bi bi-list-ul me-1"></i>Stations
                    </a>
                </li>
                <li class="nav-item me-2">
                    <form method="post" action="refresh-all-stations" class="d-inline">
                        <input type="hidden" name="redirectTo" value="index.jsp">
                        <button type="submit" class="btn btn-outline-light btn-sm">
                            <i class="bi bi-arrow-clockwise"></i> Actualiser
                        </button>
                    </form>
                </li>
                <li class="nav-item">
                    <button class="btn btn-outline-light btn-sm" data-bs-toggle="modal" data-bs-target="#addStationModal">
                        <i class="bi bi-plus-lg"></i> Ajouter
                    </button>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="bg-primary text-white py-5">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <h1 class="display-4 fw-bold mb-3">Stations Météo</h1>
                <p class="lead mb-4">
                    Surveillez les conditions météorologiques en temps réel.
                </p>
                <button class="btn btn-outline-light btn-lg" data-bs-toggle="modal" data-bs-target="#addStationModal">
                    <i class="bi bi-plus-lg me-2"></i>Ajouter une station
                </button>
                <form method="post" action="refresh-all-stations" class="d-inline ms-3">
                    <input type="hidden" name="redirectTo" value="index.jsp">
                    <button type="submit" class="btn btn-outline-light btn-lg">
                        <i class="bi bi-arrow-clockwise me-2"></i>Actualiser toutes les stations
                    </button>
                </form>
            </div>
            <div class="col-lg-4 text-center">
                <i class="bi bi-cloud-sun display-1 opacity-75"></i>
            </div>
        </div>
    </div>
</div>

<div class="container my-5">
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>
        <%= request.getAttribute("error") %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } else if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>
        <%= request.getAttribute("success") %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <%
        StationMeteoDAO dao = new StationMeteoDAO();
        List<StationMeteo> stationMeteoList = dao.getAllStationMeteo();
    %>

    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="card text-center h-100">
                <div class="card-body">
                    <div class="display-4 text-primary mb-3">
                        <i class="bi bi-bar-chart-fill"></i>
                    </div>
                    <h3 class="text-primary"><%= stationMeteoList.size() %></h3>
                    <p class="text-muted mb-0">Stations actives</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-center h-100">
                <div class="card-body">
                    <div class="display-4 text-info mb-3">
                        <i class="bi bi-thermometer-half"></i>
                    </div>
                    <h3 class="text-info">Live</h3>
                    <p class="text-muted mb-0">Données temps réel</p>
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
            <h2 class="display-6">Actions rapides</h2>
            <p class="text-muted">Accédez rapidement aux informations importantes</p>
        </div>
    </div>

    <div class="row g-4 mb-5">
        <div class="col-lg-6">
            <form method="post" action="hot-stations">
                <div class="card border-danger h-100">
                    <div class="card-body text-center p-4">
                        <div class="display-1 text-danger mb-4">
                            <i class="bi bi-thermometer-high"></i>
                        </div>
                        <h3 class="card-title text-danger">Stations Chaudes</h3>
                        <p class="card-text">Les 3 stations avec les températures les plus élevées</p>
                        <button type="submit" class="btn btn-danger btn-lg">
                            <i class="bi bi-fire me-2"></i>Voir les stations chaudes
                        </button>
                    </div>
                </div>
            </form>
        </div>
        <div class="col-lg-6">
            <form method="post" action="cold-stations">
                <div class="card border-info h-100">
                    <div class="card-body text-center p-4">
                        <div class="display-1 text-info mb-4">
                            <i class="bi bi-thermometer-low"></i>
                        </div>
                        <h3 class="card-title text-info">Stations Froides</h3>
                        <p class="card-text">Les 3 stations avec les températures les plus basses</p>
                        <button type="submit" class="btn btn-info btn-lg">
                            <i class="bi bi-snow me-2"></i>Voir les stations froides
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="row mb-4" id="stations">
        <div class="col-12 text-center mb-4">
            <h2 class="display-6">Toutes les stations météo</h2>
            <p class="text-muted">Gérez et consultez toutes vos stations</p>
        </div>
    </div>

    <div class="row g-4">
        <% if (!stationMeteoList.isEmpty()) {
            for (StationMeteo station : stationMeteoList) {
                java.util.Date lastDate = null;
                org.example.demo.business.Meteo lastMeteo = null;
                if (station.getDonneesMeteo() != null) {
                    for (var entry : station.getDonneesMeteo().entrySet()) {
                        if (lastDate == null || entry.getKey().after(lastDate)) {
                            lastDate = entry.getKey();
                            lastMeteo = entry.getValue();
                        }
                    }
                }

                String badgeClass = "bg-light text-dark";
        %>
        <div class="col-lg-4 col-md-6">
            <div class="card h-100">
                <div class="card-header bg-primary text-white">
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
                        <% if (lastMeteo != null) { %>
                        <span class="badge bg-light text-dark fs-6">
                            <i class="bi bi-thermometer-half me-1"></i>
                            <%= String.format("%.1f", lastMeteo.getTemperature()) %>°C
                        </span>
                        <% } %>
                    </div>
                </div>

                <div class="card-body">
                    <% if (lastMeteo != null) { %>
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
        <%  }
        } else { %>
        <div class="col-12">
            <div class="card">
                <div class="card-body text-center py-5">
                    <div class="display-1 text-muted mb-4">
                        <i class="bi bi-cloud-sun"></i>
                    </div>
                    <h3 class="text-muted mb-3">Aucune station météo disponible</h3>
                    <p class="text-muted mb-4">Commencez par ajouter votre première station</p>
                    <button class="btn btn-primary btn-lg" data-bs-toggle="modal" data-bs-target="#addStationModal">
                        <i class="bi bi-plus-lg me-2"></i>Ajouter une station
                    </button>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<!-- Inclusion du modal externe -->
<%@ include file="addStationModal.jsp" %>

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
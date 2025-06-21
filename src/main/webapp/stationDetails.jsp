<%@ page import="org.example.demo.business.StationMeteo" %>
<%@ page import="org.example.demo.business.Meteo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    StationMeteo station = (StationMeteo) request.getAttribute("station");
    List<Meteo> previsions = (List<Meteo>) request.getAttribute("previsions");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
    String previsionsError = (String) request.getAttribute("previsionsError");

    String sessionSuccessMessage = (String) session.getAttribute("successMessage");
    String sessionErrorMessage = (String) session.getAttribute("errorMessage");
    if (sessionSuccessMessage != null) {
        session.removeAttribute("successMessage");
        successMessage = sessionSuccessMessage;
    }
    if (sessionErrorMessage != null) {
        session.removeAttribute("errorMessage");
        errorMessage = sessionErrorMessage;
    }

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    SimpleDateFormat shortDateFormat = new SimpleDateFormat("dd/MM HH:mm");
    DecimalFormat decimalFormat = new DecimalFormat("#.#");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails de la station - <%= station != null ? station.getNom() : "Station" %> - WeatherStation Pro</title>

    <!-- Bootswatch MINTY Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.2/dist/minty/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <%@ include file="stylesheet/detail.css" %>
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
                        <input type="hidden" name="redirectTo" value="index.jsp">
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

<div class="container mt-4">
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="index.jsp">
                    <i class="bi bi-house me-1"></i>Accueil
                </a>
            </li>
            <li class="breadcrumb-item active">
                <i class="bi bi-broadcast-pin me-1"></i>
                Détails de la station
            </li>
        </ol>
    </nav>

    <% if (errorMessage != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>
        <strong>Erreur !</strong> <%= errorMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <% if (successMessage != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>
        <strong>Succès !</strong> <%= successMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <% if (station != null) { %>

    <div class="row mb-4">
        <div class="col-12">
            <div class="card weather-main-card shadow-lg">
                <div class="card-body p-4">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h1 class="mb-3">
                                <i class="bi bi-broadcast-pin me-3"></i>
                                <%= station.getNom() %>
                            </h1>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <p class="mb-2 opacity-90">
                                        <i class="bi bi-flag me-2"></i>
                                        <strong>Pays :</strong> <%= station.getPays().getNom() %> (<%= station.getPays().getCode() %>)
                                    </p>
                                    <p class="mb-2 opacity-90">
                                        <i class="bi bi-geo-alt me-2"></i>
                                        <strong>Position :</strong> <%= decimalFormat.format(station.getLatitude()) %>°N, <%= decimalFormat.format(station.getLongitude()) %>°E
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 text-end">
                            <form method="post" class="d-inline">
                                <input type="hidden" name="action" value="refresh">
                                <input type="hidden" name="stationName" value="<%= station.getNom() %>">
                                <button type="submit" class="btn btn-light btn-lg">
                                    <i class="bi bi-arrow-clockwise me-2"></i>
                                    Actualiser les données
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-12">
            <h2 class="display-6 mb-4">
                <i class="bi bi-thermometer-half me-2 text-primary"></i>
                Conditions météorologiques actuelles
            </h2>
        </div>
    </div>

    <div class="row g-4 mb-5">
        <%
            Map<Date, Meteo> donneesMeteo = station.getDonneesMeteo();
            if (donneesMeteo != null && !donneesMeteo.isEmpty()) {
                Meteo meteoActuelle = null;
                Date datePlusRecente = null;
                for (Map.Entry<Date, Meteo> entry : donneesMeteo.entrySet()) {
                    if (datePlusRecente == null || entry.getKey().after(datePlusRecente)) {
                        datePlusRecente = entry.getKey();
                        meteoActuelle = entry.getValue();
                    }
                }

                if (meteoActuelle != null) {
        %>
        <div class="col-lg-4">
            <div class="card text-center h-100">
                <div class="card-body">
                    <i class="bi bi-thermometer-half text-primary" style="font-size: 3rem;"></i>
                    <div class="temp-big text-primary mt-3">
                        <%= decimalFormat.format(meteoActuelle.getTemperature()) %>°C
                    </div>
                    <p class="text-muted mt-3 mb-3"><%= meteoActuelle.getDescription() %></p>
                    <small class="text-muted">
                        <i class="bi bi-clock me-1"></i>
                        Mise à jour : <%= dateFormat.format(meteoActuelle.getDateMesure()) %>
                    </small>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="row g-3">
                <div class="col-md-6">
                    <div class="card text-center h-100">
                        <div class="card-body">
                            <i class="bi bi-moisture text-info" style="font-size: 2rem;"></i>
                            <h4 class="mt-3 text-info"><%= decimalFormat.format(meteoActuelle.getHumidite()) %>%</h4>
                            <p class="text-muted mb-0">Humidité</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card text-center h-100">
                        <div class="card-body">
                            <i class="bi bi-speedometer2 text-warning" style="font-size: 2rem;"></i>
                            <h4 class="mt-3 text-warning"><%= meteoActuelle.getPression() %> hPa</h4>
                            <p class="text-muted mb-0">Pression atmosphérique</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card text-center h-100">
                        <div class="card-body">
                            <i class="bi bi-eye text-secondary" style="font-size: 2rem;"></i>
                            <h4 class="mt-3 text-secondary"><%= meteoActuelle.getVisibilite() / 1000 %> km</h4>
                            <p class="text-muted mb-0">Visibilité</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card text-center h-100">
                        <div class="card-body">
                            <i class="bi bi-cloud-rain text-primary" style="font-size: 2rem;"></i>
                            <h4 class="mt-3 text-primary"><%= decimalFormat.format(meteoActuelle.getPrecipitation()) %> mm</h4>
                            <p class="text-muted mb-0">Précipitations</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <div class="col-12">
            <div class="card">
                <div class="card-body text-center py-5">
                    <i class="bi bi-exclamation-circle text-muted" style="font-size: 4rem;"></i>
                    <h4 class="text-muted mt-3">Aucune donnée météo disponible</h4>
                    <p class="text-muted">Les données météorologiques n'ont pas encore été collectées pour cette station.</p>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>

    <%
        if (previsions != null && !previsions.isEmpty()) {
    %>
    <div class="row mb-4">
        <div class="col-12">
            <h2 class="display-6 mb-4">
                <i class="bi bi-calendar-week me-2 text-info"></i>
                Prévisions météorologiques
            </h2>
            <p class="text-muted">Prévisions horaires pour les prochains jours (données toutes les 3 heures)</p>
        </div>
    </div>

    <div class="row g-4 mb-5">
        <%
            for (Meteo prevision : previsions) {
        %>
        <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6">
            <div class="card text-center h-100">
                <div class="card-header bg-primary text-white">
                    <%= shortDateFormat.format(prevision.getDateMesure()) %>
                </div>
                <div class="card-body">
                    <!-- Icône météo -->
                    <%
                        String description = prevision.getDescription().toLowerCase();
                        String iconClass = "bi-cloud-sun";
                        String iconColor = "text-info";

                        if (description.contains("rain") || description.contains("pluie")) {
                            iconClass = "bi-cloud-rain";
                            iconColor = "text-primary";
                        } else if (description.contains("cloud") || description.contains("nuage")) {
                            iconClass = "bi-cloud";
                            iconColor = "text-secondary";
                        } else if (description.contains("sun") || description.contains("clear") || description.contains("ciel dégagé")) {
                            iconClass = "bi-sun";
                            iconColor = "text-warning";
                        } else if (description.contains("snow") || description.contains("neige")) {
                            iconClass = "bi-snow";
                            iconColor = "text-info";
                        }
                    %>
                    <i class="bi <%= iconClass %> <%= iconColor %>" style="font-size: 2.5rem;"></i>

                    <h4 class="text-primary mt-2">
                        <%= decimalFormat.format(prevision.getTemperature()) %>°C
                    </h4>

                    <p class="text-muted small mb-2">
                        <%= prevision.getDescription() %>
                    </p>

                    <small class="text-muted d-block">
                        <i class="bi bi-moisture me-1"></i><%= decimalFormat.format(prevision.getHumidite()) %>%
                    </small>

                    <% if (prevision.getPrecipitation() > 0) { %>
                    <small class="text-primary d-block">
                        <i class="bi bi-cloud-rain me-1"></i><%= decimalFormat.format(prevision.getPrecipitation()) %> mm
                    </small>
                    <% } %>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>
    <% } else { %>
    <div class="row mb-5">
        <div class="col-12">
            <div class="card">
                <div class="card-body text-center py-4">
                    <% if (previsionsError != null) { %>
                    <i class="bi bi-exclamation-triangle text-warning" style="font-size: 3rem;"></i>
                    <h5 class="mt-3 text-warning">Prévisions temporairement indisponibles</h5>
                    <p class="text-muted"><%= previsionsError %></p>
                    <% } else { %>
                    <i class="bi bi-info-circle text-info" style="font-size: 3rem;"></i>
                    <h5 class="mt-3 text-info">Prévisions en cours de chargement</h5>
                    <p class="text-muted">Les prévisions météorologiques seront disponibles sous peu.</p>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <% if (station.getDonneesMeteo() != null && station.getDonneesMeteo().size() > 1) { %>
    <div class="row mb-4">
        <div class="col-12">
            <h2 class="display-6 mb-4">
                <i class="bi bi-clock-history me-2 text-secondary"></i>
                Historique des mesures
            </h2>
        </div>
    </div>

    <div class="row mb-5">
        <div class="col-12">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">
                        <i class="bi bi-table me-2"></i>
                        Données historiques
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped mb-0">
                            <thead class="table-light">
                            <tr>
                                <th scope="col">
                                    <i class="bi bi-calendar3 me-1"></i>Date/Heure
                                </th>
                                <th scope="col">
                                    <i class="bi bi-thermometer-half me-1"></i>Température
                                </th>
                                <th scope="col">
                                    <i class="bi bi-cloud me-1"></i>Description
                                </th>
                                <th scope="col">
                                    <i class="bi bi-moisture me-1"></i>Humidité
                                </th>
                                <th scope="col">
                                    <i class="bi bi-speedometer2 me-1"></i>Pression
                                </th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                Map<Date, Meteo> donnees = station.getDonneesMeteo();
                                List<Map.Entry<Date, Meteo>> donneesTriees = new ArrayList<>(donnees.entrySet());
                                donneesTriees.sort((e1, e2) -> e2.getKey().compareTo(e1.getKey()));
                                for (Map.Entry<Date, Meteo> entry : donneesTriees) {
                            %>
                            <tr>
                                <td><%= dateFormat.format(entry.getKey()) %></td>
                                <td>
                                        <span class="fw-bold text-primary">
                                            <%= decimalFormat.format(entry.getValue().getTemperature()) %>°C
                                        </span>
                                </td>
                                <td><%= entry.getValue().getDescription() %></td>
                                <td><%= decimalFormat.format(entry.getValue().getHumidite()) %>%</td>
                                <td><%= entry.getValue().getPression() %> hPa</td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <% } else { %>
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body text-center py-5">
                    <i class="bi bi-exclamation-triangle text-danger" style="font-size: 4rem;"></i>
                    <h3 class="text-danger mt-3">Station non trouvée</h3>
                    <p class="text-muted">La station demandée n'existe pas ou n'est plus disponible.</p>
                    <a href="index.jsp" class="btn btn-primary btn-lg mt-3">
                        <i class="bi bi-arrow-left me-2"></i>Retour à l'accueil
                    </a>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <div class="row mt-5 mb-4">
        <div class="col-md-6">
            <a href="index.jsp" class="btn btn-secondary btn-lg w-100">
                <i class="bi bi-arrow-left me-2"></i>
                Retour à la liste des stations
            </a>
        </div>
        <div class="col-md-6">
            <div class="row g-2">
                <div class="col-6">
                    <a href="hot-stations" class="btn btn-danger w-100">
                        <i class="bi bi-thermometer-high me-1"></i>
                        Stations chaudes
                    </a>
                </div>
                <div class="col-6">
                    <a href="cold-stations" class="btn btn-info w-100">
                        <i class="bi bi-thermometer-low me-1"></i>
                        Stations froides
                    </a>
                </div>
            </div>
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
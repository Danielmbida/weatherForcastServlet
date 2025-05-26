<%@ page import="org.example.demo.business.StationMeteo" %>
<%@ page import="org.example.demo.business.Meteo" %>
<%@ page import="org.example.demo.business.Pays" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
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
<html>
<head>
    <title>Détails de la station - <%= station != null ? station.getNom() : "Station" %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/webjars/bootstrap/5.2.3/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .weather-card {
            background: linear-gradient(135deg, #74b9ff, #0984e3);
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .forecast-card {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            margin-bottom: 10px;
        }
        .temp-big {
            font-size: 3rem;
            font-weight: bold;
        }
        .weather-icon {
            font-size: 2rem;
        }
    </style>
</head>

<body>
<div class="container mt-4">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.jsp">Accueil</a></li>
            <li class="breadcrumb-item active">Détails de la station</li>
        </ol>
    </nav>


    <% if (errorMessage != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-triangle"></i> <%= errorMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <% if (successMessage != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle"></i> <%= successMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <% if (station != null) { %>
    <div class="row">
        <div class="col-12">
            <div class="weather-card">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1><i class="fas fa-broadcast-tower"></i> <%= station.getNom() %></h1>
                        <p class="mb-2">
                            <i class="fas fa-map-marker-alt"></i>
                            <%= station.getPays().getNom() %> (<%= station.getPays().getCode() %>)
                        </p>
                        <p class="mb-2">
                            <i class="fas fa-globe"></i>
                            Lat: <%= decimalFormat.format(station.getLatitude()) %>°
                            Long: <%= decimalFormat.format(station.getLongitude()) %>°
                        </p>
                        <p class="mb-0">
                            <i class="fas fa-hashtag"></i>
                            ID OpenWeatherMap: <%= station.getOpenWeatherMapId() %>
                        </p>
                    </div>
                    <div class="col-md-4 text-end">
                        <form method="post" style="display: inline;">
                            <input type="hidden" name="action" value="refresh">
                            <input type="hidden" name="stationName" value="<%= station.getNom() %>">
                            <button type="submit" class="btn btn-light btn-lg">
                                <i class="fas fa-sync-alt"></i> Actualiser
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <h2><i class="fas fa-thermometer-half"></i> Conditions actuelles</h2>
        </div>
    </div>

    <div class="row">
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
        <div class="col-md-4">
            <div class="card text-center">
                <div class="card-body">
                    <i class="fas fa-thermometer-half weather-icon text-primary"></i>
                    <div class="temp-big text-primary">
                        <%= decimalFormat.format(meteoActuelle.getTemperature()) %>°C
                    </div>
                    <p class="text-muted"><%= meteoActuelle.getDescription() %></p>
                    <small class="text-muted">
                        Mise à jour: <%= dateFormat.format(meteoActuelle.getDateMesure()) %>
                    </small>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <div class="row">
                <div class="col-md-6">
                    <div class="card text-center">
                        <div class="card-body">
                            <i class="fas fa-tint weather-icon text-info"></i>
                            <h5><%= decimalFormat.format(meteoActuelle.getHumidite()) %>%</h5>
                            <p class="text-muted">Humidité</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card text-center">
                        <div class="card-body">
                            <i class="fas fa-compress-arrows-alt weather-icon text-warning"></i>
                            <h5><%= meteoActuelle.getPression() %> hPa</h5>
                            <p class="text-muted">Pression</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card text-center">
                        <div class="card-body">
                            <i class="fas fa-eye weather-icon text-secondary"></i>
                            <h5><%= meteoActuelle.getVisibilite() / 1000 %> km</h5>
                            <p class="text-muted">Visibilité</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card text-center">
                        <div class="card-body">
                            <i class="fas fa-cloud-rain weather-icon text-primary"></i>
                            <h5><%= decimalFormat.format(meteoActuelle.getPrecipitation()) %> mm</h5>
                            <p class="text-muted">Précipitations</p>
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
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i> Aucune donnée météo disponible pour cette station.
            </div>
        </div>
        <%
            }
        %>
    </div>

    <%
        previsionsError = (String) request.getAttribute("previsionsError");
        if (previsions != null && !previsions.isEmpty()) {
    %>
    <div class="row mt-4">
        <div class="col-12">
            <h2><i class="fas fa-calendar-alt"></i> Prévisions météorologiques</h2>
            <p class="text-muted">Prévisions horaires pour les prochains jours (toutes les 3 heures)</p>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="row">
                <%
                    for (Meteo prevision : previsions) {
                %>
                <div class="col-lg-2 col-md-3 col-sm-4 col-6 mb-3">
                    <div class="forecast-card">
                        <div class="fw-bold text-primary">
                            <%= shortDateFormat.format(prevision.getDateMesure()) %>
                        </div>
                        <div class="weather-icon my-2">
                            <%
                                String description = prevision.getDescription().toLowerCase();
                                if (description.contains("rain") || description.contains("pluie")) {
                            %>
                            <i class="fas fa-cloud-rain text-primary"></i>
                            <% } else if (description.contains("cloud") || description.contains("nuage")) { %>
                            <i class="fas fa-cloud text-secondary"></i>
                            <% } else if (description.contains("sun") || description.contains("clear") || description.contains("ciel dégagé")) { %>
                            <i class="fas fa-sun text-warning"></i>
                            <% } else if (description.contains("snow") || description.contains("neige")) { %>
                            <i class="fas fa-snowflake text-info"></i>
                            <% } else { %>
                            <i class="fas fa-cloud-sun text-info"></i>
                            <% } %>
                        </div>
                        <div class="h5">
                            <%= decimalFormat.format(prevision.getTemperature()) %>°C
                        </div>
                        <small class="text-muted">
                            <%= prevision.getDescription() %>
                        </small>
                        <div class="mt-1">
                            <small class="text-muted">
                                <i class="fas fa-tint"></i> <%= decimalFormat.format(prevision.getHumidite()) %>%
                            </small>
                        </div>
                        <% if (prevision.getPrecipitation() > 0) { %>
                        <div class="mt-1">
                            <small class="text-info">
                                <i class="fas fa-cloud-rain"></i> <%= decimalFormat.format(prevision.getPrecipitation()) %> mm
                            </small>
                        </div>
                        <% } %>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
    <% } else { %>
    <div class="row mt-4">
        <div class="col-12">
            <% if (previsionsError != null) { %>
            <div class="alert alert-warning">
                <i class="fas fa-exclamation-triangle"></i>
                <%= previsionsError %>
            </div>
            <% } else { %>
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i>
                Prévisions météorologiques temporairement indisponibles.
            </div>
            <% } %>
        </div>
    </div>
    <% } %>


    <% if (station.getDonneesMeteo() != null && station.getDonneesMeteo().size() > 1) { %>
    <div class="row mt-4">
        <div class="col-12">
            <h2><i class="fas fa-history"></i> Historique des mesures</h2>
            <div class="table-responsive">
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>Date/Heure</th>
                        <th>Température</th>
                        <th>Description</th>
                        <th>Humidité</th>
                        <th>Pression</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Map.Entry<Date, Meteo> entry : station.getDonneesMeteo().entrySet()) { %>
                    <tr>
                        <td><%= dateFormat.format(entry.getKey()) %></td>
                        <td><%= decimalFormat.format(entry.getValue().getTemperature()) %>°C</td>
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
    <% } %>

    <% } else { %>
    <div class="alert alert-danger">
        <i class="fas fa-exclamation-triangle"></i> Station non trouvée.
    </div>
    <% } %>


    <div class="row mt-4">
        <div class="col-12">
            <a href="index.jsp" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Retour à la liste
            </a>
        </div>
    </div>
</div>

<script src="<%= request.getContextPath() %>/webjars/bootstrap/5.2.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>
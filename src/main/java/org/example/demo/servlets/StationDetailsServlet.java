package org.example.demo.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import org.example.demo.business.StationMeteo;
import org.example.demo.business.Meteo;
import org.example.demo.database.StationMeteoDAO;
import org.example.demo.service.ApiClass;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "stationDetailsServlet", value = "/station-details")
public class StationDetailsServlet extends HttpServlet {
    StationMeteoDAO stationMeteoDAO = new StationMeteoDAO();

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String stationName = request.getParameter("name");

        if (stationName == null || stationName.trim().isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            StationMeteo station = stationMeteoDAO.getStationMeteoByName(stationName);

            if (station == null) {
                request.setAttribute("errorMessage", "Station non trouvée: " + stationName);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            try {
                List<Meteo> previsions = ApiClass.fetchForecast(
                        station.getLatitude(),
                        station.getLongitude(),
                        5
                );

                List<Meteo> previsionsFiltered = filterPrevisions(previsions);
                request.setAttribute("previsions", previsionsFiltered);

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("previsions", null);
                request.setAttribute("previsionsError", "Prévisions temporairement indisponibles");
            }

            request.setAttribute("station", station);
            request.getRequestDispatcher("/stationDetails.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors de la récupération des détails de la station: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * Filtre les prévisions pour un affichage optimal
     * API gratuite donne des prévisions toutes les 3h
     */
    private List<Meteo> filterPrevisions(List<Meteo> previsions) {
        List<Meteo> filtered = new java.util.ArrayList<>();

        for (int i = 0; i < previsions.size(); i++) {
            filtered.add(previsions.get(i));

            if (filtered.size() >= 16) {
                break;
            }
        }

        return filtered;
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String action = request.getParameter("action");
        String stationName = request.getParameter("stationName");

        if ("refresh".equals(action) && stationName != null) {
            try {
                StationMeteo station = stationMeteoDAO.getStationMeteoByName(stationName);
                if (station != null) {
                    Meteo newMeteo = ApiClass.fetchMeteo(
                            station.getLatitude(),
                            station.getLongitude()
                    );

                    stationMeteoDAO.updateStationMeteo(station, newMeteo);

                    request.getSession().setAttribute("successMessage", "Données météo mises à jour avec succès");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("errorMessage", "Erreur lors de la mise à jour des données: " + e.getMessage());
            }

            response.sendRedirect("station-details?name=" + stationName);
        } else {
            doGet(request, response);
        }
    }
}
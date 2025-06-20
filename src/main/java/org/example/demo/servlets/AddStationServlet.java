package org.example.demo.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import org.example.demo.business.StationMeteo;
import org.example.demo.service.StationMeteoService;
import java.io.IOException;

@WebServlet(name = "addStationServlet", value = "/add-station")
public class AddStationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        double latitude = Double.parseDouble(request.getParameter("latitude"));
        double longitude = Double.parseDouble(request.getParameter("longitude"));
        StationMeteoService stationMeteoService = new StationMeteoService();

        try {
            StationMeteo station  = stationMeteoService.getStationMeteoByCoords(latitude,longitude);
            if (station == null || station.getOpenWeatherMapId() == null) {
                request.setAttribute("error", "Aucune station trouvée avec ces coordonnées.");
            }else{
                request.setAttribute("success", "Station ajoutée avec succès.");
            }
            request.getRequestDispatcher("index.jsp").forward(request, response);
            response.sendRedirect("index.jsp");
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

    }

}


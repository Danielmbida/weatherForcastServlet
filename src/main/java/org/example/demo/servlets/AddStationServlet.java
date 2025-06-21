package org.example.demo.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import org.example.demo.business.StationMeteo;
import org.example.demo.service.StationMeteoService;
import java.io.IOException;

@WebServlet(name = "addStationServlet", value = "/add-station")
public class AddStationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        double latitude = Double.parseDouble(request.getParameter("latitude"));
        double longitude = Double.parseDouble(request.getParameter("longitude"));
        StationMeteoService stationMeteoService = new StationMeteoService();

        try {
            StationMeteo station = stationMeteoService.getStationMeteoByCoords(latitude, longitude);
            if(station != null) {
                request.getSession().setAttribute("existed", "Cette station existe déja dans notre base de données sous le nom de: " + station.getNom());
            }
            else if(stationMeteoService.addStationMeteoToDB(latitude,longitude) == null) {
                request.getSession().setAttribute("error", "Aucune station trouvée avec ces coordonnées.");
            }else {
                request.getSession().setAttribute("success", "Station ajoutée avec succès.");
            }
            response.sendRedirect("index.jsp");

        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}





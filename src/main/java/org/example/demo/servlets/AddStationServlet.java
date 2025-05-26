package org.example.demo.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import org.example.demo.business.Pays;
import org.example.demo.business.StationMeteo;
import org.example.demo.database.MeteoDAO;
import org.example.demo.database.PaysDAO;
import org.example.demo.database.StationMeteoDAO;
import org.example.demo.service.ApiClass;
import org.example.demo.service.StationMeteoService;

import java.io.IOException;

@WebServlet(name = "addStationServlet", value = "/add-station")
public class AddStationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        double latitude = Double.parseDouble(request.getParameter("latitude"));
        double longitude = Double.parseDouble(request.getParameter("longitude"));
        StationMeteoService stationMeteoService = new StationMeteoService();

        System.out.println("Latitude : " + latitude + " Longitude : " + longitude);
        try {
            StationMeteo station  = stationMeteoService.getStationMeteoByCoords(latitude,longitude);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        response.sendRedirect("index.jsp"); // Redirige vers la page principale
    }

}


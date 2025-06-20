package org.example.demo.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.demo.business.*;
import org.example.demo.database.StationMeteoDAO;
import org.example.demo.service.StationMeteoService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "hotStations", value = "/hot-stations")
public class HotStationsServlet extends HttpServlet  {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, IOException {
        StationMeteoService stationMeteoService = new StationMeteoService();
        StationMeteoDAO stationMeteoDAO = new StationMeteoDAO();
        try {
            List<StationMeteo> topStations = stationMeteoDAO.getTop3StationsPlusChaudes();
            request.setAttribute("topHotStations", topStations);
            request.getRequestDispatcher("/hotstation.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Impossible de récupérer les stations chaudes.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}

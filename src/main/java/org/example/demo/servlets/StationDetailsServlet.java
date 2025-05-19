package org.example.demo.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import org.example.demo.business.StationMeteo;
import org.example.demo.database.StationMeteoDAO;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "stationDetailsServlet", value = "/station-details")
public class StationDetailsServlet extends HttpServlet {
    StationMeteoDAO stationMeteoDAO = new StationMeteoDAO();

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        StationMeteo station = stationMeteoDAO.getStationMeteoByName(request.getParameter("name"));

        request.setAttribute("station", station);
        request.getRequestDispatcher("/stationDetails.jsp").forward(request, response);
    }

}

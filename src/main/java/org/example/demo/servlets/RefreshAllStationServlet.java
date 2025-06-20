
package org.example.demo.servlets;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import org.example.demo.business.Meteo;
import org.example.demo.business.StationMeteo;
import org.example.demo.database.StationMeteoDAO;
import org.example.demo.service.ApiClass;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "refreshAllStationsServlet", value = "/refresh-all-stations")
public class RefreshAllStationServlet extends HttpServlet {
    private final StationMeteoDAO stationMeteoDAO = new StationMeteoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String redirectUrl = request.getParameter("redirectTo");
        if (redirectUrl == null || redirectUrl.isBlank()) {
            redirectUrl = "index.jsp";
        }
        try {
            List<StationMeteo> stations = stationMeteoDAO.getAllStationMeteo();

            for (StationMeteo station : stations) {
                try {
                    Meteo newMeteo = ApiClass.fetchMeteo(
                            station.getLatitude(),
                            station.getLongitude()
                    );
                    stationMeteoDAO.updateStationMeteo(station, newMeteo);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            request.getSession().setAttribute("success", "Toutes les stations ont été rafraîchies avec succès.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Erreur lors du rafraîchissement des stations : " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }
}

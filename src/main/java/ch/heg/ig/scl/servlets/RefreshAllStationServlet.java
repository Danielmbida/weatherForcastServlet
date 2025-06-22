
package ch.heg.ig.scl.servlets;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import ch.heg.ig.scl.business.Meteo;
import ch.heg.ig.scl.business.StationMeteo;
import ch.heg.ig.scl.service.ApiClass;
import ch.heg.ig.scl.service.StationMeteoService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "refreshAllStationsServlet", value = "/refresh-all-stations")
public class RefreshAllStationServlet extends HttpServlet {
    StationMeteoService stationMeteoService = new StationMeteoService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String redirectUrl = request.getParameter("redirectTo");
        if (redirectUrl == null || redirectUrl.isBlank()) {
            redirectUrl = "index.jsp";
        }
        try {
            List<StationMeteo> stations = stationMeteoService.getAllStationMeteo();
            System.out.println(stations);
            for (StationMeteo station : stations) {
                try {
                    Meteo newMeteo = ApiClass.fetchMeteo(
                            station.getLatitude(),
                            station.getLongitude()
                    );
                    stationMeteoService.updateStationMeteo(station, newMeteo);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            request.getSession().setAttribute("refresh", "Toutes les stations ont été rafraîchies avec succès.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorRefresh", "Erreur lors du rafraîchissement des stations : " + e.getMessage());
        }
        response.sendRedirect(redirectUrl);
    }
}

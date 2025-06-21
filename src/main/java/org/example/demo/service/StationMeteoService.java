package org.example.demo.service;


import org.example.demo.business.*;
import org.example.demo.database.*;
import java.io.IOException;
import java.util.List;

public class StationMeteoService  implements IStationMeteoService{


    private final StationMeteoDAO stationMeteoDAO = new StationMeteoDAO();
    private final MeteoDAO meteoDAO = new MeteoDAO();
    private final PaysDAO paysDAO = new PaysDAO();

    @Override
    public StationMeteo getStationMeteoByCoords(double lat, double lon) {
         return stationMeteoDAO.getStationByLCoords(lat, lon);
    }
    @Override
    public StationMeteo addStationMeteoToDB(double lat, double lon) throws Exception {
        StationMeteo stationMeteo = ApiClass.fetchStation(lat, lon);
        if(stationMeteo.getOpenWeatherMapId() != 0){
            saveAll(stationMeteo);
        }else{
            stationMeteo = null;
        }
        return stationMeteo;
    }

    @Override
    public List<StationMeteo> getTop3StationsPlusFroide() {
        return stationMeteoDAO.getTop3StationsPlusFroide();
    }

    @Override
    public List<StationMeteo> getTop3StationsPlusChaudes() {
        return stationMeteoDAO.getTop3StationsPlusChaudes();
    }

    @Override
    public List<StationMeteo> getAllStationMeteo() {
        return List.of();
    }

    @Override
    public StationMeteo getStationMeteoByName(String stationName) {
        StationMeteo stationMeteo;
        stationMeteo = stationMeteoDAO.getStationMeteoByName(stationName);
        if(stationMeteo == null) {
           throw new NullPointerException("Aucune station n'existe avec le nom: "+stationName);
        }
        return stationMeteo;
    }

    @Override
    public void updateStationMeteo(StationMeteo station, Meteo newMeteo) {
        stationMeteoDAO.updateStationMeteo(station, newMeteo);
    }


    private void saveAll(StationMeteo stationMeteo){
        Pays pays = stationMeteo.getPays();
        int paysId = paysDAO.save(pays);
        stationMeteo.getPays().setNumero(paysId);

        int stationId = stationMeteoDAO.createStationMeteo(stationMeteo);
        stationMeteo.setNumero(stationId);
        meteoDAO.save(stationMeteo);
    }
}

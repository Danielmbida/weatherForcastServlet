package ch.heg.ig.scl.service;


import ch.heg.ig.scl.business.*;
import ch.heg.ig.scl.database.*;

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
        return  stationMeteoDAO.getAllStationMeteo();
    }

    @Override
    public StationMeteo getStationMeteoById(int OpenWeatherID) {
        StationMeteo stationMeteo;
        stationMeteo = stationMeteoDAO.getStationByOpenWeatherMapId(OpenWeatherID);
        if(stationMeteo == null) {
           throw new NullPointerException("Aucune station n'existe dans la base avec l'id: "+ OpenWeatherID);
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

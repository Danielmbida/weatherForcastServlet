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
    public StationMeteo getStationMeteoByCoords(double lat, double lon) throws IOException, InterruptedException {
        StationMeteo stationMeteo;
        if(stationMeteoDAO.getStationByLCoords(lat, lon) == null) {
            try {
                addStationMeteoToDB(ApiClass.fetchStation(lat, lon));
            }catch (Exception e) {
                System.out.println(e.getMessage());
            }

        }
        stationMeteo = stationMeteoDAO.getStationByLCoords(lat, lon);
        return stationMeteo;
    }

    private void addStationMeteoToDB(StationMeteo stationMeteo) throws Exception {
        if(stationMeteo.getOpenWeatherMapId() != 0){
            saveAll(stationMeteo);
        }else{
            throw new Exception("Impossible d'ajouter une station sans ID openWeather");
        }
    }

    @Override
    public List<StationMeteo> getAllStationInDB(){
        return stationMeteoDAO.getAllStationMeteo();
    }

    @Override
    public StationMeteo getStationMeteoByNameFromDB(String name) {
        StationMeteo stationMeteo;
        stationMeteo = stationMeteoDAO.getStationMeteoByName(name);
        if(stationMeteo == null) {
           throw new NullPointerException("Aucune station n'existe avec le nom: "+name);
        }
        return stationMeteo;
    }

//    @Override
//    public List<Meteo> refreshMeteoAllStations() throws Exception {
//        return meteoDAO.refreshDataMeteo();
//    }

//    @Override
//    public Meteo refreshMeteoOneStation(StationMeteo stationMeteo) throws Exception {
//        return meteoDAO.refreshOneStationMeteo(stationMeteo);
//    }

    private void saveAll(StationMeteo stationMeteo){
        Pays pays = stationMeteo.getPays();
        int paysId = paysDAO.save(pays);
        stationMeteo.getPays().setNumero(paysId);

        int stationId = stationMeteoDAO.createStationMeteo(stationMeteo);
        stationMeteo.setNumero(stationId);
        meteoDAO.save(stationMeteo);
    }
}

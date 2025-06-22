package ch.heg.ig.scl.service;



import ch.heg.ig.scl.business.*;

import java.util.List;

public interface IStationMeteoService  {
    StationMeteo getStationMeteoByCoords(double lat, double lon);
    StationMeteo addStationMeteoToDB(double lat, double lon) throws Exception;
    List<StationMeteo> getTop3StationsPlusFroide();
    List<StationMeteo> getTop3StationsPlusChaudes();
    List<StationMeteo> getAllStationMeteo();
    StationMeteo getStationMeteoByName(String stationName);
    void updateStationMeteo(StationMeteo station, Meteo newMeteo);
}

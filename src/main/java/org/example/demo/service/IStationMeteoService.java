package org.example.demo.service;


import org.example.demo.business.*;

import java.io.IOException;
import java.rmi.RemoteException;
import java.sql.SQLException;
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

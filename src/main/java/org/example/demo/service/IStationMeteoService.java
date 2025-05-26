package org.example.demo.service;


import org.example.demo.business.*;

import java.io.IOException;
import java.rmi.RemoteException;
import java.sql.SQLException;
import java.util.List;

public interface IStationMeteoService  {
    StationMeteo getStationMeteoByCoords(double lat, double lon) throws IOException, InterruptedException, SQLException, RemoteException;
    StationMeteo getStationMeteoByNameFromDB(String name) throws RemoteException, SQLException;
    List<StationMeteo> getAllStationInDB() throws IOException, InterruptedException, SQLException;
//    List<Meteo> refreshMeteoAllStations() throws Exception;
//    Meteo refreshMeteoOneStation(StationMeteo stationMeteo) throws Exception;
    
}

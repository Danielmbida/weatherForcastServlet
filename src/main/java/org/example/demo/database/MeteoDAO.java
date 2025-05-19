package org.example.demo.database;



import org.example.demo.business.*;
import org.example.demo.service.ApiClass;
import oracle.jdbc.OraclePreparedStatement;
import org.example.demo.business.Meteo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class MeteoDAO {
    private Connection con;
    private OraclePreparedStatement pstmt;
    private ResultSet rs;

    private static int ligneUpdated = 0;
    public int save(StationMeteo stationMeteo) {
        try (Connection conn = DatabaseManager.getConnection()) {
            for (Map.Entry<Date, Meteo> entry : stationMeteo.getDonneesMeteo().entrySet()) {
                Date dateMesure = entry.getKey();
                Meteo meteo = entry.getValue();

                String selectSQL = "SELECT num FROM Meteos WHERE dateMesure = TRUNC(?, 'HH') AND sta_avoir_num = ?";
                String insertSQL = "INSERT INTO Meteos (sta_avoir_num, dateMesure, temperature, description, pression, humidite, visibilite, precipitation) VALUES (?, TRUNC(?, 'HH'), ?, ?, ?, ?, ?, ?)";

                try (PreparedStatement stmtSelect = conn.prepareStatement(selectSQL)) {
                    stmtSelect.setDate(1, new java.sql.Date(dateMesure.getTime()));
                    stmtSelect.setInt(2, stationMeteo.getNumero());

                    // Vérifier si la donnée météo existe déjà
                    ResultSet rs = stmtSelect.executeQuery();
                    if (rs.next()) {
                        System.out.println("Météo déjà existante");
                        return rs.getInt(1);
                    }

                    // Insérer la nouvelle donnée météo
                    try (PreparedStatement stmtInsert = conn.prepareStatement(insertSQL)) {
                        stmtInsert.setInt(1, stationMeteo.getNumero());
                        stmtInsert.setDate(2, new java.sql.Date(dateMesure.getTime()));
                        stmtInsert.setDouble(3, meteo.getTemperature());
                        stmtInsert.setString(4, meteo.getDescription());
                        stmtInsert.setDouble(5, meteo.getPression());
                        stmtInsert.setDouble(6, meteo.getHumidite());
                        stmtInsert.setDouble(7, meteo.getVisibilite());
                        stmtInsert.setDouble(8, meteo.getPrecipitation());

                        stmtInsert.executeUpdate();

                        rs = stmtSelect.executeQuery();
                        if (rs.next()) {
                            System.out.println("Météo insérée");
                            return rs.getInt(1);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // En cas d'erreur
    }

    public Map<Date, Meteo> findByStationNum(int stationNum) {
//        Connection con = null;
//        ResultSet rs = null;
//        OraclePreparedStatement pstmt = null;
        Map<Date, Meteo> donneesMetee = new HashMap<Date, Meteo>();
        //Date dateMesure = entry.getKey();

        try {
            con = DatabaseManager.getConnection();
            pstmt = (OraclePreparedStatement) con.prepareStatement("SELECT * FROM Meteos WHERE sta_avoir_num = ?");
            pstmt.setInt(1, stationNum);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Date dateMesure = rs.getDate("DATEMESURE");
                Meteo meteo = new Meteo();
                meteo.setNumero(rs.getInt("NUM"));
                meteo.setDateMesure(dateMesure);
                meteo.setTemperature(rs.getDouble("TEMPERATURE"));
                meteo.setDescription(rs.getString("DESCRIPTION"));
                meteo.setPression(rs.getInt("PRESSION"));
                meteo.setHumidite(rs.getDouble("HUMIDITE"));
                meteo.setVisibilite(rs.getInt("VISIBILITE"));
                meteo.setPrecipitation(rs.getDouble("PRECIPITATION"));

                donneesMetee.put(dateMesure, meteo);
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return donneesMetee;
    }

    public int update(int stationNum, Meteo meteo, Date dateMesure) {
        int rowsAffected;
        String query = "update Meteos set DATEMESURE = ?," +
                " TEMPERATURE = ?, DESCRIPTION = ?, " +
                "PRESSION = ?, HUMIDITE = ?," +
                "VISIBILITE = ?, PRECIPITATION = ? " + "  where STA_AVOIR_NUM = ?";
        try {
            con = DatabaseManager.getConnection();
            pstmt = (OraclePreparedStatement) con.prepareStatement(query);
            pstmt.setDate(1, new java.sql.Date(meteo.getDateMesure().getTime()));
            pstmt.setDouble(2, meteo.getTemperature());
            pstmt.setString(3, meteo.getDescription());
            pstmt.setInt(4, meteo.getPression());
            pstmt.setDouble(5, meteo.getHumidite());
            pstmt.setInt(6, meteo.getVisibilite());
            pstmt.setDouble(7, meteo.getPrecipitation());

            pstmt.setInt(8, stationNum);

            pstmt.executeUpdate();
            if (pstmt.getUpdateCount() == 0) {
                System.out.println("Aucune ligne mise à jour pour la station : " + stationNum);
            }else{
                ligneUpdated ++;
            }
            return ligneUpdated;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean refreshDataMeteo() {
        int nbLineAffected = 0;
        int nbUpdated = 0;
        StationMeteoDAO stationMeteoDAO = new StationMeteoDAO();
        try {
            con = DatabaseManager.getConnection();
            pstmt = (OraclePreparedStatement) con.prepareStatement("SELECT COUNT(*) FROM Meteos");
            rs = pstmt.executeQuery();
            if (rs.next()) {
                 nbLineAffected = rs.getInt(1);
            }
            pstmt.close();
            rs.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        stationMeteoDAO.getAllStationMeteo().forEach(stationMeteo -> {
            try {
                Meteo meteo;
                meteo = ApiClass.fetchMeteo(stationMeteo.getLatitude(), stationMeteo.getLongitude());
                update(stationMeteo.getNumero(), meteo,meteo.getDateMesure());
            } catch (IOException | InterruptedException e) {
                throw new RuntimeException(e);
            }
        });
        return nbLineAffected == ligneUpdated;
    }

}
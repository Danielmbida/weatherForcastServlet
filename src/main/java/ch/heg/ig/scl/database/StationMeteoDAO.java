package ch.heg.ig.scl.database;


import ch.heg.ig.scl.business.*;
import oracle.jdbc.OraclePreparedStatement;
import oracle.jdbc.OracleTypes;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StationMeteoDAO {

    private final PaysDAO  paysDAO = new PaysDAO();
    private final MeteoDAO meteoDAO = new MeteoDAO();
    private Connection con;
    private OraclePreparedStatement pstmt;
    private ResultSet rs;

    public Integer createStationMeteo(StationMeteo stationMeteo) {
        Integer id = null;
        try {
            con = DatabaseManager.getConnection();
            String SELECT_SQL = "select * from STATIONMETEOS where OWM_ID = ?";
            pstmt = (OraclePreparedStatement) con.prepareStatement(SELECT_SQL);
            pstmt.setInt(1,stationMeteo.getOpenWeatherMapId());
            rs = pstmt.executeQuery();
            if (rs.next()) {
                System.out.println("Station Meteo existante");
                id = rs.getInt(1);
                return id;
            }
            rs.close();
            pstmt.close();

            con.setAutoCommit(false);
            pstmt = (OraclePreparedStatement) con.prepareStatement("INSERT INTO StationMeteos (pay_situer_num, owm_id, latitude, longitude, nom) VALUES (?, ?, ?, ?, ?) RETURNING NUM INTO ?");

            if (stationMeteo.getPays() != null) {
                pstmt.setInt(1, stationMeteo.getPays().getNumero());
            } else {
                pstmt.setNull(1, OracleTypes.NULL);
            }
            pstmt.setDouble(2, stationMeteo.getOpenWeatherMapId());
            pstmt.setDouble(3, stationMeteo.getLatitude());
            pstmt.setDouble(4, stationMeteo.getLongitude());
            pstmt.setString(5, stationMeteo.getNom());

            pstmt.registerReturnParameter(6, OracleTypes.NUMBER);

            pstmt.executeUpdate();
            con.commit();

            rs = pstmt.getReturnResultSet();
            if (rs.next()) {
                id = rs.getInt(1);
            }
            rs.close();
            con.close();
            pstmt.close();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return id;
    }

    public StationMeteo getStationByLCoords(double lat, double lon){
        StationMeteo stationMeteo;
        try {
            con = DatabaseManager.getConnection();
            pstmt = (OraclePreparedStatement) con.prepareStatement("SELECT * FROM STATIONMETEOS WHERE LATITUDE= ? AND LONGITUDE= ?");
            pstmt.setDouble(1, lat);
            pstmt.setDouble(2, lon);
            stationMeteo = getStationMeteo(con, pstmt);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return stationMeteo;
    }
    public StationMeteo getStationMeteoByName(String stationName){
        StationMeteo stationMeteo;
        try {
            con = DatabaseManager.getConnection();
            pstmt = (OraclePreparedStatement) con.prepareStatement("SELECT * FROM STATIONMETEOS WHERE upper(NOM) = ?");
            pstmt.setString(1, stationName.trim().toUpperCase());
            stationMeteo = getStationMeteo(con, pstmt);
            rs.close();
            con.close();
            pstmt.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return stationMeteo;
    }

    private StationMeteo getStationMeteo(Connection con, OraclePreparedStatement pstmt) throws SQLException {
        rs = pstmt.executeQuery();
        StationMeteo stationMeteo = null;
        while (rs.next()) {
            stationMeteo = new StationMeteo(
                    rs.getInt("NUM"),
                    rs.getDouble("LATITUDE"),
                    rs.getDouble("LONGITUDE"),
                    rs.getString("NOM"),
                    paysDAO.findByNum(rs.getInt("pay_situer_num")),
                    rs.getInt("OWM_ID"),
                    meteoDAO.findByStationNum(rs.getInt("NUM"))
            );
        }
        rs.close();
        con.close();
        pstmt.close();
        return stationMeteo;
    }

    public List<StationMeteo> getAllStationMeteo(){
        List<StationMeteo> stationMeteoList = new ArrayList<StationMeteo>();
        try {
            con = DatabaseManager.getConnection();
            pstmt = (OraclePreparedStatement) con.prepareStatement("SELECT * FROM STATIONMETEOS");
            rs = pstmt.executeQuery();
            while (rs.next()) {
                StationMeteo stationMeteo = new StationMeteo(
                        rs.getInt("NUM"),
                        rs.getDouble("LATITUDE"),
                        rs.getDouble("LONGITUDE"),
                        rs.getString("NOM"),
                        paysDAO.findByNum(rs.getInt("pay_situer_num")),
                        rs.getInt("OWM_ID"),
                        meteoDAO.findByStationNum(rs.getInt("NUM"))
                );
                stationMeteoList.add(stationMeteo);
            }
            rs.close();
            con.close();
            pstmt.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return stationMeteoList;
    }

    public List<StationMeteo> getTop3StationsPlusChaudes() {
        List<StationMeteo> stationMeteoList = new ArrayList<>();

        String sql = """
        SELECT s.NUM, s.LATITUDE, s.LONGITUDE, s.NOM, s.PAY_SITUER_NUM, s.OWM_ID
        FROM STATIONMETEOS s
        JOIN (
            SELECT sta_avoir_num, MAX(DATEMESURE) AS last_date
            FROM METEOS
            GROUP BY sta_avoir_num
        ) latest ON s.NUM = latest.sta_avoir_num
        JOIN METEOS m ON m.sta_avoir_num = latest.sta_avoir_num AND m.DATEMESURE = latest.last_date
        ORDER BY m.TEMPERATURE DESC
        FETCH FIRST 3 ROWS ONLY
    """;
        try {
            con = DatabaseManager.getConnection();
            pstmt = (OraclePreparedStatement) con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int stationNum = rs.getInt("NUM");
                StationMeteo station = new StationMeteo(
                        stationNum,
                        rs.getDouble("LATITUDE"),
                        rs.getDouble("LONGITUDE"),
                        rs.getString("NOM"),
                        paysDAO.findByNum(rs.getInt("PAY_SITUER_NUM")),
                        rs.getInt("OWM_ID"),
                        meteoDAO.findByStationNum(stationNum) // ⚠️ récupère TOUTES les données météo ici
                );
                stationMeteoList.add(station);
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return stationMeteoList;
    }

    public List<StationMeteo> getTop3StationsPlusFroide() {
        List<StationMeteo> stationMeteoList = new ArrayList<>();

        String sql = """
        SELECT s.NUM, s.LATITUDE, s.LONGITUDE, s.NOM, s.PAY_SITUER_NUM, s.OWM_ID
        FROM STATIONMETEOS s
        JOIN (
            SELECT sta_avoir_num, MAX(DATEMESURE) AS last_date
            FROM METEOS
            GROUP BY sta_avoir_num
        ) latest ON s.NUM = latest.sta_avoir_num
        JOIN METEOS m ON m.sta_avoir_num = latest.sta_avoir_num AND m.DATEMESURE = latest.last_date
        ORDER BY m.TEMPERATURE ASC
        FETCH FIRST 3 ROWS ONLY
    """;

        try {
            con = DatabaseManager.getConnection();
            pstmt = (OraclePreparedStatement) con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int stationNum = rs.getInt("NUM");
                StationMeteo station = new StationMeteo(
                        stationNum,
                        rs.getDouble("LATITUDE"),
                        rs.getDouble("LONGITUDE"),
                        rs.getString("NOM"),
                        paysDAO.findByNum(rs.getInt("PAY_SITUER_NUM")),
                        rs.getInt("OWM_ID"),
                        meteoDAO.findByStationNum(stationNum) // ⚠️ récupère TOUTES les données météo ici
                );
                stationMeteoList.add(station);
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return stationMeteoList;
    }

    /**
     * Met à jour les données météo d'une station avec une nouvelle mesure
     * @param station La station à mettre à jour
     * @param newMeteo Les nouvelles données météo
     */
    public void updateStationMeteo(StationMeteo station, Meteo newMeteo) {
        try {
            java.util.Map<java.util.Date, Meteo> tempDonnees = new java.util.HashMap<>();
            tempDonnees.put(newMeteo.getDateMesure(), newMeteo);

            StationMeteo tempStation = new StationMeteo(
                    station.getNumero(),
                    station.getLatitude(),
                    station.getLongitude(),
                    station.getNom(),
                    station.getPays(),
                    station.getOpenWeatherMapId(),
                    tempDonnees
            );

            int result = meteoDAO.save(tempStation);

            if (result > 0) {
                station.getDonneesMeteo().put(newMeteo.getDateMesure(), newMeteo);
                System.out.println("Données météo mises à jour pour la station: " + station.getNom());
            } else {
                System.out.println("Aucune nouvelle donnée ajoutée (déjà existante) pour: " + station.getNom());
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de la mise à jour des données météo pour " + station.getNom() + ": " + e.getMessage(), e);
        }
    }
}



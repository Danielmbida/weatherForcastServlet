package ch.heg.ig.scl.database;

import oracle.jdbc.pool.OracleDataSource;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseManager {
    private static final String URL = "jdbc:oracle:thin:@db.ig.he-arc.ch:1521:ens";
    private static final String USER = "danielgh_mbida";
    private static final String PASSWORD = "danielgh_mbida";

    private static OracleDataSource ds;

    public static Connection getConnection() throws SQLException {
        //return DriverManager.getConnection(URL, USER, PASSWORD);
        if(ds == null){
            ds = new OracleDataSource();
            ds.setURL(URL);
            ds.setUser(USER);
            ds.setPassword(PASSWORD);
        }
        return ds.getConnection();
    }
}

package org.example.demo.database;



import org.example.demo.business.Pays;
import oracle.jdbc.OraclePreparedStatement;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class PaysDAO {
    public int save(Pays pays) {

        String selectSQL = "SELECT num FROM Pays WHERE code = '" + pays.getCode() + "'";
        String insertSQL = "INSERT INTO Pays (code, nom) VALUES ('" + pays.getCode() + "', '" + pays.getNom() + "')";

        try (Connection conn = DatabaseManager.getConnection();
             Statement stmtSelect = conn.createStatement()) {

            // Vérifier si le pays existe déjà
            ResultSet rs = stmtSelect.executeQuery(selectSQL);
            if (rs.next()) {
                System.out.println("Pays déjà existant");
                return rs.getInt(1);
            }
            // Insérer le pays
            try (Statement stmtInsert = conn.createStatement()) {
                stmtInsert.executeUpdate(insertSQL);
                rs = stmtSelect.executeQuery(selectSQL);
                if (rs.next()) {
                    System.out.println("Pays inséré");
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // En cas d'erreur
    }

    public Pays findByNum(int num) {
        Connection con = null;
        ResultSet rs = null;
        OraclePreparedStatement pstmt = null;
        String selectSQL = "SELECT * FROM Pays WHERE num = '" + num + "'";
        Pays pays = null;
        try {
            con = DatabaseManager.getConnection();
            pstmt = (OraclePreparedStatement) con.prepareStatement(selectSQL);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                pays = new Pays();
                pays.setCode(rs.getString("CODE"));
                pays.setNom(rs.getString("NOM"));
                pays.setNumero(rs.getInt("NUM"));
            }else{
                return null;
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
     return pays;
    }
}
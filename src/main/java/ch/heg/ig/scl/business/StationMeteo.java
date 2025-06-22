package ch.heg.ig.scl.business;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import ch.heg.ig.scl.deserializer.StationMeteoDeserializer;

import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@JsonDeserialize(using = StationMeteoDeserializer.class)

public class StationMeteo implements Serializable {
    private Integer numero;
    private Double latitude;
    private Double longitude;
    private String nom;
    private Pays pays;
    private Integer openWeatherMapId;

    private Map<Date, Meteo> donneesMeteo;
    private static int numPaysInexistant = 2000;
    private static int numNameInexistant = 0;

    public StationMeteo(Integer numero, Double latitude, Double longitude, String nom, Pays pays,
                       Integer openWeatherMapId, Map<Date, Meteo> donneesMeteo) {
        this.numero = numero;
        this.latitude = latitude;
        this.longitude = longitude;
        this.nom = (nom.isEmpty()) ? "outSide" + (++numNameInexistant) : nom;
        this.pays = (pays == null) ? new Pays(numPaysInexistant + 1, "hors", "Mer") : pays;
        this.openWeatherMapId = openWeatherMapId;
        this.donneesMeteo = (donneesMeteo != null) ? donneesMeteo : new HashMap<>();
    }
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("StationMeteo").append("\n");
        sb.append("nom: ").append(nom).append("\n");
        sb.append("numero: ").append(numero).append("\n");
        sb.append("latitude: ").append(latitude).append("\n");
        sb.append("longitude: ").append(longitude).append("\n");
        sb.append("openWeatherMapId: ").append(openWeatherMapId).append("\n");
        sb.append("\t").append("pays: ").append("\n");
        sb.append(pays).append("\n");
        sb.append("\t").append("donneesMeteo: ").append("\n");
        for (Map.Entry<Date, Meteo> entry : donneesMeteo.entrySet()) {
            sb.append(entry.getValue()).append("\n");
        }
        return sb.toString();
    }

    public String serialize(){
        try
        {
            ObjectMapper mapper = new ObjectMapper();
            return mapper.writeValueAsString
                    (this);
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    public  static StationMeteo deserialize(String jsonString){
        try
        {
            ObjectMapper mapper = new ObjectMapper();
            return mapper.readValue
                    (jsonString, StationMeteo.class);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    public Integer getNumero() {
        return numero;
    }

    public void setNumero(Integer numero) {
        this.numero = numero;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public Pays getPays() {
        return pays;
    }

    public void setPays(Pays pays) {
        this.pays = pays;
    }

    public Integer getOpenWeatherMapId() {
        return openWeatherMapId;
    }

    public void setOpenWeatherMapId(Integer openWeatherMapId) {
        this.openWeatherMapId = openWeatherMapId;
    }

    public Map<Date, Meteo> getDonneesMeteo() {
        return donneesMeteo;
    }

    public void setDonneesMeteo(Map<Date, Meteo> donneesMeteo) {
        this.donneesMeteo = donneesMeteo;
    }
}




package ch.heg.ig.scl.business;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import ch.heg.ig.scl.deserializer.MeteoDeserializer_Jackson;

import java.io.Serializable;
import java.util.Date;

@JsonDeserialize(using = MeteoDeserializer_Jackson.class)
public class Meteo implements Serializable {
    private Integer numero;
    private Date dateMesure;
    private Double temperature;
    private String description;
    private Integer pression;
    private Double humidite;
    private Integer visibilite;
    private Double precipitation;

    public Meteo() {
    }
    public Meteo(Integer numero, Date dateMesure, Double temperature, String description, Integer pression, Double humidite, Integer visibilite, Double precipitation) {
        this.numero = numero;
        this.dateMesure = dateMesure;
        this.temperature = temperature;
        this.description = description;
        this.pression = pression;
        this.humidite = humidite;
        this.visibilite = visibilite;
        this.precipitation = precipitation;
    }
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("\t\tnumero: ").append(numero).append("\n");
        sb.append("\t\tdateMesure: ").append(dateMesure).append("\n");
        sb.append("\t\ttemperature: ").append(temperature).append("\n");
        sb.append("\t\tdescription: ").append(description).append("\n");
        sb.append("\t\tpression: ").append(pression).append("\n");
        sb.append("\t\thumidite: ").append(humidite).append("\n");
        sb.append("\t\tvisibilite: ").append(visibilite).append("\n");
        sb.append("\t\tprecipitation: ").append(precipitation).append("\n");
        return sb.toString();
    }

    public String serialize(){
        try{
            ObjectMapper mapper = new ObjectMapper();
            return mapper.writeValueAsString(this);
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }

    public static Meteo deserialize(String jsonString){
        try{
            ObjectMapper mapper = new ObjectMapper();
            return mapper.readValue(jsonString, Meteo.class);
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

    public Date getDateMesure() {
        return dateMesure;
    }

    public void setDateMesure(Date dateMesure) {
        this.dateMesure = dateMesure;
    }

    public Double getTemperature() {
        return temperature;
    }

    public void setTemperature(Double temperature) {
        this.temperature = temperature;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getPression() {
        return pression;
    }

    public void setPression(Integer pression) {
        this.pression = pression;
    }

    public Double getHumidite() {
        return humidite;
    }

    public void setHumidite(Double humidite) {
        this.humidite = humidite;
    }

    public Integer getVisibilite() {
        return visibilite;
    }

    public void setVisibilite(Integer visibilite) {
        this.visibilite = visibilite;
    }

    public Double getPrecipitation() {
        return precipitation;
    }

    public void setPrecipitation(Double precipitation) {
        this.precipitation = precipitation;
    }

}

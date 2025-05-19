package org.example.demo.deserializer;

import org.example.demo.business.*;
import  org.example.demo.service.*;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class StationMeteoDeserializer extends JsonDeserializer<StationMeteo> {

    @Override
    public StationMeteo deserialize(JsonParser jsonParser, DeserializationContext deserializationContext)
            throws IOException {
        JsonNode node = jsonParser.getCodec().readTree(jsonParser);

        Integer numero = node.get("id").asInt();
        Double latitude = node.get("coord").get("lat").asDouble();
        Double longitude = node.get("coord").get("lon").asDouble();
        String nom = node.get("name").asText();
        Integer openWeatherMapId = node.get("id").asInt();

        JsonNode sysNode = node.get("sys");
        String code = (sysNode != null && sysNode.has("country")) ? sysNode.get("country").asText() : null;

        Pays pays = null;
        if (code != null) {
            pays = fetchPays(code);
        }
        Meteo meteo = fetchMeteo(latitude, longitude);
        Map<Date, Meteo> donneesMeteo = new HashMap<>();
        donneesMeteo.put(meteo.getDateMesure(), meteo);

        return new StationMeteo(numero, latitude, longitude, nom, pays, openWeatherMapId, donneesMeteo);
    }

    private Meteo fetchMeteo(double latitude, double longitude) throws IOException {
        try {
            return ApiClass.fetchMeteo(latitude, longitude);
        } catch (InterruptedException e) {
            throw new IOException("Erreur lors de la récupération du pays", e);
        }
    }
    protected Pays fetchPays(String paysCode) throws IOException {
        try {
            return ApiClass.fetchPays(paysCode, null);
        } catch (InterruptedException e) {
            throw new IOException("Erreur lors de la récupération du pays", e);
        }catch (NullPointerException e){
            throw new IOException("Pays n'existe pas", e);
        }
    }


}
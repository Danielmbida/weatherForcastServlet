package ch.heg.ig.scl.deserializer;


import ch.heg.ig.scl.business.*;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;

import java.io.IOException;
import java.util.Date;

public class MeteoDeserializer_Jackson extends JsonDeserializer<Meteo> {
    @Override
    public Meteo deserialize(JsonParser jsonParser, DeserializationContext deserializationContext)
            throws IOException {
        JsonNode node = jsonParser.getCodec().readTree(jsonParser);


        int numero;
        if (node.has("id")) {
            numero = node.get("id").asInt();
        } else {
            numero = node.get("dt").asInt();
        }

        Date dateMesure = new Date(node.get("dt").asLong() * 1000);
        double temperature = node.get("main").get("temp").asDouble();
        String description = node.get("weather").get(0).get("description").asText();
        int pression = node.get("main").get("pressure").asInt();
        double humidite = node.get("main").get("humidity").asDouble();


        int visibilite = node.has("visibility") ? node.get("visibility").asInt() : 10000;


        double precipitation = 0.0;

        if (node.has("rain")) {
            JsonNode rainNode = node.get("rain");
            if (rainNode.has("1h")) {
                precipitation = rainNode.get("1h").asDouble();
            } else if (rainNode.has("3h")) {
                precipitation = rainNode.get("3h").asDouble();
            }
        } else if (node.has("snow")) {
            JsonNode snowNode = node.get("snow");
            if (snowNode.has("1h")) {
                precipitation = snowNode.get("1h").asDouble();
            } else if (snowNode.has("3h")) {
                precipitation = snowNode.get("3h").asDouble();
            }
        }

        return new Meteo(numero, dateMesure, temperature, description, pression, humidite, visibilite, precipitation);
    }
}
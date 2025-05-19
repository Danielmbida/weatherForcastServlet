package org.example.demo.deserializer;


import org.example.demo.business.*;
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
        int numero = node.get("id").asInt();
        Date dateMesure = new Date(node.get("dt").asLong() * 1000);  // Convertir timestamp en Date
        double temperature = node.get("main").get("temp").asDouble();
        String description = node.get("weather").get(0).get("description").asText();
        int pression = node.get("main").get("pressure").asInt();
        double humidite = node.get("main").get("humidity").asDouble();
        int visibilite = node.get("visibility").asInt();
        double precipitation = node.has("rain") ? node.get("rain").has("1h") ? node.get("rain").get("1h").asDouble() : 0.0 : 0.0;
        return new Meteo(numero, dateMesure, temperature, description, pression, humidite, visibilite, precipitation);
    }
}
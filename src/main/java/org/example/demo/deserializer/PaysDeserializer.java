package org.example.demo.deserializer;

import org.example.demo.business.*;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;

import java.io.IOException;

public class PaysDeserializer extends JsonDeserializer<Pays> {
    @Override
    public Pays deserialize(JsonParser jsonParser, DeserializationContext deserializationContext)
            throws IOException, JsonProcessingException {
        JsonNode node = jsonParser.getCodec().readTree(jsonParser);
        String code = node.get("code").asText();
        String nom = node.get("name").asText();
        return new Pays(null, code, nom);
    }
}

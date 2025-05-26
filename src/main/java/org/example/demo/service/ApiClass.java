package org.example.demo.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.example.demo.business.*;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ApiClass {

    /**
     * Cette méthode récupérer les données reçu de l'api et les envoie à la méthode désirializer de la classe pays
     * @param code code du pays voulant être récupéré, il est passé à l'url
     * @param lang langue dans laquel les informations récupérés s'afficheront
     * @return
     * @throws IOException
     * @throws InterruptedException
     */
    public static Pays fetchPays(String code, String lang) throws IOException, InterruptedException, NullPointerException {
        if(lang==null) lang = "fr";
        String BASE_URL = "https://db.ig.he-arc.ch/ens/scl/ws/country/" + code.toLowerCase() + "?lang=" + lang;
        System.out.println(BASE_URL);
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL))
                .build();
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        return Pays.deserialize(response.body());
    }
    public  static StationMeteo fetchStation(double latitude, double longitude) throws IOException, InterruptedException, NullPointerException {
        return StationMeteo.deserialize(callWheaterApi(latitude, longitude));

    }
    public  static Meteo fetchMeteo(double latitude, double longitude) throws IOException, InterruptedException, NullPointerException {
        return Meteo.deserialize(callWheaterApi(latitude, longitude));

    }


    private static String callWheaterApi(double latitude, double longitude) throws IOException, InterruptedException, NullPointerException {
        String apiKey = "255aa1170aea43e548991563587c904d";
        String url = "https://api.openweathermap.org/data/2.5/weather?"
                + "lat=" + latitude
                + "&lon=" + longitude
                + "&units=metric"
                + "&appid=" + apiKey;

        System.out.println(url);
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        return  response.body();
    }

    /**
     * Récupère les prévisions météorologiques pour une position géographique
     * API gratuite forecast : 5 jours maximum, données toutes les 3 heures
     * @param latitude Latitude de la station
     * @param longitude Longitude de la station
     * @param days Nombre de jours de prévisions (max 5)
     * @return Liste des prévisions météo (toutes les 3h)
     */
    public static List<Meteo> fetchForecast(double latitude, double longitude, int days)
            throws IOException, InterruptedException {

        String apiKey = "255aa1170aea43e548991563587c904d";


        int maxPrevisions = Math.min(days * 8, 40);

        String url = String.format(
                "https://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&appid=%s&units=metric&lang=fr&cnt=%d",
                latitude, longitude, apiKey, maxPrevisions
        );

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 200) {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response.body());
            JsonNode list = root.get("list");

            List<Meteo> previsions = new ArrayList<>();

            for (JsonNode item : list) {
                Meteo prevision = mapper.readValue(item.toString(), Meteo.class);
                previsions.add(prevision);
            }

            return previsions;
        } else {
            throw new IOException("Erreur API météo prévisions: " + response.statusCode() + " - " + response.body());
        }
    }

}

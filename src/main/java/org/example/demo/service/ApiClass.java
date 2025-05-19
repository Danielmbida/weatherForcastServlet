package org.example.demo.service;

import org.example.demo.business.*;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

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
}

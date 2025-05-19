package org.example.demo.business;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import org.example.demo.deserializer.PaysDeserializer;

import java.io.Serializable;

@JsonDeserialize(using = PaysDeserializer.class)
public class Pays implements Serializable {
    private Integer numero;
    private String code;
    private String nom;

    public Pays() {
    }
    public Pays(Integer numero, String code, String nom) {
        this.numero = numero;
        this.code = code;
        this.nom = nom;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("\t\tnumero: ").append(numero).append("\n");
        sb.append("\t\tcode: ").append(code).append("\n");
        sb.append("\t\tnom: ").append(nom).append("\n");
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

    public static Pays deserialize(String jsonString){
        try{
            ObjectMapper mapper = new ObjectMapper();
            return mapper.readValue(jsonString, Pays.class);
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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }
}

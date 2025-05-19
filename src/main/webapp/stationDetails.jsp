<%@ page import="org.example.demo.business.StationMeteo" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    StationMeteo station = (StationMeteo) request.getAttribute("station");
%>
<html>
<head>
    <title>JSP - Satation detail</title>
</head>
<body>
    <h1><%= "Détails de la station: "+ station.getNom() %></h1>
</body>
</html>

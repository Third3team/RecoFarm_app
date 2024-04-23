<%@page import="org.rosuda.REngine.Rserve.RConnection"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("utf-8");

    double areaSize = Double.parseDouble(request.getParameter("areaSize"));
    double lat = Double.parseDouble(request.getParameter("lat"));
    double lng = Double.parseDouble(request.getParameter("lng"));
 
    RConnection conn = new RConnection();
    
    
    conn.voidEval("library(randomForest)");

    conn.voidEval("data <- read.csv('/Library/Tomcat/webapps/ROOT/Flutter/Project_Rserve/predict_weather.csv')");
    conn.voidEval("data <- data[data$lat == " + lat +",][1,]");

    conn.voidEval("rf <- readRDS('/Library/Tomcat/webapps/ROOT/Flutter/Project_Rserve/rf_recoFarm_product_model_ver1.rds')");
    
    String script = "result <- (predict(rf, list(" +
                    "areaSize=" + areaSize + ", " +
                    "lat=" + lat + ", " +
                    "lng=" + lng + ", " +
                    "humidity=data$humidity, " +
                    "soilMoisture=data$soilMoisture, " +
                    "temperature=data$temperature," +
                    "surfaceTemperature=data$surfaceTemperature)))";
    
    conn.voidEval(script);

    String test = conn.eval("exp(result)").asString();
%>
    {"result" : <%= test %>}
<%

%>

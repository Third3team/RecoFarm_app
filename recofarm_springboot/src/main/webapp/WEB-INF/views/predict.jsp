<%@page import="org.rosuda.REngine.Rserve.RConnection"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("utf-8");

    double areaSize = Double.parseDouble(request.getParameter("areaSize"));
    double lat = Double.parseDouble(request.getParameter("lat"));
    double lng = Double.parseDouble(request.getParameter("lng"));
 
    RConnection conn = new RConnection();
    
    
    conn.voidEval("data <- read.csv('/Library/Tomcat/webapps/ROOT/Flutter/Project_Rserve/predict_weather.csv')");
    conn.voidEval("library(randomForest)");
    conn.voidEval("rf <- readRDS('/Library/Tomcat/webapps/ROOT/Flutter/Project_Rserve/rf_recoFarm_product_model.rds')");
    
    conn.voidEval("data$humidity")
    conn.voidEval(
        "result <- as.character(
            predict(rf, 
                (list(
                    재배면적.제곱미터.="+ areaSize +", 
                    위도="+ lat +", 
                    경도="+ lng +", 
                    평균습도=data$humidity,
                    토양수분=data$soilMoisture, 
                    평균기온=data$temperature, 
                    평균지면온도=data$surfaceTemperature
                ))))"
    );

    String result = conn.eval("result").asString();
%>

    {"result" : "<%=result%>"} 
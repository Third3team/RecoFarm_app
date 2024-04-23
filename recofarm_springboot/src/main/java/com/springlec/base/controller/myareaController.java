package com.springlec.base.controller;

import java.io.PrintWriter;
import java.util.List;

import org.apache.catalina.connector.Response;
import org.apache.jasper.tagplugins.jstl.core.Out;
import org.rosuda.REngine.Rserve.RConnection;
//import org.rosuda.REngine.Rserve.RConnection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.springlec.base.model.myareaDto;
import com.springlec.base.model.usersDto;
import com.springlec.base.service.myareaDaoService;
import com.springlec.base.service.usersDaoService;

// 컨트롤러
/*--------------------------------------
 * Description	: 내 관심 농작지 DB controller 
 * Author 		: PDG
 * Date 		: 2024.04.21
 * Update
 * 	2024.04.21 by pdg
 * 		- 내 농작지 조회 기능 api json 으로 출력하는 기능 추가  
 * 		- insert 기능 추가 
 *  2024.04.22 by pdg
*/

@Controller
public class myareaController {
	@Autowired 
	myareaDaoService service; //(수정필요)
//	//Test 
//	@GetMapping("/myareaInsert")
//	public String test() throws Exception {
//		System.out.println("** Root page start **");
//		return "test";
//		
//	}
	
	@GetMapping("/predict")
	public ResponseEntity<String> signup(
			HttpServletRequest request
			) throws Exception {
			System.out.println(" Rserve 연결 ");
		 double areaSize = Double.parseDouble(request.getParameter("areaSize"));
		    double lat = Double.parseDouble(request.getParameter("lat"));
		    double lng = Double.parseDouble(request.getParameter("lng"));
		 
		    RConnection conn = new RConnection();
//		    conn.voidEval("library(Rserve)");
//		    conn.voidEval("Rserve(FALSE, port=6311, args = '--RS-encoding utf8 --no-save')");
		    
		    
		    
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

		    
		return ResponseEntity.ok(test);
	}
	@GetMapping("/myarea")
	public ResponseEntity<String> signup(
			HttpServletRequest request,
			HttpServletResponse response
			
			) throws Exception {
		System.out.println("** <<myareaController @Get :  >> **\n");
		
		String userId =request.getParameter("userId");
		
		System.out.println(">> user Id : "+ userId +"\n");
				
		//Gson
		List<myareaDto> result = service.myareaListDao(userId);
		
		Gson gson = new Gson();
		
		//String result_one = service.myareaOneDao(userId);
		//System.out.println(">> 내소재지 작물 : "+result_one);
		//PrintWriter out = response.getWriter(); // try 바깥에서 선언해라. 
//		out.print(gson.toJson(result));
		//out.print(new Gson().toJson(result));

		return ResponseEntity.ok(gson.toJson(result));
	}
	@GetMapping("/myareaInsert")
	public String myareaInsert(
			HttpServletRequest request,
			HttpServletResponse response
			) throws Exception {
		System.out.println("** <<myareaInsertController @Get :  >> **\n");
		
		String userId 		=request.getParameter("userId");
		Double area_lat 	=Double.parseDouble(request.getParameter("area_lat"));
		Double area_lng 	=Double.parseDouble(request.getParameter("area_lng"));
		Double area_size 	=Double.parseDouble(request.getParameter("area_size"));
		String area_product =request.getParameter("area_product");
		String area_address =request.getParameter("area_address");
		
		System.out.println(">> user Id : "+ userId +"\n");
				
		// Insert dao 실행 
		 service.myareaInsertDao(userId, area_lat, area_lng, area_size, area_product, area_address);
		

		return "";
	}

}









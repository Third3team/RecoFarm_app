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
 * Description	: 전국 기상 관측소 위도 경도 및 기후 데이터 API  
 * Author 		: PDG
 * Date 		: 2024.04.25
 * Update
 *  2024.04.25 by pdg
 *  	- 생성 
*/

@Controller
public class weatherStationController {
	// Bin connect
	//@Autowired 
	//weatherStationDaoService service; 

	@GetMapping("/stationLoc")
	public  void weatherStationLoc() throws Exception {
		
		System.out.println("** << weather Station Controller  @Get :  >> **\n");
	
	}
	
}









package com.springlec.base.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.springlec.base.model.usersDto;
import com.springlec.base.service.usersDaoService;

// 컨트롤러
/*--------------------------------------
 * Description	: Home controller 
 * Author 		: PDG
 * Date 		: 2024.04.19
 * Update
 * 	2024.04.19 by pdg
 * 		- user sign up api 
 *  202404.27 by pdg
 *  	- user 는fire base 로 관리하므로 여기는home 으로 사용.
*/

@Controller
public class homeController {
	@Autowired //Dao service interface 에 연결한다.
	usersDaoService service; //(수정필요)
	//Test 
	@GetMapping("/")
	public String test() throws Exception {
		System.out.println("** Root page start **");
		return "test";
		
	}
	@GetMapping("/signup")
	public String signup(
			HttpServletRequest request
			) throws Exception {
		System.out.println("** <<UsersController @Get : userSignUp >> **");
		
		String userId =request.getParameter("userId");
		String userPw = request.getParameter("userPw");
		String userName = request.getParameter("userName");
		String userEmail =request.getParameter("userEmail");
		String userNickname = request.getParameter("userNickname");
		String userMobile = request.getParameter("userMobile");
		
		System.out.println(">> user Id : "+ userId +"\n"+
				">> user Pw : "+ userPw + "\n"+
				">> user Name : " + userName + "\n"+
				">> user Email : "+ userEmail + "\n"
				);
		service.signUpDao(userId, userPw, userName, userEmail, userNickname, userMobile);
		
		// http example : 
			// localhost:8080/signup?userId=pulpilisory01&userPw=123123&userName=Forrest&userEmail=pulpilisory@gmail.com&userNickname=pdg&userMobile=01077221592
		
		return "/signcomplete";
	}
//	@GetMapping("/write")
//	public String write() throws Exception {
//		System.out.println("** Root page start11 **");
//		return "test";
//		
//	}
//	public String list(Model model) throws Exception{
//		System.out.println(">> user controller 실행 : 조회 수행");
//		List<usersDto> listDao = service.listDao();
//		model.addAttribute("list", listDao);
//		return "list";
//	}
	
}









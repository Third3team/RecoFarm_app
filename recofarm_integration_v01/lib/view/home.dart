import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:new_recofarm_app/view/find_my_password.dart';
import 'package:new_recofarm_app/view/interesting_area.dart';
import 'package:new_recofarm_app/view/login_page.dart';
import 'package:new_recofarm_app/view/mainview.dart';
import 'package:new_recofarm_app/view/register_page.dart';

import 'web_view_page.dart';

/*
 
  Description : 현재 Page는 앱 실행 이후 스플래쉬 다음에 나오는 로그인 화면으로 만들었으면 좋겠습니다.
                파일명은 일단 home으로 만들었습니다.
                main 실행 시 home으로 들어오니까 test를 위해서 일단 버튼을 만들었습니다. 
  Date        : 2024-04-17 13:33
  Author      : lcy
  Updates     : 
  Detail      : 
    -2024.04.20 by pdg
      회원가입 페이지 및 로그인 페이지 추가  
    -2024.04.21 by pdg
      내 관심 소재지 등록 페이지 추가 

*/

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Function pagess',
        style: TextStyle(
          fontSize: 50
        ),)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [



            ElevatedButton(
              onPressed: () => Get.to(InterestingAreaPage()), 
              child: const Text("=> 나의 관심 농작지")),

            ElevatedButton(
              onPressed: () => Get.to(FindPasswordPage()), 
              child: const Text("=> 비밀번호 찾기")),

            ElevatedButton(
              onPressed: () => Get.to(RegisterPage()), 
              child: const Text('=> 회원가입(mySQL ver)')),

            ElevatedButton(
              onPressed:()=> Get.to(RegisterPage()), 
              child: const Text("=> 회원가입(FireBasee ver)")),
            
            ElevatedButton(
                onPressed: () {
                  // Login Page by pdg
                  Get.to(LoginPage(),
                    transition: Transition.circularReveal,
                    
                  );
                },
                // Get 경로 알아서 하시면 됩니다. home.dart는 스플래시 화면 및 로그인 메뉴로 만들 생각입니다
                child: const Text('=> Login')),
            ElevatedButton(
                onPressed: () => Get.to(const MainView()),
                child: const Text('=> main')),

            ElevatedButton(
              onPressed: () => Get.to( WebViewPage()), 
              child: const Text("=> WebView"))
          ],
        ),
      ),
    );
  }
}

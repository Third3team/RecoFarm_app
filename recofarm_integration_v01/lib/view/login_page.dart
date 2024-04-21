import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

/*
  Description : Login Page 
  Date        : 2024.04.21 sun
  Author      : Forrest DongGeun Park. (PDG)
  Updates     : 

    2024.04.21 by pdg
      -fire base 없는 버전으로 페이지 버전 2 생성
  Detail      : - 

*/


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // userId, userPw  text field 
  TextEditingController userIdController = TextEditingController();
  TextEditingController userPwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          '로그인',
          style: TextStyle(
              fontSize: 50,
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        left: true,
        right: true,
        child: Stack(
          children: [
            Container(
              color: Theme.of(context).colorScheme.onInverseSurface,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50.0), // 상단 패딩 추가
                  Image.asset(
                    "images/farmer.png",
                    height: 200,
                  ),
                  Row(
                    children: [
                      const Expanded(flex: 1, child: Text("  아이디")),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            isDense: true,
                            hintText: "아이디를 입력하세요.",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller: userIdController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Expanded(flex: 1, child: Text("  비밀번호")),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            isDense: true,
                            hintText: "비밀번호를 입력하세요.",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          controller: userPwController,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // 회원 가입 페이지로 이동
                          Get.toNamed('/register');
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        child: const Text(
                          '회원가입하기',
                          style:
                              TextStyle(color: Color.fromARGB(255, 78, 101, 121)),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        child: const Text(
                          '로그인하기',
                        ),
                        onPressed: () async {
                          setState(() {
                            //showLoading = true;
                          });
        
                          String userId = userIdController.text.trim();
                          String userPw = userPwController.text.trim();
        
                          if (userId.isEmpty || userPw.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "아이디와 비밀번호를 입력해 주세요.",
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              fontSize: 16.0,
                            );
                            setState(() {
                              //showLoading = false;
                            });
                            return;
                          }
                          // my SQL 로그인
        
                          await mySQL_login(userId, userPw);
                          // Firebase에 이메일과 비밀번호로 로그인
                          //await signInWithEmailAndPassword(userId, userPw);
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // 비밀번호찾기 페이지로 이동
                          Get.toNamed('/findPw');
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        child: const Text(
                          '비밀번호찾기',
                          style:
                              TextStyle(color: Color.fromARGB(255, 65, 154, 9)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: (){}, 
                        icon:Image.asset("images/naver/btnW_.png",
                      width: 100,), )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Function

  mySQL_login(userId, UserPw) async {
    print("user id : $userId");
  }
} //ENd

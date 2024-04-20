import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

/*
  Description : Login Page 
  Date        : 2024.04.20 Sat
  Author      : Forrest DongGeun Park. (PDG)
  Updates     : 
	  2024.0420 Sat by pdg
		  - 로그인 페이지  이메일이 아니라 아이디 비밀번호로 바꿈 
      - 테마 및 글자 크기 변경함. 
  Detail      : - 

*/
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController userPwController = TextEditingController();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool showLoading = false;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Firebase에 이메일과 비밀번호로 로그인을 시도합니다.
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 로그인 완료 메시지 표시
      Fluttertoast.showToast(
        msg: "로그인 완료!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        fontSize: 16.0,
      );

      setState(() {
        showLoading = false;
      });
    } on FirebaseAuthException catch (error) {
      setState(() {
        showLoading = false;
      });

      String errorMessage = "로그인 중 오류가 발생했습니다.";
      if (error.code == 'user-not-found') {
        errorMessage = "등록되지 않은 이메일입니다.";
      } else if (error.code == 'wrong-password') {
        errorMessage = "잘못된 비밀번호입니다.";
      } else {
        errorMessage = "오류: 이메일 혹은 비밀번호를 다시 입력하세요";
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        fontSize: 16.0,
      );
    }
  }

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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
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
                    const Expanded(flex: 1, child: Text("아이디")),
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
                    const Expanded(flex: 1, child: Text("비밀번호")),
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
                        Get.toNamed(
                          '/register'
                          
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      child: const Text('회원가입하기',
                      style: TextStyle(
                        color: Color.fromARGB(255, 78, 101, 121)
                      ),),
                    ),

                    SizedBox(width: 20,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      child: const Text('로그인하기',),
                      onPressed: () async {
                        setState(() {
                          showLoading = true;
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
                            showLoading = false;
                          });
                          return;
                        }
                        // my SQL 로그인 

                        await mySQL_login(userId,userPw);
                        // Firebase에 이메일과 비밀번호로 로그인
                        await signInWithEmailAndPassword(userId, userPw);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Visibility(
              visible: showLoading,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 80,
                    color: Colors.white,
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                          SizedBox(width: 20),
                          Text("잠시만 기다려 주세요"),
                          SizedBox(width: 20),
                          Opacity(
                            opacity: 0,
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Function

  mySQL_login(userId,UserPw) async{
    print("user id : $userId");
  }
}//ENd

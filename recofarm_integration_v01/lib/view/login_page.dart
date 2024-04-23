import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:new_recofarm_app/view/mainview.dart';
import 'package:new_recofarm_app/vm/sqlite_handler.dart';
import 'package:new_recofarm_app/vm/user_firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  // userId, userPw  text field 
  TextEditingController userIdController = TextEditingController();
  TextEditingController userPwController = TextEditingController();
  TextEditingController easyLoginUserPwController = TextEditingController();


  @override
  void initState() {
    super.initState();
    // WidgetsBindingObserver 기능을 받아야 함. (with)
    WidgetsBinding.instance.addObserver(this);
    alreadyExistUserInfo();
  }

// AppLifecycle의 state가 변경 되었을 때,
// 따라서 앱이 종료되었을때 SharedPreferences 초기화 해준다.
@override
void didChangeAppLifecycleState(AppLifecycleState state) async {
  super.didChangeAppLifecycleState(state);
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  switch(state) {
    // 다른 앱으로 전환했을 때,
    case AppLifecycleState.detached :
      break;
    // 앱이 다시 실행되었을 때,
    case AppLifecycleState.resumed :
		  prefs.clear();
      break;
    // 앱이 완전히 종료되었을 때,
    case AppLifecycleState.inactive :
		  prefs.clear();
	    break;
    // 앱이 중지되었을 떄,
    case AppLifecycleState.paused :
      break;
    default :
      break;
  }
}

@override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          '로그인',
          style: TextStyle(
              fontSize: 50,
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50.0), // 상단 패딩 추가
            Image.asset(
              "images/farmer.png",
              height: 200,
            ),
            DefaultTabController(
              length: 2,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const SizedBox(
                      width: 300,
                      child: TabBar(
                        tabs: [
                          Tab(
                            child: Text(
                              '일반 로그인',
                              style: TextStyle(
                                fontSize: 25
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              '간편 로그인',
                              style: TextStyle(
                                fontSize: 25
                              ),
                            ),
                          ),
                        ]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: SizedBox(
                        width: 300,
                        height: 150,
                        child: TabBarView(
                          children: [
                            // 일반 로그인 Form
                            Column(
                              children: [
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
                              ],
                            ),
                            
                            // 간편 로그인 Form
                            Column(
                              children: [
                                // Row(
                                //   children: [
                                //     const Expanded(flex: 1, child: Text("  아이디")),
                                //     Expanded(
                                //       flex: 3,
                                //       child: TextFormField(
                                //         style: const TextStyle(
                                //           fontSize: 25,
                                //         ),
                                //         decoration: const InputDecoration(
                                //           contentPadding: EdgeInsets.symmetric(
                                //               vertical: 10.0, horizontal: 10.0),
                                //           isDense: true,
                                //           hintText: "아이디를 입력하세요.",
                                //           enabledBorder: OutlineInputBorder(
                                //             borderSide: BorderSide(color: Colors.grey),
                                //           ),
                                //           focusedBorder: OutlineInputBorder(
                                //             borderSide: BorderSide(color: Colors.red),
                                //           ),
                                //         ),
                                //         keyboardType: TextInputType.emailAddress,
                                //         controller: userIdController,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Text("간편비밀번호   "),
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
                                          hintText: "간편 비밀번호를 입력하세요.",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.red),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        obscureText: true,
                                        controller: easyLoginUserPwController,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
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

                    if(easyLoginUserPwController.text.trim() != '') {
                      DatabaseHandler dbHandler = DatabaseHandler();
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      Map<String,Object?> response = await dbHandler.userLogin(pref.getString('userId').toString(), easyLoginUserPwController.text.trim());
                      if(response['result'] == false){
                        print('간편 로그인 실패 ');
                        // firebaseLoginAction(userId, userPw);
                      }else {
                        print('간편 로그인 성공 ');
                        firebaseLoginAction(response['userId'].toString(), response['userPw'].toString());
                      }
                      return;
                    }
              
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
              
                    // await mySQL_login(userId, userPw);
                    // Firebase에 이메일과 비밀번호로 로그인
                    //await signInWithEmailAndPassword(userId, userPw);
          
                    firebaseLoginAction(userId, userPw);
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
            // SizedBox(height: 30,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     IconButton(
            //       onPressed: (){}, 
            //       icon:Image.asset("images/naver/btnW_.png",
            //     width: 100,), )
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  //Function

  mySQL_login(userId, UserPw) async {
    print("user id : $userId");
  }

  alreadyExistUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    String userId = prefs.get('userId') != null ? prefs.get('userId').toString() : "";
    String userPw = prefs.get('userPw') != null ? prefs.get('userPw').toString() : "";

    print('ID: $userId');
    print('PW: $userPw');
    if(userId != "" && userPw != "") {
      firebaseLoginAction(userId, userPw);
    }
  }

  firebaseLoginAction(String userId, String userPw) async {
    UserFirebase user = UserFirebase();
    final response = await user.checkUser(userId, userPw);

    if(response) {
      print('로그인 완료!');

      final prefs = await SharedPreferences.getInstance();
      // sharedPreferences를 전부 초기화 시키고, 로그인 한 id만 남긴다.
      prefs.clear();
      prefs.setString('userId', userId);
      
      Get.offAll(MainView());
    }
    else {  
      print('로그인 불가');
      Fluttertoast.showToast(
        msg: "아이디와 비밀번호를 확인해주세요.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        fontSize: 16.0,
      );
    }
  }
} //ENd

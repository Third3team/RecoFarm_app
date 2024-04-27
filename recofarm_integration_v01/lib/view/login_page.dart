import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:new_recofarm_app/view/mainview.dart';
import 'package:new_recofarm_app/vm/sqlite_handler.dart';
import 'package:new_recofarm_app/vm/user_firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

/* 
	Description : 
  Date : 2024.04.25 Thr 
	Author : Forrest DongGeun Park. (PDG) 
	Updates : 
    2024.04.25 Thr by pdg - 
	Detail : - 
*/

class LoginPage extends StatefulWidget {
  // ignore: use_super_parameters
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  TextEditingController userIdController = TextEditingController();
  TextEditingController userPwController = TextEditingController();
  // 간편비밀번호 TextField
  TextEditingController easyLoginUserPwController = TextEditingController();

  // 현재 어느 TabBar를 선택했는지에 대한 index
  late int _currentTabBarIndex;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 사용자 정보를 저장할 변수
  String? userEmail;
  String? userName;

  @override
  void initState() {
    super.initState();
    _currentTabBarIndex = 0;
    WidgetsBinding.instance.addObserver(this);
    // Page가 Build 될 때, 회원가입을 통해 바로 로그인 시도를 하는지 확인.
    alreadyExistUserInfo();
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
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      //   title: Text(
      //     '로그인',
      //     style: TextStyle(
      //         // fontSize: 50,
      //         color: Theme.of(context).colorScheme.onPrimaryContainer),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).colorScheme.onInverseSurface,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 100.0),
                  Image.asset(
                    "images/farmer.png",
                    height: 200,
                  ),
                  // 사용자 정보 출력
                  //if (userEmail != null) Text('이메일: $userEmail'),
                  //if (userName != null) Text('이름: $userName'),
                ],
              ),
            ),
            DefaultTabController(
              length: 2,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const SizedBox(
                      width: 300,
                      child: TabBar(tabs: [
                        Tab(
                          child: Text(
                            '일반 로그인',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Tab(
                          child: Text(
                            '간편 로그인',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ]),
                    ),
                    Builder(builder: (context) {
                      // TabBar의 선택 Index를 확인하기 위해서, addListener를 추가.
                      TabController tabController =
                          DefaultTabController.of(context);
                      tabController.addListener(() {
                        _currentTabBarIndex = tabController.index;
                      });
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: SizedBox(
                          width: 300,
                          height: 150,
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              // 일반 로그인 Form
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Expanded(
                                          flex: 1, child: Text("  아이디")),
                                      Expanded(
                                        flex: 3,
                                        child: TextFormField(
                                          style: const TextStyle(
                                            //fontSize: 25,
                                          ),
                                          decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
                                            isDense: true,
                                            hintText: "아이디를 입력하세요.",
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                            ),
                                          ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          controller: userIdController,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Expanded(
                                          flex: 1, child: Text("  비밀번호")),
                                      Expanded(
                                        flex: 3,
                                        child: TextFormField(
                                          style: const TextStyle(
                                            //fontSize: 25,
                                          ),
                                          decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 10.0),
                                            isDense: true,
                                            hintText: "비밀번호를 입력하세요.",
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                            ),
                                          ),
                                          keyboardType:
                                              TextInputType.visiblePassword,
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
                                  const SizedBox(height: 50),
                                  Row(
                                    children: [
                                      const Text(""),
                                      Expanded(
                                        flex: 3,
                                        child: TextFormField(
                                          style: const TextStyle(
                                            // fontSize: 25,
                                          ),
                                          decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 20.0,
                                                    horizontal: 20.0
                                                    ),
                                            isDense: true,
                                            hintText: "간편 비밀번호를 입력하세요.",
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
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
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  child: const Text(
                    '회원가입하기',
                    style: TextStyle(color: Color.fromARGB(255, 78, 101, 121)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  child: const Text(
                    '로그인하기',
                  ),
                  onPressed: () async {
                    // TabBar의 Index를 확인하여, 간편 비밀번호을 통한 로그인 시도로 판단한다.
                    if (_currentTabBarIndex == 1) {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();

                      // SQLite instance
                      DatabaseHandler dbHandler = DatabaseHandler();
                      // SharedPreferences를 통해 가지고 있던 userId와, 입력받은 간편 비밀번호를 이용.
                      // SQLite에서 유저 정보(userId, userPw)를 불러온다.
                      Map<String, Object?> response = await dbHandler.userLogin(
                          pref.getString('userId').toString(),
                          easyLoginUserPwController.text.trim());
                      // 정보가 존재하지 않으면 간편 로그인이 실패한 경우이다.
                      if (response['result'] == false) {
                        // 조기 return을 통한 함수 종료.
                        return;
                      }
                      // 간편로그인을 통해 SQLite에서 가지고 있던 유저 정보(userId, userPw)를 이용하여 Firebase Login 시도
                      firebaseLoginAction(response['userId'].toString(),
                          response['userPw'].toString());
                      // 조기 return을 통한 함수 종료. Firebase를 통한 로그인 성공
                      return;
                    }

                    // 간편로그인이 아닌, 일반적인 로그인 경우
                    String userId = userIdController.text.trim();
                    String userPw = userPwController.text.trim();

                    // ID 또는 PW를 입력하지 않았을 때,
                    if (userId.isEmpty || userPw.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "아이디와 비밀번호를 입력해 주세요.",
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        // fontSize: 16.0,
                      );
                      return;
                    }

                    // my SQL 로그인
                    // await mySQL_login(userId, userPw);
                    // Firebase에 이메일과 비밀번호로 로그인
                    //await signInWithEmailAndPassword(userId, userPw);

                    firebaseLoginAction(userId, userPw);
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     // 비밀번호찾기 페이지로 이동
                //     Get.toNamed('/findPw');
                //   },
                //   style: ElevatedButton.styleFrom(
                //       shape: const RoundedRectangleBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(15)))),
                //   child: const Text(
                //     '비밀번호찾기',
                //     style: TextStyle(color: Color.fromARGB(255, 65, 154, 9)),
                //   ),
                // ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // IconButton(
                //   onPressed: () {},
                //   icon: Image.asset(
                //     "images/naver/btnW_.png",
                //     width: 100,
                //   ),

                // ----------------------

                // 구글 로그인 버튼
                Row(
                  children: [
                    
                    IconButton(
                      onPressed: () async {
                        await signInWithGoogle();
                      },
                      
                      icon: Image.asset(
                        "images/ios_google.png",
                        width: 50,
                      ),
                    ),
                    const Text(" 구글 아이디로 로그인",
                      style: TextStyle(
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // initState에서 실행되는 함수.
  // ID와 PW의 값이 존재하면, 존재한 값을 통한 Firebase 로그인 시도
  // 회원가입 완료 후 바로 로그인 시도할때 사용됨.
  // 그 이외에 경우에는 사용되지 않는다.
  alreadyExistUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    // key값을 통해 가져온 값이 null이여도, toString()을 통해 'null'이 되어버린다.
    // null일 경우에 처리
    String userId =
        prefs.get('userId') != null ? prefs.get('userId').toString() : "";
    String userPw =
        prefs.get('userPw') != null ? prefs.get('userPw').toString() : "";

    // print('ID: $userId');
    // print('PW: $userPw');

    // 두 값이 전부 존재할때,
    if (userId != "" && userPw != "") {
      firebaseLoginAction(userId, userPw);
    }
  }

  // 로그인 종류에 상관없이 항상 Firebase를 통한 로그인 시도가 이루어짐.
  firebaseLoginAction(String userId, String userPw) async {
    // Firebase ViewModel
    UserFirebase user = UserFirebase();
    // 입력받은 userId와, userPw를 통해 Firebase에 값이 존재하는지 확인
    final response = await user.checkUser(userId, userPw);

    // Firebase에서 값을 제대로 불러오지 못했다면, 로그인 실패
    if (!response) {
      Fluttertoast.showToast(
        msg: "아이디와 비밀번호를 확인해주세요.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        fontSize: 16.0,
      );
      return;
    }

    // print("-------- Firebase Login Success --------");

    // Firebase에 값이 존재, 따라서 정상적인 로그인.
    final prefs = await SharedPreferences.getInstance();

    // 로그인 종류에 구애받지 않고 Firebase를 통한 Login 시도가 이루어지기에
    // 저장되어있는 값을 전부 삭제 후 ID 정보만 유지 시킨다.
    // ID 정보와 PW 정보가 존재하게 된다면, Login 시도 없이 접속 가능함. => 자동 로그인 기능임.
    // 라디오 버튼 하나만 만들어 자동로그인을 허락한다면, prefs.clear() 부분에 조건 설정
    prefs.clear();
    prefs.setString('userId', userId);

    // Login이 이루어지면 현재 존재하던 Page 전부를 없애고 이동.
    Get.offAll(const MainView());
  }

  Future<void> signInWithGoogle() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    ref.clear();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final User? user = userCredential.user;

        // 사용자 정보 업데이트
        setState(() {
          userEmail = user?.email;
          userName = user?.displayName;
        });

        // print("Google user: $user");

        // 페이지 이동
        Get.offAll(const MainView());
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Google 로그인에 실패했습니다.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        fontSize: 16.0,
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
  * Description : 회원 가입 페이지    
  * Date        : 2024.04.20
  * Author      : pdg 
  * Updates     : 
  *   2024.04.20 by pdg
        - 기존 회원가입페이지 정상화 
        - shared preference 로 아이디 패스워드 저장하여 mysql insert 에 넣기 . 

*/
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with WidgetsBindingObserver {
  late TextEditingController userIdController;
  late TextEditingController userPwController;
  late TextEditingController confirmPwController; // 비밀번호 재확인 필드 추가
  late TextEditingController userNameController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    userIdController = TextEditingController();
    userPwController = TextEditingController();
    confirmPwController = TextEditingController(); // 비밀번호 재확인 필드 초기화
    userNameController = TextEditingController();
    initSharedPreferences();
  }

  initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    userIdController.text = prefs.getString('p_userid') ?? "";
    userPwController.text = prefs.getString('p_userpw') ?? "";
    userNameController.text = prefs.getString('p_username') ?? "";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        disposeSharedPreferences();
        break;
      default:
        break;
    }
  }

  disposeSharedPreferences() async {
    // shared preference instance 생성 
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 가입'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: userIdController,
                decoration: InputDecoration(
                  labelText: 'ID 를 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: userPwController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호를 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: confirmPwController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호를 재확인', // 비밀번호 재확인 필드 라벨 추가
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: userNameController,
                decoration: InputDecoration(
                  labelText: '성명',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Text field 가 공백일경우
                  if (userIdController.text.isEmpty ||
                      userPwController.text.isEmpty ||
                      confirmPwController.text.isEmpty ||
                      userNameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('빈칸을 입력해주세요.')),
                    );
                  } 
                  // 비밀번호와 재확인 비밀번호가 다를 경우 
                  else if (userPwController.text !=
                      confirmPwController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
                    );
                  } else {
                    saveSharedPreferences();
                    //관심 농작물 페이지로 이동
                    //Get.to(const InterestProduct());
                  }
                },
                child: const Text('다음'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  saveSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userIdController.text);
    prefs.setString('userPw', userPwController.text);
    prefs.setString('userName', userNameController.text);
  }
}

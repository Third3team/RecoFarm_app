import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:new_recofarm_app/view/login_page.dart';
import 'package:new_recofarm_app/vm/user_firebase.dart';
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
  late TextEditingController userEmailController;
  late TextEditingController userPhoneController;
  late TextEditingController userNickNameController;

  late bool _isloading;
  late bool _readOnly;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    userIdController = TextEditingController();
    userPwController = TextEditingController();
    confirmPwController = TextEditingController(); // 비밀번호 재확인 필드 초기화
    userNameController = TextEditingController();
    userEmailController = TextEditingController();
    userPhoneController = TextEditingController();
    userNickNameController = TextEditingController();

    _isloading = false;
    _readOnly = false;
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 가입'),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: 280,
                        child: TextField(
                          controller: userIdController,
                          decoration: const InputDecoration(
                            labelText: 'ID 를 입력하세요',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: _readOnly,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _readOnly ? null : () async {
                    
                        UserFirebase userDB = UserFirebase();
                    
                        String userId = userIdController.text.trim();
                        final checkId = await userDB.alreadyCheckUserId(userId);
          
                        // ID가 중복되었을때, 
                        if(checkId) {
                          messageDialog('중복된 ID 입니다!');
                          return;
                        }
          
                        messageDialog('사용가능한 ID 입니다.');
                        _readOnly = true;
                        setState(() {});
                      },
                      child: const Text('중복확인'),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: userPwController,
                    obscureText: true,
                    decoration: const InputDecoration(
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
                    decoration: const InputDecoration(
                      labelText: '비밀번호를 재확인', // 비밀번호 재확인 필드 라벨 추가
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: userNameController,
                    decoration: const InputDecoration(
                      labelText: '성명',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: userNickNameController,
                    decoration: const InputDecoration(
                      labelText: '별명',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: userEmailController,
                    decoration: const InputDecoration(
                      labelText: '이메일',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: userPhoneController,
                    decoration: const InputDecoration(
                      labelText: '핸드폰 번호를 입력해주세요',
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
                        registerAction();
                      }
                    },
                    child: const Text('다음'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // login Action
  registerAction() async {

    _isloading = true;

    UserFirebase userDB = UserFirebase();

    final userId = userIdController.text.trim();
    final userPw = userPwController.text.trim();
    final userName = userNameController.text.trim();
    final userEmail = userEmailController.text.trim();
    final userPhone = userPhoneController.text.trim();
    final userNickName = userNickNameController.text.trim();

    await userDB.firebaseUserInsertAction(userId, userPw, userName, userEmail, userPhone, userNickName);

    setState(() {
      _isloading = false;
    });

    if(!_isloading) {
      nextDialog();
    }
  }

  saveSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userIdController.text);
    prefs.setString('userPw', userPwController.text);
  }

  nextDialog() {
    Get.defaultDialog(
      title: '알림',
      middleText: '회원가입 완료! 바로 로그인 하시겠습니까?',
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('취소')
        ),
        ElevatedButton(
          onPressed: () {
            // 바로 로그인 하게되면, 정보를 저장하고 다음 페이지에서 정보를 받아와서 로그인한다.
            saveSharedPreferences();
            // 넘길 page
            Get.off(const LoginPage());
          },
          child: const Text('확인')
        )
      ]
    );
  }

  messageDialog(String messageText) {
    Get.defaultDialog(
      title: '알림',
      middleText: messageText,
      actions: [
        ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text('확인')
        )
      ]
    );
  }


}

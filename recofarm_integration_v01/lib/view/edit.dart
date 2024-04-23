import 'package:flutter/material.dart';
import 'package:new_recofarm_app/vm/user_firebase.dart';
import 'package:get/get.dart';

class edit extends StatelessWidget {
  final String userId;
  final String userEmail;
  final String userPw;
  final String userName;
  final String userNickName;
  final String userPhone;

  edit({
    Key? key,
    required this.userId,
    required this.userEmail,
    required this.userPw,
    required this.userName,
    required this.userNickName,
    required this.userPhone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController =
        TextEditingController(text: userEmail);
    TextEditingController idController = TextEditingController(text: userId);
    TextEditingController pwController = TextEditingController(text: userPw);
    TextEditingController nameController =
        TextEditingController(text: userName);
    TextEditingController nicknameController =
        TextEditingController(text: userNickName);
    TextEditingController phoneController =
        TextEditingController(text: userPhone);

    return Scaffold(
      appBar: AppBar(title: Text('회원정보 수정')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: '이메일')),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: idController,
                      decoration: InputDecoration(labelText: '아이디'),
                      readOnly: true)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: pwController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: '비밀번호')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: nicknameController,
                    decoration: InputDecoration(labelText: '닉네임')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: '전화번호')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: '이름')),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      pwController.text.isEmpty ||
                      nicknameController.text.isEmpty ||
                      phoneController.text.isEmpty ||
                      nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('빈칸을 입력해주세요.')));
                    return;
                  }
                  try {
                    await UserFirebase().firebaseUserUpdateAction(
                        userId,
                        pwController.text,
                        nameController.text,
                        emailController.text,
                        phoneController.text,
                        nicknameController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('회원 정보가 업데이트되었습니다.')));
                    await Future.delayed(Duration(seconds: 2));
                    Get.back();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('회원 정보 업데이트에 실패했습니다.')));
                  }
                },
                child: Text('수정 완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

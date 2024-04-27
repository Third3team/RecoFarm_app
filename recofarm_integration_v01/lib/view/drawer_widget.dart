import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_recofarm_app/view/edit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:new_recofarm_app/view/login_page.dart';
import 'package:new_recofarm_app/view/predict_yield.dart';
import 'package:new_recofarm_app/view/web_view_page.dart';
import 'package:new_recofarm_app/vm/user_firebase.dart';

/*
  Description : Drawer widget
  Date        : 2024.04.27 Sat
  Author      : Forrest DongGeun Park. (PDG)
  Updates     : 
	  2024.04.27 Thr by pdg
		  - 사용자가 글꼴을 바꿀수 있게끔 설정
      - 
  Detail      : - 

*/
class DrawerWidget extends StatelessWidget {
  // 사용자 아이디를 constructor 로 받음.
  DrawerWidget({Key? key, required this.userId});

  final userId;

  //사용자 이름과 이메일 
  String? userName;
  String? userEmail;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder<QuerySnapshot>(
        stream: UserFirebase().selectUserEqaulID(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return  Column(
              // 데이터가 없을 때 처리 -> circular progress indicator 
              children: 
              
                [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text('데이터가 없습니다.'),
                  ]
              
            );
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            userName = snapshot.data!.docs[0]['userName'] ??
                FirebaseAuth.instance.currentUser?.displayName;
            userEmail = snapshot.data!.docs[0]['userId'] ??
                FirebaseAuth.instance.currentUser?.email;
          } else {
            // 데이터가 없을 경우의 기본값 설정
            userName = FirebaseAuth.instance.currentUser?.displayName;
            userEmail = FirebaseAuth.instance.currentUser?.email;
          }
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                ),
                accountName: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 30, 0, 0),
                  child: Text(
                    '${userName ?? '사용자 이름'}님,'
                    ,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                accountEmail: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    userEmail ?? '사용자 Email',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty)
                ListTile(
                  leading: const Icon(
                    Icons.edit,
                    color: Colors.red,
                  ),
                  title: const Text('회원정보 수정'),
                  onTap: () {
                    Get.to(
                      edit(
                        userId: snapshot.data!.docs[0]['userId'],
                        userEmail: snapshot.data!.docs[0]['userEmail'],
                        userPw: snapshot.data!.docs[0]['userPw'],
                        userName: snapshot.data!.docs[0]['userName'],
                        userNickName: snapshot.data!.docs[0]['userNickName'],
                        userPhone: snapshot.data!.docs[0]['userPhone'],
                      ),
                    );
                  },
                ),
              ListTile(
                leading: const Icon(
                  // Icons.area_chart,
                  // Icons.multiline_chart,
                  Icons.bar_chart,
                  color: Colors.cyan,
                ),
                title: const Text('수확량 예측'),
                onTap: () => {Get.to(PredictYield())},
              ),
              ListTile(
                leading: const Icon(
                  Icons.question_answer,
                  color: Colors.orange,
                ),
                title: const Text('농넷 바로가기'),
                onTap: () {
                  Get.to(WebViewPage());
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
                title: const Text('설정'),
                onTap: () => {print('home')},
              ),
              ListTile(
                leading: const Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
                title: const Text('로그아웃'),
                onTap: () async {
                  // SharedPreferences preferences = await SharedPreferences.getInstance();
                  // preferences.clear();
                  Fluttertoast.showToast(
                    msg: "로그아웃 되었습니다.",
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    fontSize: 20.0,
                  );
                  Get.offAll(const LoginPage());
                },
              )
            ], // children
          );
        },
      ),
    );
  }
}

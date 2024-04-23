import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:new_recofarm_app/view/edit.dart';
import 'package:new_recofarm_app/vm/user_firebase.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({Key? key, required this.userId});

  final userId;
  String? userName;
  String? userEmail;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder<QuerySnapshot>(
        stream: UserFirebase().selectUserEqaulID(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('데이터가 없습니다.'),
            );
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            userName = snapshot.data!.docs[0]['userName'] ??
                FirebaseAuth.instance.currentUser?.displayName;
            userEmail = snapshot.data!.docs[0]['userEmail'] ??
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
                  backgroundColor: Colors.amber,
                ),
                accountName: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 30, 0, 0),
                  child: Text(
                    '${userName ?? '사용자 이름'}님',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                accountEmail: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    userEmail ?? '사용자 이름',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.red,
                ),
                title: const Text('Home'),
                onTap: () => {print('home')},
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.red,
                ),
                title: const Text('예측'),
                onTap: () => {print('')},
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
                title: Text('설정'),
                onTap: () => {print('home')},
              ),
              ListTile(
                leading: const Icon(
                  Icons.question_answer,
                  color: Colors.orange,
                ),
                title: Text('공지사항'),
                onTap: () => {print('home')},
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
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
                title: Text('로그아웃'),
                onTap: () => {print('home')},
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

/*
  Description : Firebase를 통해 유저 정보를 insert & select
  Date        : 2024.04.25 Thr
  Author      : LCY 
  Updates     : 
	  2024.04.25 Thr by lcy
		  -  code review :: 주석 
  Detail      : - 
*/

class UserFirebase {

  // Login 후 메인 화면에 들어왔을 때, 원하는 userId의 정보들을 불러와 사용자에게 보여주기 위함.
  Stream<QuerySnapshot<Map<String, dynamic>>> selectUserEqaulID(String userId) {
    return FirebaseFirestore.instance.collection('user')
        .where('userId', isEqualTo: userId).snapshots();
  }

  // 회원가입 시 ID 중복 확인 
  Future<bool> alreadyCheckUserId(String userId) async {
    // 회원가입 하려는 userId를 입력 받아 그와 같은 ID가 있는지 확인,
    // 정보가 있는지 없는지만 확인
    bool response = false;
    await FirebaseFirestore.instance
        .collection('user')
        // userId 정보 확인
        .where('userid', isEqualTo: userId)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> userInfo) {
      if (userInfo.docs.isNotEmpty) {
        // 정보가 있음
        response = true;
      } else {
        // 정보가 없음
        response = false;
      }
    });

    return response;
  }

  // Login 시도할때, 사용자가 입력한 userId와 userPw가 Firebase에 저장된 정보와 맞는지 확인
  Future<bool> checkUser(String userId, String userPw) async {
    bool response = false;
    // Firebase 확인
    await FirebaseFirestore.instance
        .collection('user')
        // userId 정보 확인
        .where('userId', isEqualTo: userId)
        // userPw 정보 확인
        .where('userPw', isEqualTo: userPw)
        // snapshots은 변경사항을 계속가져옴, 한번만 가져올 것이라면 get을 사용해도 무방함
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> userInfo) {
      if (userInfo.docs.isNotEmpty) {
        // 정보가 있음
        response = true;
      } else {
        // 정보가 없음
        response = false;
      }
    });

    return response;
  }

  // 회원가입, 사용자가 입력한 값들을 Firebase에 저장
  firebaseUserInsertAction(String userId, String userPw, String userName, String userEmail, String userPhone, String userNickName) async {

    /*

    ****** 사용자가 입력한 정보 *******
      userId       : 사용자 아이디
      userPw       : 사용자 비밀번호
      userName     : 사용자 이름
      userEmail    : 사용자 전자우편
      userPhone    : 사용자 전화번호
      userNickName : 사용자 별명

    */

    await FirebaseFirestore.instance.collection('user').add({
      'userId': userId,
      'userPw': userPw,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'userNickName': userNickName,
      // 날짜 정보
      'create_date': DateTime.now(),
      'modify_date': DateTime.now(),
    });
  }

  // 사용자 정보 변경
  firebaseUserUpdateAction(String userId, String userPw, String userName,
      String userEmail, String userPhone, String userNickName) async {

    // 해당 userId를 가진 문서를 찾기 위한 쿼리 생성
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('user').where('userId', isEqualTo: userId).get();

    // 쿼리 결과에서 문서 가져오기
    QueryDocumentSnapshot documentSnapshot = querySnapshot.docs.first;

    // 해당 문서 업데이트
    await FirebaseFirestore.instance.collection('user').doc(documentSnapshot.id).update({
      'userPw': userPw,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'userNickName': userNickName,
      'modify_date': DateTime.now(),
    });
  }
}

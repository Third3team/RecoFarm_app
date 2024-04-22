import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebase {

  Stream<QuerySnapshot<Map<String, dynamic>>> selectUserEqaulID(String userId) {
    print('db userId Query : $userId');
    return FirebaseFirestore.instance.collection('user').where('userId', isEqualTo: userId).snapshots();
  }

  Future<bool> alreadyCheckUserId(String userId) async {
    bool response = false;
    await FirebaseFirestore.instance.collection('user')
    // userId 정보 확인
    .where('userid', isEqualTo: userId)
    .get()
    .then((QuerySnapshot<Map<String, dynamic>> userInfo) {
      if (userInfo.docs.isNotEmpty) {
        print('정보있음!!');
        // 정보가 있음
        response = true;
      } else {
        print('정보없음!!-----------------');
        // 정보가 없음
        response = false;
      }
    });

    return response;
  }

  Future<bool> checkUser(String userId, String userPw) async {
    
    bool response = false;
    // Firebase 확인
    await FirebaseFirestore.instance.collection('user')
    // userId 정보 확인
    .where('userId', isEqualTo: userId)
    // userPw 정보 확인
    .where('userPw', isEqualTo: userPw)
    // snapshots은 변경사항을 계속가져옴, 한번만 가져올 것이라면 get을 사용해도 무방함
    .get()
    .then((QuerySnapshot<Map<String, dynamic>> userInfo) {
      if (userInfo.docs.isNotEmpty) {
        print('정보있음!!');
        // 정보가 있음
        response = true;
      } else {
        print('정보없음!!-----------------');
        // 정보가 없음
        response = false;
      }
    });

    return response;
  }

  firebaseUserInsertAction(String userId, String userPw, String userName, String userEmail, String userPhone, String userNickName) async {

    // userId, 
    // userPw, 
    // userName, 
    // userEmail, 
    // userPhone, 
    // userNickName

    await FirebaseFirestore.instance.collection('user').add(
      {
        'userId' : userId,
        'userPw' : userPw,
        'userName' : userName,
        'userEmail' : userEmail,
        'userPhone' : userPhone,
        'userNickName' : userNickName,
        'create_date' : DateTime.now(),
        'modify_date' : DateTime.now(),
      }
    );
  }


}
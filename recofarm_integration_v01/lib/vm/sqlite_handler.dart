import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/*
  Description : 간편 비밀번호를 통한 Login
  Date        : 2024.04.19
  Author      : LCY 
  Updates     : 
	  2024.04.25 Thr by lcy
		  -  code review :: 주석 
  Detail      : - 
*/

class DatabaseHandler {

  // SQLite Table 생성
  Future<Database> initalizeDB() async {
    // db 저장경로
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'newuser.db'),
      onCreate: (db, version) async {
        await db.execute(
          // 테이블명
          'CREATE TABLE userinfo '
          // seq
          '(seq integer primary key autoincrement,'
          // 사용자 ID
          'userId text(50),'
          // 사용자 비밀번호
          'userPw text(50),'
          // 사용자 간편비밀번호
          'easyPw text(6))'
        );
      },
      version: 1,
    );
  }

  // 간편 로그인을 시도하였을 때, 입력한 정보가 맞는지 확인
  Future<Map<String, Object?>> userLogin(String userId, String easyPw) async {
    final Database db = await initalizeDB();

    // select
    final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM userinfo where userId="$userId" and easyPw="$easyPw"');

    // 불러온 정보가 없을때, 로그인 실패
    if(result.isEmpty) {
      return Future(() => {'result' : false});
    }
    
    // List 형태로 query를 불러왔지만, 있거나 없거나 둘 중 하나의 경우 밖에 없음.
    // 따라서 정보가 있다면, 가장 첫번째 List에 존재함.
    final response = result[0];

    // if(response.isEmpty) {
    //   print('비어있음 ');
    //   return Future(() => {'result' : false});
    // }
    // else {
    //   print('존재함');
    //   print('id : ${response['userId']}');
    //   print('pw : ${response['userPw']}');
    //   print('pw : ${response['easyPw']}');
    // }
    // print('간편로그인 query 4');
    return response;
  }

  // 회원가입 시 간편로그인 설정
  Future<void> insertUserInfo(String userId, String userPw, String easyPw) async {
    final Database db = await initalizeDB();
    await db.rawInsert(
      'INSERT INTO userinfo '
      '(userId,userPw,easyPw) '
      'VALUES (?,?,?)',
      [userId, userPw, easyPw]
    );
  }

}
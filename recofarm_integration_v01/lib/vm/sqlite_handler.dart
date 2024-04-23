import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
/* 
    Description : local db viewmodel
    Author 		: Lcy
    Date 			: 2024.04.19
*/

class DatabaseHandler {

  Future<Database> initalizeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'newuser.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE userinfo '
          '(seq integer primary key autoincrement,'
          'userId text(50),'
          'userPw text(50),'
          'easyPw text(6))'
        );
      },
      version: 1,
    );
  }

  Future<Map<String, Object?>> userLogin(String userId, String easyPw) async {
    final Database db = await initalizeDB();
    final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM userinfo where userId=$userId and easyPw=$easyPw');
    print(userId);
    print(easyPw);
    print('간편로그인 query 1');
    if(result.isEmpty) {
      return Future(() => {'result' : false});
    }
    print('간편로그인 query 2');
    final response = result[0];
    print('간편로그인 query 3');
    if(response.isEmpty) {
      print('비어있음 ');
      return Future(() => {'result' : false});
    }
    else {
      print('존재함');
      print('id : ${response['userId']}');
      print('pw : ${response['userPw']}');
      print('pw : ${response['easyPw']}');
    }
    print('간편로그인 query 4');
    return response;
  }

  Future<void> insertUserInfo(String userId, String userPw, String easyPw) async {
    final Database db = await initalizeDB();
    await db.rawInsert(
      'INSERT INTO userinfo '
      '(userId,userPw,easyPw) '
      'VALUES (?,?,?)',
      [userId, userPw, easyPw]
    );
  }

  // Future<int> updateReview(Review review) async {
  //   final Database db = await initalizeDB();
  //   int result;
  //   result = await db.rawInsert(
  //     'UPDATE musteatplace SET '
  //     'name=?, phone=?, lat=?, long=?, image=?, estimate=? '
  //     'WHERE seq=?',
  //     [review.name, review.phone, review.lat, review.long, review.image, review.estimate, review.seq]
  //   );
  //   return result;
  // }

  // Future<void> deleteReview(int? seq) async {
  //   final Database db = await initalizeDB();
  //   await db.rawDelete(
  //     'DELETE FROM musteatplace '
  //     'WHERE seq = ?',
  //     [seq]
  //   );
  // }

}
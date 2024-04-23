import 'package:new_recofarm_app/model/interesting_area_model.dart';
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
      join(path, 'user.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE userinfo '
          '(seq integer primary key autoincrement,'
          'userId text(50),'
          'easyPw text(6))'
        );
      },
      version: 1,
    );
  }

  // Future<List<Area>> queryReview() async {
  //   final Database db = await initalizeDB();
  //   final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM place');

  //   return result.map((e) => Area.fromMap(e)).toList();
  // }

  Future<void> insertUserInfo(String userId, String easyPw) async {
    final Database db = await initalizeDB();
    await db.rawInsert(
      'INSERT INTO userinfo '
      '(userId,easyPw) '
      'VALUES (?,?)',
      [userId, easyPw]
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
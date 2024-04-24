import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_recofarm_app/model/user_area.dart';

class UserMySQL extends GetxController {

  Future<List<UserArea>> areaList = Future(() => []);

    int count = 0;

  getAreaData(String userId) async {
    count = 0;
    // areaList.clear();
    areaList.then((list) {
    list.clear(); // 리스트 비우기
   });

    // Forrest IP : 192.168.50.69
    var url = Uri.parse('http://192.168.50.69:8080/myarea?userId=$userId');
    var response = await http.readBytes(url);
    var result = json.decode(utf8.decode(response));

    for(var items in result) {

      int areaCode = items['area_code'];
      double areaLat = items['area_lat'];
      double areaLng = items['area_lng'];
      double areaSize = items['area_size'];
      String areaProduct = items['area_product'];
      String areaAddress = items['area_address'];

      UserArea userArea = UserArea(area_code: areaCode, userId: userId, area_lat: areaLat, area_lng: areaLng, area_size: areaSize, area_product: areaProduct, area_address: areaAddress);

      // areaList.add(userArea);
      areaList.then((list) {
        list.add(userArea); // 리스트 비우기
      });
      
    }
    
    if(count < 10) {
    update();
    }

    // return areaList;

  }



}
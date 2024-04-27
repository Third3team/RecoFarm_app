import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_recofarm_app/model/user_area.dart';

/*
  Description : mySql에 저장되어 있는 유저 관심지역을 불러오는 VM
  Date        : 2024.04.25 Thr
  Author      : LCY 
  Updates     : 
	  2024.04.25 Thr by lcy
		  - code 주석
*/

class UserMySQL extends GetxController {

  // 관심 지역 List
  Future<List<UserArea>> areaList = Future(() => []);

    int count = 0;

  getAreaData(String userId) async {
    count = 0;

    areaList.then((list) {
    list.clear(); // 리스트 비우기
   });

    // Forrest IP : 192.168.50.69
    var url = Uri.parse('http://192.168.50.69:8080/myarea?userId=$userId');
    var response = await http.readBytes(url);
    var result = json.decode(utf8.decode(response));

    for(var items in result) {
      // 관심 지역 seq
      int areaCode = items['area_code'];
      // 관심 지역 위도
      double areaLat = items['area_lat'];
      // 관심 지역 경도
      double areaLng = items['area_lng'];
      // 관심 지역 면적
      double areaSize = items['area_size'];
      // 관심 지역의 농작물
      String areaProduct = items['area_product'];
      // 관심 지역 주소명
      String areaAddress = items['area_address'];

      // 관심 지역 Model에 저장하여 List 형태로 return 하기 위함
      UserArea userArea = UserArea(area_code: areaCode, userId: userId, area_lat: areaLat, area_lng: areaLng, area_size: areaSize, area_product: areaProduct, area_address: areaAddress);

      areaList.then((list) {
        list.add(userArea); // 리스트 비우기
      });
      
    }
    
    if(count < 10) {
      update();
    }

  }



}
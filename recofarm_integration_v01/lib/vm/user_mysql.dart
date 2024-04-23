import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_recofarm_app/model/user_area.dart';

class UserMySQL {

  List<UserArea> areaList = [];


  Future<List<UserArea>> getAreaData(String userId) async {
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

      areaList.add(userArea);
    }

    // print(areaList.length);

    return areaList;

  }



}
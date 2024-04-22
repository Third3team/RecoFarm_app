import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class VMpredict extends GetxController{

  bool? unitGroupValue = true;
  bool? groupValue = true;

  bool searchAreaValue = false;
  bool selecteAreaValue = true;

  String buttonText = '지역 선택';
  String selectAreaPlaceName = '';

  int selectValue = 0;

  double? latData;
  double? lngData;

  List<String> placeList = [
    '경기도 용인시 처인구',
    '대전광역시 유성구',
    '충청북도 괴산군',
    '충청북도 충주시',
    '충청북도 진천군',
    '전라북도 정읍시',
    '전라북도 부안군',
    '전라남도 강진군',
    '전라남도 진도군',
    '전라남도 해남군',
    '경상북도 포항시 북구',
    '경상북도 영덕군',
    '경상북도 영양군',
    '경상남도 김해시',
    '경상남도 통영시',
  ];

  List<Map> placeListLocation = [
    { 'lat' : 37.23431, 'lng' : 127.2014,}, // '경기도 용인시 처인구',
    { 'lat' : 36.36229, 'lng' : 127.3563,}, // '대전광역시 유성구',
    { 'lat' : 36.81536, 'lng' : 127.7867,}, //  '충청북도 괴산군',
    { 'lat' : 36.99105, 'lng' : 127.9260,}, // '충청북도 충주시',
    { 'lat' : 36.85538, 'lng' : 127.4355,}, // '충청북도 진천군',
    { 'lat' : 35.56985, 'lng' : 126.8560,}, // '전라북도 정읍시',
    { 'lat' : 35.73166, 'lng' : 126.7330,}, //  '전라북도 부안군',
    { 'lat' : 34.64206, 'lng' : 126.7672,}, //  '전라남도 강진군',
    { 'lat' : 34.48683, 'lng' : 126.2634,}, // '전라남도 진도군',
    { 'lat' : 34.57352, 'lng' : 126.5993,}, //  '전라남도 해남군',
    { 'lat' : 36.04374, 'lng' : 129.3686,}, //  '경상북도 포항시 북구',
    { 'lat' : 36.41506, 'lng' : 129.3653,}, // '경상북도 영덕군',
    { 'lat' : 36.66670, 'lng' : 129.1125,}, // '경상북도 영양군',
    { 'lat' : 35.22857, 'lng' : 128.8894,}, // '경상남도 김해시',
    { 'lat' : 34.85444, 'lng' : 128.4331,}, //  '경상남도 통영시',
  ];

  selectUnitRadio(bool? value) {
    unitGroupValue = value;
    update();
  }

  selectRadio(bool? value) {
    groupValue = value;
    buttonText = !groupValue! ? '검색' : '지역 선택';
    update();
  }


  placeSearchAction(context) {
    if(groupValue!) {
      placeSelecteActionSheet(context);
    }
  }

  placeSelecteActionSheet(context) {
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoActionSheet(
        actions: [
          SizedBox(
            height: 200,
            child: CupertinoPicker(
              itemExtent: 50,
              scrollController: FixedExtentScrollController(initialItem: selectValue),
              onSelectedItemChanged: (value) {
                selectValue = value;
                selectAreaPlaceName = placeList[value];
                latData = placeListLocation[value]['lat'];
                lngData = placeListLocation[value]['lng'];
                update();
              },
              children: List.generate(10, (index) {
                return Center(
                  child: Text(
                    '${placeList[index]}',
                    style: const TextStyle(
                      fontSize: 28
                    ),
                  )
                );
              } 
             )
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
            onPressed: () => Get.back(),
            child: const Text('확인')
          ),
      )
    );
  }



}
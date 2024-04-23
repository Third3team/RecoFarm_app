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
    { 'lat' : 37.2343060386837, 'lng' : 127.201357139725,}, // '경기도 용인시 처인구',
    { 'lat' : 36.3622851114392, 'lng' : 127.356257593324,}, // '대전광역시 유성구',
    { 'lat' : 36.8153571576607, 'lng' : 127.786652163107,}, //  '충청북도 괴산군',
    { 'lat' : 36.9910490160221, 'lng' : 127.925961035784,}, // '충청북도 충주시',
    { 'lat' : 36.855378991826, 'lng' : 127.435536085976,}, // '충청북도 진천군',
    { 'lat' : 35.5698491739949, 'lng' : 126.8560,}, // '전라북도 정읍시',
    { 'lat' : 35.7316577924649, 'lng' : 126.7330,}, //  '전라북도 부안군',
    { 'lat' : 34.6420615268858, 'lng' : 126.7672,}, //  '전라남도 강진군',
    { 'lat' : 34.486828620348, 'lng' : 126.2634,}, // '전라남도 진도군',
    { 'lat' : 34.5735165884839, 'lng' : 126.5993,}, //  '전라남도 해남군',
    { 'lat' : 36.0437417308541, 'lng' : 129.3686,}, //  '경상북도 포항시 북구',
    { 'lat' : 36.4150618798074, 'lng' : 129.3653,}, // '경상북도 영덕군',
    { 'lat' : 36.6667028574142, 'lng' : 129.1125,}, // '경상북도 영양군',
    { 'lat' : 35.2285653558628, 'lng' : 128.8894,}, // '경상남도 김해시',
    { 'lat' : 34.8544448244005, 'lng' : 128.4331,}, //  '경상남도 통영시',
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
              children: List.generate(placeList.length, (index) {
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
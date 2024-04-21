import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/*
  Description : Google map 나의 관심 소재지 등록하기 페이지 
  Date        : 2024.04.21 Sun
  Author      : Forrest DongGeun Park. (PDG)
  Updates     : 
	  2024.04.21 Sun by pdg
		  - google map 추가 및 ios minimum version 14 로 변환 
      - footter 디자인 + 내 관심 경작지로 이동하기 ( 우선 엘리베이트 버튼으로 구현 )
      - 내위치 권한 인증 및 내위치로 첫 지도 카메라 위치 이동 시키기 
      - 위치 권한이 없을 경우 앱을 사용하지 못하는 쪽으로 설계를 하자. 
      - 특정 위치 마커 그리기 
  Detail      : - 

*/
class InterestingAreaPage extends StatefulWidget {
  const InterestingAreaPage({super.key});

  @override
  State<InterestingAreaPage> createState() => _InterestingAreaPageState();
}

class _InterestingAreaPageState extends State<InterestingAreaPage> {
  // properties
  late TextEditingController locationTfController;
  late LatLng interestLoc;
  late bool islocationEnable;
  late Marker myloc1 ;
  late Circle myAreaCircle ;
  late double myAreaMeterSquare;
  late double myAreaRadius;

  @override
  void initState() {
    super.initState();
    locationTfController = TextEditingController();
    // 초기 관심 지역 위도 경도 설정
    interestLoc = const LatLng(37.5233273, 126.921252);
    //print(interestLoc);
    // 경작지 위치  마커 
    myloc1 = Marker(
      markerId: MarkerId("경작지1"),
      position: interestLoc
    );
    myAreaMeterSquare =10000; // 100 m^2 -> 3.14 * r^2 =100 -> 
    myAreaRadius = sqrt(myAreaMeterSquare/3.14);
    // 경작지 반경
    myAreaCircle =Circle(
      circleId: CircleId('myloc1'),
      center: interestLoc,
      fillColor: Colors.blue.withOpacity(0.4),
      radius:myAreaRadius,
      strokeColor: Colors.blue,
      strokeWidth: 1,
      );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[100],
        actions: [
          IconButton(
              onPressed: () {
                // 소재지 검색 함수
              },
              icon: Icon(Icons.search_outlined))
        ],
        title: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 100,
            child: TextField(
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                  // alignLabelWithHint: true,
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  labelText: "소재지 주소 검색",
                  labelStyle: TextStyle(color: Colors.green[300])),
              controller: locationTfController,
            ),
          ),
        ),
      ),

      // check permission 함수는 future 함수이므로 future builder 를 사용하는 것이 좋다.
      body: FutureBuilder<String>(
        future: checkPermission(),
        builder: (context, snapshot) {
          // 권한 정보가 스냅샷에 없을때  혹은 커넥션을 기다리고 있을때
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == "위치 권한이 허가 되었습니다.") {
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(
                          target: interestLoc,
                         zoom: 16,
                         ),
                         markers: Set.from([myloc1]),
                         circles: Set.from([myAreaCircle]),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("내 관심 경작지 리스트(combo box)"),
                      ElevatedButton(
                          onPressed: () {
                            // google map 이동
                          },
                          child: const Text("경작지1"))
                    ],
                  ),
                ),
              ],
            );
          } // If end
          // 권한 설정이 안되어있을 때
          return Center(
            child: Text(
              snapshot.data.toString(),
            ),
          );
        },
      ),
    );
  }

  // Function
  location_find() async {
    final checkedPermission = await Geolocator.checkPermission();
  }

  // 내위치  파악 및 권한 설정 함수
  Future<String> checkPermission() async {
    islocationEnable = await Geolocator.isLocationServiceEnabled();

    if (!islocationEnable) {
      return "위치 서비스를 활성화 해주세요.";
    }
    // 위치 권한 확인
    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      // 권한 요청
      checkedPermission = await Geolocator.requestPermission();
      if (checkedPermission == LocationPermission.denied) {
        return "위치 권한을 허가해주세요";
      }
    }
    // 위치 권한 거절됨 ( 앱에서 재요청 불가 )
    if (checkedPermission == LocationPermission.deniedForever) {
      return "앱의 위치 권한을 설정에서 허가해주세요.";
    }

    // 위의 모든 조건이 통과되면 위치 권한 허가 가 완료 된것임.
    return "위치 권한이 허가 되었습니다.";
  }
} // END

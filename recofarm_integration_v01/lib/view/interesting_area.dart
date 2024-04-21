import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/*
  Description : Google map 나의 관심 소재지 등록하기 페이지 
  Date        : 2024.04.21 Sun
  Author      : Forrest DongGeun Park. (PDG)
  Updates     : 
	  2024.04.21 Sun by pdg
		  - 
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

  @override
  void initState() {
    super.initState();
    locationTfController = TextEditingController();
    // 초기 관심 지역 위도 경도 설정 
    interestLoc = const LatLng(
      37.5233273,
      126.921252
    );
    print(interestLoc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[100],
        actions: [
          IconButton(
            onPressed: (){
              // 소재지 검색 함수 
            }, 
            icon: Icon(Icons.search_outlined))
        ],
        title: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 50,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  labelText: "농작할 소재지 주소를 입력해주세요.",
                  labelStyle: TextStyle(color: Colors.green[300])),
              controller: locationTfController,
            ),
          ),
        ),
      ),
      body:  GoogleMap(
        initialCameraPosition: CameraPosition(
          target: interestLoc,
          zoom: 16),
        
        ),
    );
  }

  // Function
  location_find() async {
    final checkedPermission = await Geolocator.checkPermission();
  }
} // END

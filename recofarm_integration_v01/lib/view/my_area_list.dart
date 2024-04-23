import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/*
  Description :  내경작지 리스트 
  Date        : 2024.04.22 Mon
  Author      : Forrest DongGeun Park. (PDG)
  Updates     : 
	  2024.04.22 Mon by pdg
		  - 내경작지를 Json 으로 받아오는것 실험 .
  Detail      : - 

*/
class MyAreaList extends StatefulWidget {
  //final GestureTapCallback getBackPress;
  const MyAreaList({
    super.key,
    //required this.getBackPress
    });

  @override
  State<MyAreaList> createState() => _MyAreaListState();
}

class _MyAreaListState extends State<MyAreaList> {
  //properties
  late List data;
  late int value;
  late String title;
  late String userId ;
  // Sared preference instance 
  late SharedPreferences prefs; 


  @override
  void initState() {
    super.initState();

  // user 정보 shared preference 에서 받기
  _getUserIdFromSharedPref();

    value = 0;
    title = "내 경작지 리스트";
    //userId = "";
    data = [];

    get_myarea_JSONData(userId);
  }

 
  @override
  Widget build(BuildContext context) {
    return 
       Center(
        child: data.isEmpty
            ? const CircularProgressIndicator()
            : 
                ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        startActionPane:
                            ActionPane(motion: const BehindMotion(), children: [
                          SlidableAction(
                            backgroundColor: Colors.blueAccent,
                            icon: Icons.edit,
                            label: "Edit",
                            onPressed: (context) {
                              //
                              // Get.to(
                              //   const Edit(),
                              //   arguments: [
                              //     data[index]['image'],data[index]['title']
                              //   ]
                              //   )!.then((value) => _rebuildData(index,value)); // value = result
                            },
                          ),
                        ]),
                        endActionPane:
                            ActionPane(motion: StretchMotion(), children: [
                          SlidableAction(
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            label: "삭제",
                            onPressed: (context) => _selectDelete(index)
                            
                          ),
                          // SlidableAction(
                          //   backgroundColor: Colors.red,
                          //   icon: Icons.delete,
                          //   label: "삭제",
                          //   onPressed: (context) {
                          //     //
                          //   },
                          // )
                        ]),
                        child: Card(
                          color: index % 2 == 0
                              ? Theme.of(context).colorScheme.secondaryContainer
                              : Theme.of(context).colorScheme.tertiaryContainer,
                          child: Row(
                            children: [
                
                              Text(
                                " ${index+1}.  ${data[index]['area_address']}(${data[index]['area_product']})",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
            );
    
  }
  
  
  // --- Functions ---
  _getUserIdFromSharedPref() async{
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? ""; // 기본값은 빈 문자열


  }


   // MySQl data 가져오기 
  get_myarea_JSONData(userId) async {
    // Desc : 내관심 소재지 mySQL DB 에서 정보 가져오는 함수 
    // Update : 2024.04.22 by pdg
    //  - 더조은 학원 IP address  :  192.168.50.69
    String ip_database  = "192.168.50.69";
    String url_address ="http://$ip_database:8080/myarea?userId=$userId";
    var url =Uri.parse(url_address); 
    var response = await http.get(url);
    //print(response.body);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON;
    data.addAll(result);
    setState(() {});
  }

  // 선택 관심지 삭제 함수 
  _selectDelete(index){
    // Function desc : 모달 팝업 으로 data 삭제 함수 
    // Update : 2024.04.22 by pdg
    
    showCupertinoModalPopup(
      barrierDismissible: false,
      
      context: context, 
      builder: (context) =>CupertinoActionSheet(
        title: const Text("경고 ",),
        message: const Text("선택한 항목을 삭제 하시겠습니까?"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              //
            data.removeAt(index);
            setState((){});
            Get.back();
            }, 
            child: const Text("삭제"))
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed:() => Get.back(),
          child: const Text("Cancel"),
        ),
      ),
      );
  }
  
  // rebuild 함수 
  _rebuildData(index,String str){
    //Desc : data 재실행하여 화면 뿌려주기 
    // Update : 2024.04.23 by pdg
    if(str.isNotEmpty){
      data[index]['title'] =str;
      setState((){});
    }
  }
}// End

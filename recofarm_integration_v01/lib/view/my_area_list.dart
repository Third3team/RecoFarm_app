import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    value = 0;
    title = "내 경작지 리스트";
    userId = "pulpilisory";
    data = [];
    get_myarea_JSONData(userId);
  }
  // Json data fetching
  get_myarea_JSONData(userId) async {
    //String userId ;
    String url_address ="http://localhost:8080/myarea?userId=$userId";
    var url =Uri.parse(url_address); 
    var response = await http.get(url);
    print(response.body);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON;
    data.addAll(result);
    setState(() {});
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
                            onPressed: (context) => selectDelete(index)
                            
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
  selectDelete(index){
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
  // function
  _rebuildData(index,String str){
    if(str.isNotEmpty){
      data[index]['title'] =str;
      setState((){});
    }
  }
}// End

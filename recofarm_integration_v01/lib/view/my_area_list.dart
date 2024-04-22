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
		  - 내경 작지를 Json 으로 받아오는것 실험 .
  Detail      : - 

*/
class MyAreaList extends StatefulWidget {
  const MyAreaList({super.key});

  @override
  State<MyAreaList> createState() => _MyAreaListState();
}

class _MyAreaListState extends State<MyAreaList> {
  //properties
  late List data;

  late int value;
  late String title;

  @override
  void initState() {
    super.initState();
    value = 0;
    title = "Slidable ";
    data = [];
    getJSONData();
  }

  getJSONData() async {
    var url =
        Uri.parse('https://zeushahn.github.io/Test/movies.json'); //restful API
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];
    data.addAll(result);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: data.isEmpty
            ? const CircularProgressIndicator()
            : ListView.builder(
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Image.network(
                                data[index]['image'],
                                width: 80,
                              ),
                            ),
                          ),
                          Text(
                            "     ${data[index]['title']}",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  );
                }),
      ),
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

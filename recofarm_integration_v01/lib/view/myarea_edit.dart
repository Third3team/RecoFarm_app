import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAreaEdit extends StatefulWidget {
  final dynamic? myareaSize ;
  final dynamic? myareaProduct ;
  MyAreaEdit({
    super.key,
    required this.myareaSize,
    required this.myareaProduct
  });

  @override
  State<MyAreaEdit> createState() => _MyAreaEditState();
}

class _MyAreaEditState extends State<MyAreaEdit> {
  var value = Get.arguments ?? "__";
  late TextEditingController myareaProductController;
  late TextEditingController myareaSizeController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myareaSizeController = TextEditingController();
    myareaProductController = TextEditingController();
    myareaSizeController.text = value[0];
    myareaProductController.text = value[1];
  }

  @override
  Widget build(BuildContext context) {
    return
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image.network(value[0]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: myareaSizeController,
                decoration: InputDecoration(
                  labelText: "면적 수정 "
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: myareaProductController,
                decoration: InputDecoration(
                  labelText: "농산품 수정 "
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,10,0),
                  child: ElevatedButton(
                      onPressed: () {
                        //
                        Get.back(result: [myareaSizeController.text, myareaProductController]);
                      },
                      child: const Text("Edit")),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,0,0,0),
                  child: ElevatedButton(
                      onPressed: () {
                        //
                        Get.back(result: value[1]);
                      },
                      child: const Text("Cancel")),
                )
              ],
            )
          ],
        ),
      );
    
  }
}

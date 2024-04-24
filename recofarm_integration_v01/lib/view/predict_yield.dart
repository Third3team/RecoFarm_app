import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:new_recofarm_app/view/predict_price.dart';
import 'package:new_recofarm_app/vm/vmpredict_yield.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PredictYield extends StatelessWidget {
  PredictYield({super.key});

  TextEditingController areaController = TextEditingController();
  final VMpredict vmPredictController = Get.put(VMpredict());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[100],
        title: const Text(
          '수확량 예측하기',
          style: TextStyle(
            fontSize: 35
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              GetBuilder<VMpredict>(
                builder: (controller) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: RadioListTile(
                          value: false,
                          groupValue: vmPredictController.unitGroupValue,
                          onChanged: (value) => vmPredictController.selectUnitRadio(value),
                          title: const Text('평수'),
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: RadioListTile(
                          value: true,
                          groupValue: vmPredictController.unitGroupValue,
                          onChanged: (value) => vmPredictController.selectUnitRadio(value),
                          title: const Text('제곱미터'),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                  controller: areaController,
                  decoration: const InputDecoration(
                    hintText: '면적을 입력해주세요!',
                    hintStyle: TextStyle(
                      fontSize: 25
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: Container(
                  color: const Color.fromARGB(255, 222, 216, 216),
                  width: MediaQuery.of(context).size.width,
                  height: 5,
                ),
              ),
              GetBuilder<VMpredict>(
                builder: (controller) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            child: RadioListTile(
                              value: false,
                              groupValue: controller.groupValue,
                              onChanged: (value) {
                                controller.selectRadio(value);
                              }, 
                              title: const Text('검색'),
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: RadioListTile(
                              // value: vmPredictController.selecteAreaValue,
                              value: true,
                              groupValue: controller.groupValue,
                              onChanged: (value) {
                                controller.selectRadio(value);
                              },
                              title: const Text('지역 선택'),
                            ),
                          ),
                        ],
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          controller.placeSearchAction(context);
                        } ,
                        icon: const Icon(Icons.search),
                        label: Text(controller.buttonText),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: SizedBox(
                          width: 300,
                          height: 50,
                          child: Visibility(
                            visible: vmPredictController.selectAreaPlaceName.isNotEmpty,
                            child: Text(
                              '선택된 지역 : ${vmPredictController.selectAreaPlaceName}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: Container(
                  color: const Color.fromARGB(255, 222, 216, 216),
                  width: MediaQuery.of(context).size.width,
                  height: 5,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // 면적을 입력 안했을 때
                  if(areaController.text == '') {
                    errorSnackBar(context, '면적을 입력해주세요!');
                    return;
                  }
                  if(vmPredictController.selectAreaPlaceName == '') {
                    errorSnackBar(context, '지역을 선택해주세요!');
                    return;
                  }
                  confirmDialog(context);                
                },
                child: const Text('예측해보기')
              )
            ],
          ),
        ),
      ),
    );
  }

  confirmDialog(context) {
    Get.defaultDialog(
      title: '확인',
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '면적은 ',
                  style: TextStyle(
                    fontSize: 24
                  ),
                ),
                Text(
                  '${areaController.text} ',
                  style: const TextStyle(
                    color: Colors.red
                  ),
                ),
                Text(
                  // '제곱미터이고,',
                  '${!vmPredictController.unitGroupValue! ? '평' : '제곱미터'}',
                  style: const TextStyle(
                    fontSize: 24
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '선택된 지역은 ',
                  style: TextStyle(
                    fontSize: 24
                  ),
                ),
                Text(
                  '${vmPredictController.selectAreaPlaceName} ',
                  style: const TextStyle(
                    color: Colors.red
                  ),
                ),
                // const Text(
                //   '에서',
                //   style: TextStyle(
                //     fontSize: 24
                //   ),
                // ),
              ],
            ),
            const Text(
              '\n예상 수확량을 알아보기',
              style: TextStyle(
                fontSize: 24
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text('취소')
        ),
        ElevatedButton(
          onPressed: () {
            // vmPredictController.nearLatLng(LatLng(35.123456, 127.12345));
            // print(vmPredictController.nearLat);
            predictAction();
          },
          child: const Text('확인')
        ),
      ]
    );
  }

  // function
  predictAction() async {
    double areaSize = 0;
    areaSize = double.parse(areaController.text);

    if(!vmPredictController.unitGroupValue!) {
      areaSize = areaSize * 3.3;
    }

    var url = Uri.parse('http://192.168.50.69:8080/predict?areaSize=${areaSize}&lat=${vmPredictController.latData}&lng=${vmPredictController.lngData}');
    var response = await http.readBytes(url);
    double result = json.decode(utf8.decode(response));

    SharedPreferences ref = await SharedPreferences.getInstance();
    print('결과 $result');
    ref.setDouble('predict', result);

    Get.defaultDialog(
      title: '결과',
      middleText: '예상 수확량은 ${result.toStringAsFixed(2)}톤 입니다.\n',
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.back();
            Get.to(const Predict_Price());
          },
          child: const Text('확인')
        )
      ]
    );
  }

  errorSnackBar(context, String text) {
    Get.snackbar(
      '경고',
      '면적을 입력해주세요!',
      titleText: const Text('경고'),
      messageText: Text('$text'),
      backgroundColor: Theme.of(context).colorScheme.errorContainer
    );
  }
  
}
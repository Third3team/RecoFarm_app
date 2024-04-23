import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Predict_Price extends StatefulWidget {
  const Predict_Price({super.key});

  @override
  State<Predict_Price> createState() => _Predict_PriceState();
}

class _Predict_PriceState extends State<Predict_Price> {
  //Property
  // Property
  late List imageFile;
  late int currentIndex;
  late double predictYield;

  @override
  void initState() {
    super.initState();
    predictYield = 5; //임시변수
    // intiSharedPreference();
    imageFile = [
      'carbbage1.png',
      //'carbbage3.png',
      // 'carbbage2.png',
      // 'predict_price.png'
    ];
    currentIndex = 0;
    // Timer
    //Timer.periodic(const Duration(seconds: 3), (timer) {
    // changeImage();
    //});
  }

  intiSharedPreference() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    predictYield = ref.getDouble('predict')!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예측 도매 가격 & 예측 수익'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Text(
            //  '${imageFile[currentIndex]}',
            //  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
            Image.asset(
              'images/${imageFile[currentIndex]}',
              width: 400,
            ),
            const SizedBox(height: 50), // 이미지와 텍스트 사이에 간격을 설정합니다.
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('월간 도매 가격 예측 (3개월)',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold))
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('3월 : 9760원',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('4월 : 9940원',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('5월 : 10050원',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '5월 출고 예측 판매 수입 : ${(predictYield * 100 * 10050).round()} 원',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // -- Functions
  changeImage() {
    currentIndex++;
    if (currentIndex > imageFile.length - 1) {
      currentIndex = 0;
    }
    setState(() {});
  }
}

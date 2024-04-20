import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_recofarm_app/view/login.dart';

import 'home.dart';
/*
  * Description : Splash screen  
  * Date        : 2024.04.20
  * Author      : pdg 
  * Updates     : 
  *   2024.04.20 by pdg
        - logo image plotting ( farmer logo )
        - splash image 1, 2 삽입 

*/

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController =PageController();
    _timer= Timer.periodic(Duration(seconds: 2), (timer) {
      Get.to(Home(),
      transition: Transition.circularReveal
      );
      _timer.cancel();
     });
  }
  
  @override
  Widget build(BuildContext context) {
    // system icon 들의 색상을 밝게 하여 이미지랑 어울리게 함. 
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return PageView(
      controller: pageController,
      children: [
        Container(
          
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 241, 178, 82),
          ),
          child:  Center(
            child:  
            Container(
              width: 300,
              height: 400,
        
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/farmer.png",
                      width: 200,
                      height: 200),
                      //const LinearProgressIndicator(),
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Color.fromARGB(255, 144, 213, 146)
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      //pageview images
      Image.asset("images/splash_01.png",
        fit:BoxFit.cover
      ),
       Image.asset("images/splash_02.png",
        fit:BoxFit.cover
      )
      
      ],
    );
  }
}
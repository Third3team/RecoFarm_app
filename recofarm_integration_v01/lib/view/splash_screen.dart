import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
        - line progress indicator 

        - 사용자가 로그인을 한번했으면 로그인페이지로 가지않고 메인페이지로 간다. 
        - 사용자가 로그인을 하지 않았거나 처음 사용한다면 로그인 페이지로 간다. 
        

*/

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  late Timer _progressTimer;
  final PageController pageController = PageController();
  late double _progressValue;

  @override
  void initState() {
    super.initState();
    _progressValue = 0.0;
    void _updateProgress() {
      setState(() {
        _progressValue += 0.1;
        if (_progressValue >= 1.0) {
          _progressValue = 0.0;
        }
      });
    }

    _progressTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      _updateProgress();
      if (_progressValue >= 1.0) {
        _progressTimer.cancel();
      }
    });

    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      //2 초에 한번씩 페이지가 넘어가는 스플래쉬 제작
      int? nextpage = pageController.page?.toInt();
      if (nextpage == null) {
        return;
      }
      if (nextpage == 1) {
        // splash 화면이 다되면 메인으로 넘어감.
        Get.toNamed(
          "/home",
        );
        _timer.cancel();
      } else {
        nextpage++;
      }
      pageController.animateToPage(nextpage,
          duration: Duration(milliseconds: 700), 
          curve: Curves.easeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    // system icon 들의 색상을 밝게 하여 이미지랑 어울리게 함.
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      resizeToAvoidBottomInset:false,
      body: SafeArea(
        top: true,
        bottom: true,
        //maintainBottomViewPadding: true,
        
      
        child: PageView(
          controller: pageController,
          children: [
            // 농부가 웃고있는 그림.(+ process indicator )
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 241, 178, 82),
              ),
              child: Center(
                child: Container(
                  width: 300,
                  height: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("images/farmer.png",
                              width: 200, height: 200),
                          //const LinearProgressIndicator(),
                          SizedBox(
                            width: 80,
                            child: LinearProgressIndicator(
                              value: _progressValue,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              valueColor: AlwaysStoppedAnimation(
                                  Color.fromARGB(255, 144, 213, 146)),
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
            //2. page #2
      
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 241, 178, 82),
              ),
              child: Column(
                children: [
                   SizedBox( 
                    height:MediaQuery.of(context).size.height*0.25 ,),
                  SizedBox(
                    height: 400,
                    child: Column(
                     // mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                        
                          "images/splash_03.png",
                          height: 300,
                        ),
                        const SizedBox( height: 30,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 0.8,
                          //height: MediaQuery.of(context).size.width / 0.2,
                          child: Center(
                            child: Text(
                              " 심기전에 예측해보세요.",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontSize: 30,
                                  fontFamily: 'Dongle',
                                  fontWeight: FontWeight.bold),
                                                
                            ),
                          ),
                        
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Image.asset("images/splash_01.png", fit: BoxFit.cover),
            //Image.asset("images/splash_01.png", fit: BoxFit.contain)
          ],
        ),
      ),
    );
  }
}

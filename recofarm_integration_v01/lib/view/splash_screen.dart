import 'dart:async';

import 'package:flutter/material.dart';
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

*/

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 2), (timer) {
      Get.to(Home());
     });
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        
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
    );
  }
}
import 'package:Restart_Recofarm_project_ver_01/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vm/vmgetx.dart';
import 'view/home_widget.dart';
/*
 
  Description : Get X Home 
  Date        : 2024.04.20 Sat
  Author      : Forrest DongGeun Park. (PDG)
  Updates     : 
	  2024.04.20 Sat
		  - 
  Detail      : - 

*/

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Get injection 받아서 사용할때
    //final VmGetX controller =Get.put(VmGetX());
    Get.put(VmGetX());
    return Scaffold(
        appBar: AppBar(
          title: const Text("JSON Movie"),
        ),
        // widget 으로 분리 한다.
        body: SplashScreen());
  }
}

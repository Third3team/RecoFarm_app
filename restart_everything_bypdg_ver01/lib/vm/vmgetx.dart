import 'package:get/state_manager.dart';
/*
 
  Description :  Get X Controller 
  Date        : 2024.04.20 Sat
  Author      : Forrest DongGeun Park. (PDG)
  Updates     : 
	  2024.04.20 Sat
		  - 
  Detail      : - 

*/
class VmGetX extends GetxController{

  // Properties
  List data =[];

  int num1 =0;
  int num2 =0;
  int addResult = 0;

  calcuation(){
    addition();
    update();
  }
  addition (){
    addResult =num1+num2;
  }

}
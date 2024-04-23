import 'package:flutter/material.dart';
import 'package:new_recofarm_app/view/home_view_page.dart';
import 'package:new_recofarm_app/view/interesting_area.dart';
import 'package:new_recofarm_app/view/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 
  Description : 
          
                현재 Page는 추후에 로그인 이후 가장먼저 사용자에게 보여주는 홈화면으로 만들 생각입니다.
                TabBarView를 이용하여 각각 tabbar에 맞는 class를 만들어 주시면 됩니다.
                tabbar를 몇개로 할건지 또한 미정. 

  Date        : 2024-04-17 13:32
  Author      : lcy
  Updates     : 
    2024.04.22 by pdg 
      - 탭바 왼쪽은 관심 농산품 가격확인 페이지로 ,오른쪽은 관심소재지(지도) 페이지로 나누는 작업

  Detail      : - 

*/

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin {

  late TabController tController;

  @override
  void initState() {
    super.initState();
    tController = TabController(
      length: 2,
      vsync: this
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tController,
        children: [
          HomeViewPage(),

          InterestingAreaPage()

        ]
      ),
      bottomNavigationBar: Container(
        color: Colors.amber[100],
        child: TabBar(
          controller: tController,
          labelColor: Colors.green[700],
          indicatorColor: Colors.red,
          indicatorWeight: 4,
          tabs: [
            Tab(
              icon: Icon(Icons.home),
              text: '관심농산품',
            ),
            Tab(
              icon: Icon(Icons.checklist_rounded),
              text: '내 경작지',
            
            ),
            // Tab(
            //   icon: Icon(Icons.looks_two_outlined),
            //   text: 'ex one',
            // ),
          ],
        ),
      ),
    );
  }
}
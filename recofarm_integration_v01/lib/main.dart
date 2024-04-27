import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:new_recofarm_app/firebase_options.dart';
import 'package:new_recofarm_app/view/find_my_password.dart';
import 'package:new_recofarm_app/view/interesting_area.dart';
import 'package:new_recofarm_app/view/login_page.dart';
import 'package:new_recofarm_app/view/my_area_list.dart';
import 'package:new_recofarm_app/view/register_page.dart';
import 'package:new_recofarm_app/view/splash_screen.dart';
import 'view/home.dart';

/*
  * 
  * Description : Main 
  * Date        : 2024.04.17
  * Author      : 
  * Updates     : 
  *   2024.04.17 by pdg
  *     - main get x 사용할 수있도록 수정함 
  *     - debug mode flag 없앰
      2024.04.20 by pdg
        - splash screen 
      204.04.21 by pdg
        - 주석추가 

      2024.04.27 by pdg
        - 사용자가 테마를 변경하는 기능 드로워에 추가 
          ~ 글꼴변경, 라이트, 다크 모드 변경 
          
  *
*/

void main() async {
  //플러터 프레임 워크가 앱을 실행할 준비가 될때 까지 기다림
  WidgetsFlutterBinding.ensureInitialized();

  // Fire base init
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,
  );
  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // await preferences.clear();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Reco-Farm Application',
      // global language settings
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // UI font family 설정  => Dongle
        fontFamily: 'cookieRun',
        textTheme: const TextTheme(
          labelLarge: TextStyle(fontSize: 15),
          bodyLarge: TextStyle(fontSize: 15),
          bodySmall: TextStyle(fontSize: 10),
          bodyMedium: TextStyle(fontSize: 15),
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 233, 172, 30)),
        useMaterial3: true,
      ),
    
      home: const SplashScreen(),
      getPages: [
        GetPage(
            // Login page 으로 이동
            name: '/login',
            page: () => const LoginPage(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            // home 으로 이동
            name: '/home',
            page: () => const Home(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            //회원 가입 페이지 이동
            name: '/register',
            page: () => const RegisterPage(),
            transition: Transition.fadeIn,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            // 비밀번호 찾기 페이지로 이동
            name: '/findPw',
            page: () => const FindPasswordPage(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            // 내 관심 소재지로 이동 
            name: '/MyAreaList',
            page: () => const MyAreaList(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(seconds: 1)),
        GetPage(
            // 소재지 등록하는 Google map 
            name: '/interestArea',
            page: () => const InterestingAreaPage(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(seconds: 1)),
      ],
    );
  }
} // END

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:new_recofarm_app/firebase_options.dart';
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
  *
*/

void main() async {
  //플러터 프레임 워크가 앱을 실행할 준비가 될때 까지 기다림 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        fontFamily: 'Dongle',
        textTheme: const TextTheme(
          labelLarge: TextStyle(
            fontSize: 30
          ),
          bodyLarge: TextStyle(
            fontSize: 30
          ),
          bodySmall: TextStyle(
            fontSize: 30
          ),
          bodyMedium: TextStyle(
            fontSize: 30
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 254, 188, 66)),
        useMaterial3: true,
      ),

      home: SplashScreen(),
      getPages: [
        GetPage(
          name: '/home',
          page: () => const Home(),
          transition: Transition.circularReveal,
          transitionDuration: const Duration(seconds :1)
        ),
      ],


    );
  }
}// END

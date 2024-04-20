import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: 
        Container(
          color: Color.fromARGB(255, 255, 199, 114),
          child: Row(
            children: [
              Column(
                children: [
                  Image.asset("images/farmer.png",
                  width: 200,)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
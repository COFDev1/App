import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../view/logins_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 8), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: [
            Stack(children: [
              Container(
                height: constraints.maxHeight,
                color: Colors.white,
              ),
              Image.asset(
                'assets/images/login.gif',
                height: constraints.maxHeight,
                // fit: BoxFit.fill,
              ),
            ])
          ],
        );
      },
    );
  }
}

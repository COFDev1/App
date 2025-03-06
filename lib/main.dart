import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/models/protheus.dart';
import 'view/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); //

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.grey[900],
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Protheus()),
      ],
      child: MaterialApp(
        title: "Relacionamento com o Cliente",
        theme: ThemeData(
          useMaterial3: false,
          fontFamily: 'Lato',
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
          ),
        ),
        home: Splash(),
        routes: {},
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

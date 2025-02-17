import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/protheus.dart';
import 'view/logins_screen.dart';
// import 'view/teste.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //
  const MyApp({super.key}); //

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.grey[900],
    );

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Protheus())],
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

        home: LoginPage(), // ListCustomers() LoginPage() MyWidget()
        routes: {
          // AppRoutes.listContact: (ctx) =>
          //     ListContacts(lista: [], cCustomer: ""),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

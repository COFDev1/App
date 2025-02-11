import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsappcentral/models/protheus.dart';
import 'package:whatsappcentral/utils/app_routes.dart';
import 'package:whatsappcentral/view/contact_list.dart';
import 'view/logins_screen.dart';
import 'view/teste.dart';

void main() {
  runApp(const MyApp()); //
}

class MyApp extends StatelessWidget {
  //
  const MyApp({super.key}); //

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Protheus(),
        ),
      ],
      child: MaterialApp(
        title: "Relacionamento com o Cliente",
        theme: ThemeData(
          primarySwatch: Colors.blue,
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

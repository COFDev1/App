import 'package:flutter/material.dart';
import 'package:whatsappcentral/utils/app_routes.dart';
import 'package:whatsappcentral/view/contact_list.dart';
import 'view/logins_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Relacionamento com o Cliente",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(), // ListCustomers()
        routes: {
          AppRoutes.listContact: (ctx) => ListContacts(lista: []),
        },
        debugShowCheckedModeBanner: false);
  }
}

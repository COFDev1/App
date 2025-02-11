import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:whatsappcentral/components/controlaUsuario.dart';
import 'package:whatsappcentral/models/contact.dart';
import 'package:http/http.dart' as http;

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Future<List<Contact>>? lista;

  @override
  void initState() {
    super.initState();
  }

  Future<String> getFutureDados() async =>
      await Future.delayed(Duration(seconds: 20), () {
        return "Dados recebidos...";
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Future Builder',
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: getFutureDados(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Text(
                    snapshot.data!,
                    style: const TextStyle(fontSize: 20.0),
                  ),
                );
              } else {
                return Center(
                  child: const CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}

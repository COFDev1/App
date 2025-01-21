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
    // lista = _list();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Text("");
  }
}

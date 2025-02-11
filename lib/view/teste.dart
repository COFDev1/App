import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:whatsappcentral/components/controlaUsuario.dart';
import 'package:whatsappcentral/models/contact.dart';
import 'package:http/http.dart' as http;
import 'package:whatsappcentral/models/protheus.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Future<List<Contact>>? lista;

  void _getToken() {
    Map<String, String> header = Map();

    Provider.of<Protheus>(context, listen: false)
        .getToken()
        .catchError((error) {
      return showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Erro"),
          content: const Text("Falha na captura do token"),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }).then((value) {
      print("Resultado: ${value}");
    });
  }

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
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    _getToken();
                  },
                  child: Text("ok")),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getToken();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

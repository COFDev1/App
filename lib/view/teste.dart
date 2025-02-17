import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../models/protheus.dart';

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
    List<Widget> children;

    children = const <Widget>[
      SizedBox(
        width: 60,
        height: 100,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.amber),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('Aguarde...Efetivando operacão...'),
      ),
    ];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            'Future Builder',
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ));
  }
}

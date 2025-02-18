import 'package:flutter/material.dart';
import 'package:newapp/view/post.dart';
import 'package:provider/provider.dart';
import '../models/autenticacao.dart';
import '../models/contact.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Future<List<Contact>>? lista;

  Future<List<Contact>> _list({String id = ""}) async {
    final String url = Autenticacao.urlContacts;
    List<Contact> newList = [];

    // setState(() => isLoading = true);
    // request = await setHeader();

    final response = await http.get(Uri.parse(url + "${id}"), headers: {});
    print("Passou 01");
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)["items"];

      List<Contact> newList = [];

      newList = List<Contact>.from(json.map((elemento) {
        return Contact.fromJson(elemento);
      })).toList();

      return newList;
    } else {
      // return Future.error("Erro ao conectar com a Api");
      print("Passou 02");
      throw Exception('Falha ao carregar dados...');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Contact> getDataPost() async {
    // const url = "https://jsonplaceholder.typicode.com/posts/";
    final url = Autenticacao.urlContacts + "005329";
    final token =
        "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InBKd3RQdWJsaWNLZXlGb3IyNTYifQ.eyJpc3MiOiJUT1RWUy1BRFZQTC1GV0pXVCIsInN1YiI6Implc3NlIiwiaWF0IjoxNzM5ODgwMDcxLCJ1c2VyaWQiOiIwMDAwNjEiLCJleHAiOjE3Mzk4ODM2NzEsImVudklkIjoiUDEyXzMzX0hPTSJ9.bC3QMpTrhKaZ8xW8k9Q0u-teEAkle90gWVwDix29SSB_pqPWeTksRE45YrjT2X5AWv1UpZDm_pKcUVQ-2_0cRSdet8LXlakk455b5S2z7Gh0E9lT2ThS5iRuZaLCIRYTTQFFDcjYss71muR5aaNT5YQ_WH4aueGnfW5XScR3oG3n4Ma1pdDpVBpXx5gyUCGqjR3Skw7wyxFgAzLniQdBahXMWHWnuFRfQJg5JfSL-e_mf29DUrKW2tfP2CtKSdgLkK7X-S_9_rVRmfeNTraVRaaWBv3A8IrNJxxAfLjV8i74jqkog3gzHn-PkAPGMaHeGblUz7s279pKA7bxTYWgxA";
    Map<String, String> header = {};
    header["Content-Type"] = "application/json";
    header["Authorization"] = "Bearer $token";

    final response = await http
        .get(Uri.parse(url), headers: header)
        .timeout(Duration(seconds: 10));

    // final json = jsonDecode(response.body);

    // final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print("Conteudo retornado: $json.decode(response.body) ");
      return Contact.fromJson(json.decode(response.body));
    } else {
      print("Exceção lançada ");
      return throw Exception('Falha ao carregar dados...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            'Future Builder',
          ),
        ),
        body: FutureBuilder<Contact>(
            future: getDataPost(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Text('Data: ${snapshot.data}');
                } else {
                  return Text('No data available.');
                }
              }
              return Text('State: ${snapshot.connectionState}');
            }));
  }
}

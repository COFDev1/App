import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:whatsappcentral/models/autenticacao.dart';

class Protheus with ChangeNotifier {
  Map<String, dynamic> session = Map();

  Future<Map<String, dynamic>> getToken() async {
    bool newToken = true;

    if (session.isNotEmpty) {
      Duration duration = DateTime.now().difference(session["dateStart"]);

      newToken = duration.inMinutes >= 60;
    }

    if (newToken) {
      final client = http.Client();

      try {
        var response = await http.post(Uri.parse(Autenticacao.urlLogin));

        if (response.statusCode == 201) {
          session["token"] = jsonDecode(response.body)["access_token"];
          session["dateStart"] = DateTime.now();
        } else {
          throw Exception("Falha na geração do token com o Protheus");
        }
      } catch (e) {
        throw Exception("Erro: $e");
      } finally {
        client.close();
      }
    }

    return session;
  }
}

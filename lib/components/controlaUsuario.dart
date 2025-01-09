import 'package:http/http.dart' as http;
import 'package:whatsappcentral/models/autenticacao.dart';
import 'dart:async';
import 'dart:convert';

class ControlaUsuario {
  Future<String> conectaProtheus() async {
    var response = await http
        .post(Uri.parse(Autenticacao.urlLogin))
        .timeout(const Duration(seconds: 3));

    try {
      if (response.statusCode == 201) {
        final decodedMap = jsonDecode(response.body);

        print("Codigo do retorno da conexao: ${response.statusCode}");

        return decodedMap["access_token"];
      } else {
        throw Exception("Falha de conexao com o Protheus");
      }
    } catch (e) {
      throw Exception("Falha ao autenticar no Protheus 01 : $e");
    }
  }

  Future<String?> validUser(String user, String password, String token) async {
    Map<String, String> dataCustomer = {};
    dataCustomer["user"] = user;
    dataCustomer["password"] = password;

    Map<String, String> request = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    // var response = await http
    //     .post(Uri.parse(Autenticacao.urlSeller))
    //     .timeout(const Duration(seconds: 3));

    var response = await http.post(
      Uri.parse(Autenticacao.urlSeller),
      headers: request,
      body: jsonEncode(dataCustomer),
    );

    try {
      print('value: $response');
      if (response.statusCode == 200) {
        final seller = jsonDecode(response.body);

        print("Codigo do retorno da conexao: ${seller["seller"]}");

        return jsonDecode(response.body)["seller"].toString();
      }
    } catch (err) {
      print("Erroretornado $err");

      return ("Usuário/senha inválido: $err");
    }
  }
}

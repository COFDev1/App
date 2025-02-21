import 'package:http/http.dart' as http;
import '/models/autenticacao.dart';
import 'dart:async';
import 'dart:convert';

class ControlaUsuario {
  late Map messageResponse = {};

  Future<String> conectaProtheus() async {
    var response = await http.post(Uri.parse(Autenticacao.urlLogin));

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

  Future<Map<String, dynamic>?> validUser(
      String user, String password, String token) async {
    Map<String, String> dataCustomer = {};
    dataCustomer["user"] = user;
    dataCustomer["password"] = password;

    Map<String, String> request = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await http.post(
      Uri.parse(Autenticacao.urlSeller),
      headers: request,
      body: jsonEncode(dataCustomer),
    );

    try {
      if (response.statusCode == 200) {
        final seller = jsonDecode(response.body);

        print("Codigo do retorno da conexao: ${seller["seller"]}");
        print("Nome do vendedor: ${seller["name"]}");

        return messageResponse = jsonDecode(response.body);
      } else {
        messageResponse = jsonDecode(response.body);

        throw Exception(response.body);
      }
    } catch (error) {
      throw Exception('$error');
    }
  }
}

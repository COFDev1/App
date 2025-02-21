import 'dart:async';

import 'package:flutter/material.dart';

import '../components/controlaUsuario.dart';
import '../components/show_process.dart';
import 'list_customers.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final user = TextEditingController();
  final senha = TextEditingController();

  bool isLogin = true;
  late String titulo;
  late String actionButton;
  late String toggleButton;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        titulo = 'Bem vindo';
        actionButton = 'Login';
        toggleButton = 'Ainda não tem conta? Cadastre-se agora.';
      } else {
        titulo = 'Crie sua conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao Login.';
      }
    });
  }

  void login() async {
    String token = "";
    String seller = "";
    String name = "";

    isLoading = true;

    ControlaUsuario conexao = ControlaUsuario();

    try {
      token = await conexao.conectaProtheus().timeout(Duration(seconds: 5));

      if (token.isNotEmpty) {
        print("Token gerado  com sucesso:  ${token}");
      } else {
        throw Exception();
      }
    } catch (e) {
      throw _showMessageValidation(message: "Falha ao conectar/autenticar");
    }

    print("Passou 1 ");

    await conexao
        .validUser(user.text.trim(), senha.text.trim(), token)
        .then((value) => {
              isLoading = false,
              seller = value?["seller"],
              name = value!["name"],
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ListCustomers(
                    token: token,
                    sales: seller,
                    name: name,
                  ),
                ),
              )
            })
        .catchError((error) {
      throw _showMessageValidation(message: "Usuário/Senha incorreto");
    });
  }

  Future<void> _showMessageValidation({String message = ""}) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ocorreu um erro!"),
        content: Text(
          message,
        ),
        actions: [
          TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isLoading = false;
                });
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? ShowProcess(
              message: "Aguarde...Autenticando seu usuário... ",
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: TextFormField(
                          controller: user,
                          // style: TextStyle(color: Colors.blue, fontSize: 30),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Usuário",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Informe seu usuário";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                        child: TextFormField(
                          controller: senha,
                          obscureText: true,
                          // keyboardType: TextInputType.number,
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 30),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Senha",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Informa sua senha!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (isLogin) {
                                setState(() {
                                  isLogin = true;
                                });

                                login();
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: (isLoading)
                                ? [
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ]
                                : [
                                    Icon(Icons.check),
                                    Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        actionButton,
                                        // style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setFormAction(!isLogin),
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

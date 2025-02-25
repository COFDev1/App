import 'package:flutter/material.dart';
import '../components/show_process.dart';
import '../components/contact_form.dart';
import '../components/contact_item.dart';
import '../models/autenticacao.dart';
import '../models/contact.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../models/protheus.dart';

class ListContacts extends StatefulWidget {
  List<Contact> lista = [];
  String cCustomer = "";

  ListContacts({required this.lista, required this.cCustomer, super.key});

  @override
  State<ListContacts> createState() => _ListContactsState();
}

class _ListContactsState extends State<ListContacts> {
  String filter = "";
  final String _message = "Aguarde... Listando os Contatos...";
  var messageResponse = Map();
  bool allOk = false;
  bool hasData = false;

  final String url = Autenticacao.urlContacts;
  late String id = widget.cCustomer;

  late Map<String, String> request = {};
  bool isLoading = false;

  Future<List<Contact>>? futureContacts;

  Future<Map<String, String>> setHeader() async {
    Map<String, String> header = {};
    String token = "";

    await Provider.of<Protheus>(context, listen: false)
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
      token = value["token"];

      print("Resultado do provider: ${value}");

      header["Content-Type"] = "application/json";
      header["Authorization"] = "Bearer $token";
    });

    return header;
  }

  Future<List<Contact>> _list({String id = ""}) async {
    List<Contact> newList = [];
    setState(() => isLoading = true);
    request = await setHeader();

    final response = await http
        .get(Uri.parse(url + "${id}"), headers: request)
        .timeout(Duration(seconds: 10));

    widget.lista = [];

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)["items"];

      List<Contact> newList = [];

      newList = List<Contact>.from(json.map((elemento) {
        return Contact.fromJson(elemento);
      })).toList();

      widget.lista = newList;

      return newList;
    } else {
      throw Exception('Falha ao carregar dados...');
    }
  }

  Future<void> _add(
      {Map<String, dynamic>? contact, Contact? newContact}) async {
    // Gera o token de acesso a Protheus
    request = await setHeader();

    try {
      final response = await http.post(Uri.parse(url + "${id}"),
          headers: request, body: jsonEncode(contact));

      if (response.statusCode == 200) {
        setState(() => isLoading = false);
        Navigator.of(context).pop();
        _showDialogOk();
      } else {
        messageResponse = jsonDecode(response.body);
        throw Exception(response.body);
      }
    } catch (error) {
      return showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: Text(
            messageResponse["message"],
            style: TextStyle(color: Colors.red),
          ),
          actions: [
            TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  setState(() => isLoading = false);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }),
          ],
        ),
      );
    }
  }

  Future<void> _edit(
      {Map<String, dynamic>? contact,
      Contact? newContact,
      String id = ""}) async {
    // Gera o token de acesso a Protheus
    request = await setHeader();

    try {
      var response = await http.put(
        Uri.parse(url + widget.cCustomer),
        headers: request,
        body: jsonEncode(contact),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        _showDialogOk();
        setState(() {
          int position = widget.lista.indexWhere((element) => element.id == id);
          setState(() => isLoading = false);
          widget.lista[position] = newContact!;
        });
      } else {
        messageResponse = jsonDecode(response.body);
        throw Exception(response.body);
      }
    } catch (error) {
      return showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: Text(
            messageResponse["message"],
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  setState(() => isLoading = false);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }),
          ],
        ),
      );
    }
  }

  Future<void> _delete({int recsu5 = 0, recagb = 0}) async {
    final client = http.Client();

    request = await setHeader();

    try {
      final response = await client.delete(
        Uri.parse(url + "${id}" + "/" + "${recsu5}" + "/" + "${recagb}"),
        headers: request,
      );

      if (response.statusCode != 200) {
        throw Exception("Não foi possivel efetivar a exclusão do contato");
      } else {
        _removeContact(id);
        setState(() => isLoading = false);
        Navigator.of(context).pop();
        _showDialogOk();
      }
    } catch (e) {
      return showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Ocorreu um erro!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Falha ao excluir o contato',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  setState(() => isLoading = false);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }),
          ],
        ),
      );
    } finally {
      client.close();
    }
  }

  void _showDialogOk() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Sucesso',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Operação realizada com sucesso!!!',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _updateContact(
    Map<String, dynamic> details,
    int operation,
    BuildContext context,
  ) {
    final String identifier =
        details["index"] != -1 ? widget.lista[details["index"]].id : "";

    details.remove("index");

    final Contact newContact = Contact(
      id: identifier,
      name: details["name"],
      phone: details["phone"],
      type: details["tipo"],
      description: details["descricao"],
      idac8: details["recac8"],
      idagb: details["recagb"],
      idsa1: details["recsa1"],
      idsu5: details["recsu5"],
    );

    switch (operation) {
      case 3:
      case 4:
        operation == 3
            ? _add(contact: details, newContact: newContact)
            : _edit(contact: details, newContact: newContact, id: identifier);
        break;

      case 5:
        _delete(recsu5: newContact.idsu5, recagb: newContact.idagb);

        break;
      default:
        // statementn;
        break;
    }
  }

  _removeContact(String id) {
    setState(() {
      widget.lista.removeWhere((element) => element.id == id);
    });
  }

  _openContactFormModal(BuildContext? context,
      [String id = "", int index = -1, int operation = 3]) {
    final List<Contact> result = index != -1 ? [widget.lista[index]] : [];

    showModalBottomSheet(
      context: context!,
      builder: (_) {
        return ContactForm(
          onSubmit: _updateContact,
          listContact: result,
          index: index,
          operation: operation,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final PreferredSizeWidget appBar = AppBar(
      title: const Text("Contatos"),
      actions: [],
    );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Meus Contatos"),
        ),
        body:
            // isLoading
            // ? ShowProcess(
            //     message: _message,
            //   ):
            SizedBox(
          height: availableHeight * 0.8,
          child: FutureBuilder<List<Contact>>(
            future: _list(id: widget.cCustomer),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final contato = snapshot.data as List<Contact>;

                return ContactItem(
                  listContact: contato,
                  onRemove: _removeContact,
                  onOpenForm: _openContactFormModal,
                );
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Text(
                          "Não há contatos a serem exibidos",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Text(
                          "Falha ao carregar os dados",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return ShowProcess(
                  message: _message,
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openContactFormModal(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

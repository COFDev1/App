import 'package:flutter/material.dart';
import 'package:whatsappcentral/components/contact_form.dart';
import 'package:whatsappcentral/components/contact_item.dart';
import 'package:whatsappcentral/models/autenticacao.dart';
import 'package:whatsappcentral/models/contact.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

class ListContacts extends StatefulWidget {
  List<Contact> lista = [];
  String cCustomer = "";

  ListContacts({required this.lista, required this.cCustomer, super.key});

  @override
  State<ListContacts> createState() => _ListContactsState();
}

class _ListContactsState extends State<ListContacts> {
  String filter = "";
  bool allOk = false;
  bool hasData = false;

  final String url = Autenticacao.urlContacts;
  late String id = widget.cCustomer;
  late var request = setHeader();
  bool isLoading = false;

  Future<List<Contact>>? futureContacts;

  Map<String, String> setHeader() {
    Map<String, String> header = {};
    String token = "";

    token =
        "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InBKd3RQdWJsaWNLZXlGb3IyNTYifQ.eyJpc3MiOiJUT1RWUy1BRFZQTC1GV0pXVCIsInN1YiI6Implc3NlIiwiaWF0IjoxNzM5MTg3OTYwLCJ1c2VyaWQiOiIwMDAwNjEiLCJleHAiOjE3MzkxOTE1NjAsImVudklkIjoiUDEyXzMzX0hPTSJ9.eAO-AJJ0_EPprl7-cY_ed94WoxcaSR2ou1Umv6UNvy_e5YOEe2KBlSx3GJ_A3z4e8A6tjf_yUZkPDmp8sSVlRXYaJP0AKnSkuloS7wCEJ2X-gL6ancXAiu4EC8DbBmWevBXuB2ihu78QdDFmcod36of1jSs1fy4E51nQpYo0Ce0DZOZcZcMXm7u4IOREkY_UjBBf5LhXOhAQI9yF18kvXXVU-tw4yL61SOpja9TG9HkjjxdDukgMoJHkW6fQ4Ug97u2oDFE0BYDnyizmD01jSg3z61oAR7H50vc5aduB2e02wOvt0brlzQNDBZnMGAE8BoWks34eDTIKQxlH35sY6A";
    header["Content-Type"] = "application/json";
    header["Authorization"] = "Bearer $token";

    return header;
  }

  Future<List<Contact>> _list({String id = ""}) async {
    List<Contact> newList = [];

    final response = await http.get(Uri.parse(url + "${id}"), headers: request);

    widget.lista = [];

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)["items"];

      List<Contact> newList = [];

      newList = List<Contact>.from(json.map((elemento) {
        print("Elemento $elemento");
        return Contact.fromJson(elemento);
      })).toList();

      widget.lista = newList;

      return newList;
    } else {
      return Future.error("Erro ao conectar com a Api");
    }
  }

  Future<void> _add(
      {Map<String, dynamic>? contact, Contact? newContact}) async {
    final response = await http
        .post(
          Uri.parse(url + "${id}"),
          headers: request,
          body: jsonEncode(contact),
        )
        .timeout(const Duration(seconds: 10))
        .catchError((error) {
      return showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text("Falha ao cadastrar o contato."),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }).then((value) {
      print("Retorno:....${value.body}");
      setState(() => isLoading = false);
      allOk = value.statusCode == 200;

      Navigator.of(context).pop();
    });
  }

  Future<void> _edit(
      {Map<String, dynamic>? contact,
      Contact? newContact,
      String id = ""}) async {
    var response = await http.put(
      Uri.parse(url + "$id"),
      headers: request,
      body: jsonEncode(contact),
    );

    allOk = response.statusCode == 200 || response.statusCode == 201;

    if (allOk) {
      Navigator.of(context).pop();
      _showDialogOk();
      setState(() {
        int position = widget.lista.indexWhere((element) => element.id == id);
        setState(() => isLoading = false);
        widget.lista[position] = newContact!;
      });
    }
  }

  Future<void> _delete({int recsu5 = 0, recagb = 0}) async {
    final client = http.Client();

    try {
      final response = await client
          .delete(
              Uri.parse(url + "${id}" + "/" + "${recsu5}" + "/" + "${recagb}"),
              headers: request)
          .timeout(const Duration(seconds: 10));

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
          title: const Text('Ocorreu um erro!'),
          content: const Text('Falha ao excluir o contato:'),
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
    // finally {
    //   client.close();
    // }
  }

  Future<void> _validInsert(String phone) async {
    Map<String, String> listPhone = Map();

    listPhone["phone"] = "27988898998";
  }

  void _showDialogOk() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sucesso'),
        content: const Text('Operacao realizada com sucesso.'),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showDialogErro() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Erro"),
          content: const Text(
            "Falha ao efetivar a operação!!!",
            style: TextStyle(color: Colors.red),
          ),

          // style: TextStyle(color: Colors.red)
          actions: <Widget>[
            TextButton(
              child: const Text("Ok"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _updateContact(
    Map<String, dynamic> details,
    int operation,
    BuildContext context,
  ) {
    final String id =
        details["index"] != -1 ? widget.lista[details["index"]].id : "";

    details.remove("index");

    // setState(() => isLoading = true);

    final Contact newContact = Contact(
      id: id,
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
            : _edit(contact: details, newContact: newContact, id: id);
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
    bool dataOk = widget.lista.isEmpty;

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
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox(
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
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
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

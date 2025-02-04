import 'package:flutter/material.dart';
import 'package:whatsappcentral/components/contact_form.dart';
import 'package:whatsappcentral/components/contact_item.dart';
import 'package:whatsappcentral/models/autenticacao.dart';
import 'package:whatsappcentral/models/contact.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  final String url = Autenticacao.urlContacts;
  late String id = widget.cCustomer;
  late var request = setHeader();

  Future<List<Contact>>? futureContacts;

  @override
  void initState() {
    super.initState();
    print("Codigo do cliente recebido :  ${widget.cCustomer}");
    futureContacts = _list(id: widget.cCustomer);
    print("Valor retornado: $futureContacts");
  }

  Map<String, String> setHeader() {
    Map<String, String> header = {};
    String token = "";

    token =
        "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InBKd3RQdWJsaWNLZXlGb3IyNTYifQ.eyJpc3MiOiJUT1RWUy1BRFZQTC1GV0pXVCIsInN1YiI6Implc3NlIiwiaWF0IjoxNzM4NjkzNzI4LCJ1c2VyaWQiOiIwMDAwNjEiLCJleHAiOjE3Mzg2OTczMjgsImVudklkIjoiUDEyXzMzX0hPTSJ9.TQ8l7EpHJyWVlE3WPAQKE9tlN-CiOTw8l19BSqOBPVVoAuW2PNLFZmt4HQma0cLug7ZhcGNchsQ9vvQH2H61_tEEMCRPLI0FGmhiIoybmxtNb1j5jgBbYtSM8Z2-__aAPAv5Xz9S24ms-mjatGCXEqHK4Zangx4YWriWZQeHFfjyrkGsjogIY4o9Ah17Sa2PaN9zD-Um_NP78F_WUSUfvun-Yx4GE2STqkZYAxTqq2re6ZYHNYN6CtiUr1q8YMorwVv55x4b3JOY-RRvhrbs9MDvdUoYbzCdJWxkYleKYqbeGGIVz2RGIR2aZpePnqrJpz8D56IQaIrrNGWQK_F4gw";
    header["Content-Type"] = "application/json";
    header["Authorization"] = "Bearer $token";

    return header;
  }

  Future<List<Contact>> _list({String id = ""}) async {
    List newList = [];

    final response = await http.get(Uri.parse(url + "${id}"), headers: request);

    widget.lista = [];

    // if (response.statusCode == 200) {
    //   newList = [jsonDecode(response.body)];

    //   newList[0]["items"].forEach((element) {
    //     widget.lista.add(Contact(
    //       id: element["id"],
    //       name: element["name"],
    //       phone: element["phone"],
    //       type: element["tipo"],
    //       description: element["descricao"],
    //       idac8: element["recac8"],
    //       idagb: element["recagb"],
    //       idsa1: element["recsa1"],
    //       idsu5: element["recsu5"],
    //     ));
    //   });
    //   print("Lista retornada: ${widget.lista}");
    //   return widget.lista;
    // } else {
    //   return Future.error("Ops! Um erro ocorreu.");
    // }

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)["items"];

      return List<Contact>.from(json.map((elemento) {
        print("Elemento $elemento");
        return Contact.fromJson(elemento);
      })).toList();
    } else {
      return Future.error("Erro ao conectar com a Api");
    }
  }

  Future<void> _add(
      {Map<String, dynamic>? contact, Contact? newContact}) async {
    var response = await http.post(
      Uri.parse(url + "${id}"),
      headers: request,
      body: jsonEncode(contact),
    );

    allOk = response.statusCode == 200 || response.statusCode == 201;

    if (allOk) {
      String newId = jsonDecode(response.body)["id"];

      newContact!.id = newId;

      Navigator.of(context).pop();
      _showDialogOk();
      setState(() {
        widget.lista.insert(0, newContact!);
      });
    }
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

        widget.lista[position] = newContact!;
      });
    }
  }

  Future<void> _delete({int recsu5 = 0, recagb = 0}) async {
    Map<String, int> body = {};

    body["recsu5"] = recsu5;
    body["recagb"] = recagb;

    final response = await http
        .delete(
      Uri.parse(url + "${id}"),
      headers: request,
      body: jsonEncode(body),
    )
        .then((value) {
      print("Retorno:....${value.body}");
    });

    allOk = response.statusCode == 200;

    if (allOk) {
      Navigator.of(context).pop();
      _showDialogOk();
      _removeContact(id);
    }
  }

  Future<void> _validInsert(String phone) async {
    Map<String, String> listPhone = Map();

    listPhone["phone"] = "27988898998";
  }

  void _showDialogOk() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmação"),
          content: const Text("Operação realizada com sucesso!!!"),
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
        body: SizedBox(
            height: availableHeight * 0.8,
            child: FutureBuilder<List<Contact>>(
                future: futureContacts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print("Has data");

                    // List<Contact> data = snapshot.data;
                    return Text("Teste");
                  } else if (snapshot.hasError) {
                    print("Error");
                    print(snapshot.hasError);
                    print(snapshot);
                    return Text('${snapshot.hasError}');
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
            // ContactItem(
            //   listContact: widget.lista,
            //   onRemove: _removeContact,
            //   onOpenForm: _openContactFormModal,
            // ),
            ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openContactFormModal(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

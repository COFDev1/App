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

  @override
  void initState() {
    super.initState();
    print("Codigo do cliente recebido :  ${widget.cCustomer}");
    _list(id: widget.cCustomer);
  }

  Map<String, String> setHeader() {
    Map<String, String> header = {};
    String token = "";

    token =
        "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InBKd3RQdWJsaWNLZXlGb3IyNTYifQ.eyJpc3MiOiJUT1RWUy1BRFZQTC1GV0pXVCIsInN1YiI6Implc3NlIiwiaWF0IjoxNzM4NDI5ODg4LCJ1c2VyaWQiOiIwMDAwNjEiLCJleHAiOjE3Mzg0MzM0ODgsImVudklkIjoiUDEyXzMzX0hPTSJ9.VZ3XiaNDFX_KT8JTs4gydn70S96DMUoXoRZBVLfNfhnECQrBh6b4a6LLx1Qx2DKsurcJ83Qk607JnZ1ABZx_nsZK_2xiG2oWEiEANVIXgyPQrgZK2xb0HKJs-cLTonsPgR0KYmETjeLiF1HX-oXTlLrMmRWIlcqSJVdK73L7qe6EyVJrplAGC8KzNnEp82krCVVKfGOv1S93dPXIcH2PXpnu-BOjpKarLq84RyG0lH-ZQR-eh9K_5gzBrqq7Trf51eRiM8lKImlChvl_M0J_nvQc8c6uo2UFNNl4lskSJ3RWa0LRYVbCLSRvC8ppWn8GGJuGOsm_lFXhYYlkfwZMRA";
    header["Content-Type"] = "application/json";
    header["Authorization"] = "Bearer $token";

    return header;
  }

  Future<bool> _list({String id = ""}) async {
    List newList = [];

    final response = await http
        .get(Uri.parse(url + "${id}"), headers: request)
        .then((value) {
      print("Retorno:....${value.body}");

      newList = [jsonDecode(value.body)];
    });

    widget.lista = [];

    newList[0]["items"].forEach((element) {
      widget.lista.add(Contact(
        id: element["id"],
        name: element["name"],
        phone: element["phone"],
        type: element["tipo"],
        description: element["descricao"],
        idac8: element["recac8"],
        idagb: element["recagb"],
        idsa1: element["recsa1"],
        idsu5: element["recsu5"],
      ));
      print("Valor retornado ${element["recsu5"]} ");
    });
    setState(() {});
    // }
    return allOk;
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
        body: widget.lista.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FittedBox(
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
              )
            : SizedBox(
                height: availableHeight * 0.8,
                child: ContactItem(
                  listContact: widget.lista,
                  onRemove: _removeContact,
                  onOpenForm: _openContactFormModal,
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

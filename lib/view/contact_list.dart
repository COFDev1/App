import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:whatsappcentral/components/contact_form.dart';
import 'package:whatsappcentral/components/contact_item.dart';
import 'package:whatsappcentral/models/contact.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListContacts extends StatefulWidget {
  List<Contact> lista = [];

  ListContacts({required this.lista, super.key});

  @override
  State<ListContacts> createState() => _ListContactsState();
}

class _ListContactsState extends State<ListContacts> {
  final String url = "http://192.168.10.101:3001/contatos/";
  String filter = "";
  bool allOk = false;

  @override
  void initState() {
    super.initState();
    _list();
  }

  Future<bool> _list({String id = ""}) async {
    final response = await http.get(Uri.parse(url + "${id}"));

    allOk = response.statusCode == 200;

    if (allOk) {
      final List newList;

      final data = jsonDecode(response.body);

      newList = data is Map ? [jsonDecode(response.body)] : data;

      widget.lista = [];

      newList.forEach((element) {
        widget.lista.add(
          Contact(
              id: element["id"],
              name: element["name"],
              phone: element["phone"],
              type: element["tipo"],
              description: element["descricao"]),
        );
      });
      setState(() {});
    }
    return allOk;
  }

  Future<void> _add(
      {Map<String, dynamic>? contact, Contact? newContact}) async {
    var response = await http.post(Uri.parse(url), body: jsonEncode(contact));

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
    var response =
        await http.put(Uri.parse(url + "$id"), body: jsonEncode(contact));

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

  Future<void> _delete({String id = ""}) async {
    final response = await http.delete(Uri.parse(url + "${id}"));

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
      Map<String, dynamic> details, int operation, BuildContext context) {
    final String id =
        details["index"] != -1 ? widget.lista[details["index"]].id : "";

    details.remove("index");

    switch (operation) {
      case 3:
      case 4:
        final Contact newContact = Contact(
          id: id,
          name: details["name"],
          phone: details["phone"],
          type: details["tipo"],
          description: details["descricao"],
        );

        operation == 3
            ? _add(contact: details, newContact: newContact)
            : _edit(contact: details, newContact: newContact, id: id);
        break;

      case 5:
        _delete(id: id);

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
    // final List<Contact> result = id.isEmpty ? [] : [widget.lista[index]];
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

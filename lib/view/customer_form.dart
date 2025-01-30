import 'package:flutter/material.dart';
import 'package:whatsappcentral/models/customer.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:whatsappcentral/utils/app_routes.dart';
import 'package:whatsappcentral/view/contact_list.dart';

enum FilterOptions {
  add_contact,
  list_contacts,
}

class CustomerForm extends StatefulWidget {
  Customer customer;

  CustomerForm({required this.customer, super.key});

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  late final name = TextEditingController(text: widget.customer.name);
  late final whastApp = TextEditingController(text: widget.customer.whatsapp);

  void _save(Map<String, String> infoCustomer) async {
    const url = 'http://192.168.2.12:8083/rest/app/customers/';
    const String token =
        "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InBKd3RQdWJsaWNLZXlGb3IyNTYifQ.eyJpc3MiOiJUT1RWUy1BRFZQTC1GV0pXVCIsInN1YiI6Implc3NlIiwiaWF0IjoxNzMzNzU0MDM1LCJ1c2VyaWQiOiIwMDAwNjEiLCJleHAiOjE3MzM3NTc2MzUsImVudklkIjoiUDEyXzMzX0hPTSJ9.TeQ4f8AlBb8X04_DtVXluFUUePnlhmBa1q0PIkwThVnqn6MbslH5NLaM5ZeTn48uIayzyJtVbdTHwLJk8BoV-F2XQ5coKTWIYEvOAP04LqFaPdpRAj1Ecok68atVDmHj58dEzvGQAdpERQVnVClS7wcU-tydIbBGNq8HiOP0KT9wO5Y_WrdhXnscibfayvVtseQ-zMOG6C7zQUDDvwAkGgziajmu8gtZIGawrfm4qIccfrmDMNJfDTJS7u8mDbRjx3-cvn3E9ofd-wJYm2tVmuDwiPz5Hmn2Za_EmjcKtAiOqVbfdMMsMFNlXWCVmQIJSQF0xGwR3I9AQfbrYojA6g";

    Map<String, dynamic> body = {};
    body["user"] = "fernando.lopez";
    body["password"] = "031019";

    var teste = JsonEncoder().convert(body);

    Map<String, String> request = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http
        .post(
      Uri.parse(url),
      headers: request,
      body: jsonEncode(infoCustomer),
    )
        .then((_) {
      print("Passou aqui agora....");
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final actions = [];

    final PreferredSizeWidget appBar = AppBar(
      title: Text(widget.customer.name),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: FilterOptions.list_contacts,
              child: Text("Meus Contatos"),
            ),
          ],
          onSelected: (_) {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => ListContacts(
                        lista: [],
                        cCustomer: widget.customer.id,
                      )),
            );
          },
        )
      ],
    );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
        appBar: appBar,
        body: LayoutBuilder(builder: (ctx, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: availableHeight * 0.90,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: name,
                            onSubmitted: (_) => {},
                            decoration: InputDecoration(labelText: 'Nome'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: whastApp,
                            onSubmitted: (_) => {},
                            decoration: InputDecoration(labelText: 'WhatsApp'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: name,
                            onSubmitted: (_) => {},
                            decoration: InputDecoration(labelText: 'Nome'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: whastApp,
                            onSubmitted: (_) => {},
                            decoration: InputDecoration(labelText: 'WhatsApp'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: name,
                            onSubmitted: (_) => {},
                            decoration: InputDecoration(labelText: 'Nome'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: whastApp,
                            onSubmitted: (_) => {},
                            decoration: InputDecoration(labelText: 'WhatsApp'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: name,
                            onSubmitted: (_) => {},
                            decoration: InputDecoration(labelText: 'Nome'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: whastApp,
                            onSubmitted: (_) => {},
                            decoration: InputDecoration(labelText: 'WhatsApp'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: whastApp,
                            onSubmitted: (_) => {},
                            decoration: InputDecoration(labelText: 'Teste'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: whastApp,
                            onSubmitted: (_) => {},
                            decoration: InputDecoration(labelText: 'Teste 123'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}

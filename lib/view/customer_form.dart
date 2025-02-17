import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../view/contact_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  late final _nameController =
      TextEditingController(text: widget.customer.name);
  late final _adressController =
      TextEditingController(text: widget.customer.address);
  late final _whastAppController =
      TextEditingController(text: widget.customer.whatsapp);
  late final _burghController =
      TextEditingController(text: widget.customer.burgh);
  late final _cityController =
      TextEditingController(text: widget.customer.city);

  late final _complementController =
      TextEditingController(text: widget.customer.complement);

  late final _zipcodeController =
      TextEditingController(text: widget.customer.zipcode);
  late final _stateController =
      TextEditingController(text: widget.customer.state);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final actions = [
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
    ];

    final PreferredSizeWidget appBar = AppBar(
      title: Text(widget.customer.name),
      actions: actions,
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
                  height: availableHeight * 0.85,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: _nameController,
                            onSubmitted: (_) => {},
                            readOnly: true,
                            decoration: InputDecoration(labelText: 'Nome'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: _adressController,
                            onSubmitted: (_) => {},
                            readOnly: true,
                            decoration: InputDecoration(labelText: 'Endereço'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: false),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: TextField(
                            controller: _burghController,
                            readOnly: true,
                            onSubmitted: (_) => {},
                            decoration: InputDecoration(labelText: 'Bairro'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: _cityController,
                            onSubmitted: (_) => {},
                            readOnly: true,
                            decoration: InputDecoration(labelText: 'Cidade'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: _complementController,
                            readOnly: true,
                            onSubmitted: (_) => {},
                            decoration:
                                InputDecoration(labelText: 'Complemento'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: _zipcodeController,
                            readOnly: true,
                            onSubmitted: (_) => {},
                            decoration: InputDecoration(labelText: 'Cep'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextField(
                            controller: _stateController,
                            readOnly: true,
                            onSubmitted: (_) => {},
                            decoration: InputDecoration(labelText: 'Estado'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(15.0),
                        //   child: Column(
                        //     children: [],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 16.0),
                        //   child: TextField(
                        //     controller: name,
                        //     onSubmitted: (_) => {},
                        //     decoration: InputDecoration(labelText: 'Nome'),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 16.0),
                        //   child: TextField(
                        //     controller: whastApp,
                        //     onSubmitted: (_) => {},
                        //     decoration: InputDecoration(labelText: 'WhatsApp'),
                        //     keyboardType:
                        //         TextInputType.numberWithOptions(decimal: true),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 16.0),
                        //   child: TextField(
                        //     controller: whastApp,
                        //     onSubmitted: (_) => {},
                        //     decoration: InputDecoration(labelText: 'Teste'),
                        //     keyboardType:
                        //         TextInputType.numberWithOptions(decimal: true),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 16.0),
                        //   child: TextField(
                        //     controller: whastApp,
                        //     onSubmitted: (_) => {},
                        //     decoration: InputDecoration(labelText: 'Teste 123'),
                        //     keyboardType:
                        //         TextInputType.numberWithOptions(decimal: true),
                        //   ),
                        // ),
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

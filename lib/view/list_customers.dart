import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/show_process.dart';
import '../models/autenticacao.dart';
import '../models/customer.dart';
import '../components/custom_item.dart';
import '../view/logins_screen.dart';
import 'dart:convert';

class ListCustomers extends StatefulWidget {
  final String token;
  final String sales;

  const ListCustomers({
    required this.token,
    required this.sales,
    super.key,
  });

  @override
  State<ListCustomers> createState() => _ListCustomersState();
}

class _ListCustomersState extends State<ListCustomers> {
  List<Customer> listCustomers = [];
  List<Customer> copyListCustomers = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();

    setState(() => loading = true);

    loadCustomer();
  }

  void _filter(String valueSearch) {
    List<Customer> results = [];

    if (valueSearch.isEmpty) {
      results = copyListCustomers;
    } else {
      results = listCustomers
          .where((user) =>
              user.name.toLowerCase().contains(valueSearch.toLowerCase()))
          .toList();
    }
    setState(() {
      listCustomers = results;
    });
  }

  Future<void> loadCustomer() async {
    String token = widget.token;
    String saller = widget.sales;

    Map<String, String> request = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response =
        await http.get(Uri.parse(Autenticacao.urlCustomers + saller), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    print("Lendo os dados do produto $response");

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    print('Valor retornado: $response.body');

    data["items"].forEach((element) {
      listCustomers.add(
        Customer(
          id: element["codigo"],
          name: element["nome"],
          whatsapp: element["tel"],
          address: element["endco"],
          burgh: element["bairro"],
          city: element["municipio"],
          complement: element["compl"],
          state: element["uf"],
          zipcode: element["cep"],
        ),
      );
    });

    if (listCustomers.isNotEmpty) {
      setState(() => loading = false);
    }
    copyListCustomers = List.from(listCustomers);
  }

  @override
  Widget build(BuildContext context) {
    // final List<Customer> listCustomers = dummyCustomer.toList();
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: const Text("Listagem de Clientes"),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => LoginPage(),
              ),
            );
          },
        )
      ],
    );
    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: loading
            ? ShowProcess(
                message: "Aguarde...Buscando os clientes... ",
              )
            : Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: availableHeight * 0.12,
                          // width: mediaQuery.size.width * 0.8,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextField(
                                  onChanged: _filter,
                                  onSubmitted: (_) => {},
                                  decoration: InputDecoration(
                                    labelText: 'Nome',
                                    suffix: Icon(Icons.search),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: availableHeight * 0.80,
                          child: InkWell(
                            child: CustomItem(listCustomer: listCustomers),
                          ),
                        ),
                        // SizedBox(
                        //   height: availableHeight * 0.05,
                        //   child: FloatingActionButton(
                        //     onPressed: () => print("Ok..."),
                        //     elevation: 5,
                        //     child: const Icon(Icons.add),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

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
  final String name;

  ListCustomers({
    required this.token,
    required this.sales,
    this.name = '',
    super.key,
  });

  @override
  State<ListCustomers> createState() => _ListCustomersState();
}

class _ListCustomersState extends State<ListCustomers> {
  List<Customer> listCustomers = [];
  List<Customer> copyListCustomers = [];

  Future<List<Customer>>? futureCustomers;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    setState(() => loading = true);

    futureCustomers = loadCustomer();
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

  Future<List<Customer>> loadCustomer() async {
    String token = widget.token;
    String saller = widget.sales;

    Map<String, String> request = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http
          .get(Uri.parse(Autenticacao.urlCustomers + saller), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      print("Lendo os dados do produto $response");

      if (response.body == 'null') return [];
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
      // return List<Customer>.from(listCustomers);
      return copyListCustomers = List<Customer>.from(listCustomers);
    } catch (error) {
      return Future.error("Falha ao estabelecer conexão");
    }
  }

  @override
  Widget build(BuildContext context) {
    late String name = widget.name;

    print(widget.sales);

    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text('Olá, $name !'),
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
        body: FutureBuilder(
            future: futureCustomers,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // final customers = snapshot.data as List<Customer>;
                return Column(
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
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextField(
                                      onChanged: _filter,
                                      onSubmitted: (_) => {},
                                      decoration: InputDecoration(
                                        labelText: 'Nome',
                                        suffix: Icon(Icons.search),
                                      ),
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
                );
              } else {
                return ShowProcess(
                  message: "Aguarde...Buscando os clientes... ",
                );
              }
            }),
      ),
    );
  }
}

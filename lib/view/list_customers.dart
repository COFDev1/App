import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newapp/components/citys_item.dart';
import 'package:newapp/components/filter_citys.dart';
import '../components/show_process.dart';
import '../models/autenticacao.dart';
import '../models/customer.dart';
import '../components/custom_item.dart';
import '../view/logins_screen.dart';
import 'dart:convert';

enum SingingCharacter { lafayette, jefferson }

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
  List<String> listNeighborhood = [];
  List<String> listCitys = [];
  Map<String, bool> chechedCits = {};
  Map<String, bool> checkedNeighborhood = {};

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
      // results = listCustomers.where((user) => user.name.toLowerCase().contains(valueSearch.toLowerCase())).toList();
      results = listCustomers.where((user) {
        return user.name.toLowerCase().contains(valueSearch.toLowerCase());
      }).toList();
    }
    setState(() {
      listCustomers = results;
    });
  }

  Widget _showModalBottomSheet() => DraggableScrollableSheet(
        expand: false,
        key: UniqueKey(),
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: .5,
        builder: (context, controller) => Column(
          children: [
            Container(
              height: 59,
              color: Colors.cyanAccent,
            ),
            Expanded(
              child: ListView(
                controller: controller,
                children: [
                  ...List.generate(
                    40,
                    (index) => Container(
                      height: 100,
                      color: index.isEven ? Colors.deepOrange : Colors.deepPurple,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  void BottomSheetExample() {
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      builder: (context) => CardList(
        listData: listCustomers,
        listCitys: listCitys,
        listNeighborhood: listNeighborhood,
        checkNeighborhood: checkedNeighborhood,
      ),
    ).then((onValue) {
      print('Resultado $checkedNeighborhood');
    });
  }

  Future<List<Customer>> loadCustomer() async {
    String token = widget.token;
    String saller = widget.sales;

    try {
      final response = await http.get(Uri.parse(Autenticacao.urlCustomers + saller), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.body == 'null') return [];
      Map<String, dynamic> data = jsonDecode(response.body);

      print('Valor retornado: $response.body');

      data["items"].forEach((element) {
        listCustomers.add(
          Customer(
            id: element["codigo"],
            name: element["codigo"] + " - " + element["nome"],
            whatsapp: element["tel"],
            address: element["endco"],
            burgh: element["bairro"],
            city: element["municipio"],
            complement: element["compl"],
            state: element["uf"],
            zipcode: element["cep"],
          ),
        );

        if (listCitys.indexWhere((x) => x.toUpperCase() == element["municipio"].toUpperCase()) < 0) {
          listCitys.add(element["municipio"].toUpperCase());
          chechedCits['checked${listCitys.length - 1}'] = false;
        }
        if (listNeighborhood.indexWhere((x) => x.toUpperCase() == element["bairro"].toUpperCase()) < 0) {
          listNeighborhood.add(element["bairro"].toUpperCase());
          checkedNeighborhood['checked${listNeighborhood.length - 1}'] = false;
        }
      });

      if (listCustomers.isNotEmpty) {
        setState(() => loading = false);
      }
      copyListCustomers = List<Customer>.from(listCustomers);

      return copyListCustomers;
    } catch (error) {
      return Future.error("Falha ao estabelecer conexão");
    }
  }

  @override
  Widget build(BuildContext context) {
    late String name = widget.name;

    final listAction = [
      PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (_) => [
          PopupMenuItem(
              value: "logout",
              child: Text("Sair"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              }),
        ],
      )
    ];

    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(title: Text('Olá, $name !'), actions: listAction);
    final availableHeight = mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top;

    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        resizeToAvoidBottomInset: false,
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
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            onChanged: _filter,
                                            // onSubmitted: (_) => {_dialogBuilder(context)},
                                            decoration: InputDecoration(
                                                labelText: 'Código / Nome',
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                      BottomSheetExample();
                                                    },
                                                    icon: Icon(Icons.filter_alt_outlined,
                                                        color: Colors.blue // color: Colors.green) // format_list_bulleted_rounded
                                                        ))
                                                // suffix: Icon(Icons.search),
                                                // prefix: IconButton(
                                                //   icon: const Icon(
                                                //     Icons.account_circle_rounded,
                                                //     size: 30,
                                                //     color: Colors.blue,
                                                //   ),
                                                //   onPressed: () {},
                                                // ),
                                                ),
                                          ),
                                        ),
                                      ],
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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newapp/components/citys_item.dart';
import 'package:newapp/view/teste.dart';
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
  var _cidades = ['Nome', 'Estado', 'Cidade', 'Bairro'];
  var _itemSelecionado = 'Nome';
  SingingCharacter? _character = SingingCharacter.lafayette;

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

    print('Valor selecionado $_itemSelecionado');
    if (valueSearch.isEmpty) {
      results = copyListCustomers;
    } else {
      results = listCustomers.where((user) => user.name.toLowerCase().contains(valueSearch.toLowerCase())).toList();
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
    const List<String> _userOptions = <String>[
      'alice',
      'Bob',
      'Charlie',
      'Tatu',
      'Marta',
      'Maria',
      'aline',
      'adriana',
      'adrileia',
      'Tatu',
      'Marta',
      'Maria',
      'aline',
      'adriana',
      'adrileia',
    ];
    late final nameController = TextEditingController(text: "TEST");
    List<List<String>> listsData = [
      ['Item 1', 'Item 2', 'Item 3'],
      ['Item A', 'Item B', 'Item C', 'Item D'],
      ['Item X', 'Item Y', 'Item Z'],
      ['Item P', 'Item Q', 'Item R'],
      ['Item M', 'Item N', 'Item O'],
    ];
    final heightDevice = (MediaQuery.of(context).size.height / 2);

    // BottomSheetApp();
    bool checkboxValue2 = true;

    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
    //   ),
    //   builder: (context) {
    //     return DraggableScrollableSheet(
    //       builder: (context, scrollController) {
    //         return Column(
    //           children: [
    //             // ListView.builder(
    //             //   itemCount: 32,
    //             //   controller: scrollController,
    //             //   itemBuilder: (context, index) => ListTile(
    //             //     title: Text(index.toString()),
    //             //     onTap: () => Navigator.pop(context),
    //             //   ),
    //             // ),
    //             Text("Teste"),
    //             CheckboxListTile(
    //               value: checkboxValue2,
    //               onChanged: (bool? value) {
    //                 setState(() {
    //                   checkboxValue2 = value!;
    //                   print('Valor atual $checkboxValue2');
    //                 });
    //               },
    //               title: const Text('Headline'),
    //               subtitle: const Text(
    //                 'Longer supporting text to demonstrate how the text wraps and the checkbox is centered vertically with the text.',
    //               ),
    //             ),
    //           ],
    //         );
    //       },
    //     );
    //   },
    // );

    // showModalBottomSheet(
    //   isScrollControlled: true,
    //   // isDismissible: true,
    //   backgroundColor: Colors.transparent,
    //   context: context,
    //   // builder: (context) => _showModalBottomSheet(),
    //   builder: (context) => CardList(listData: _userOptions),
    // );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      builder: (context) => CardList(listData: _userOptions),
    );
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
                                                labelText: 'Nome',
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                      BottomSheetExample();
                                                    },
                                                    icon: Icon(
                                                      Icons.format_list_bulleted_rounded,
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
                                        // Expanded(
                                        //   child: SizedBox(
                                        //     width: mediaQuery.size.width,
                                        //   ),
                                        // ),
                                        // Expanded(
                                        //   child: DropdownButton<String>(
                                        //       items: _cidades.map((String dropDownStringItem) {
                                        //         return DropdownMenuItem<String>(
                                        //           value: dropDownStringItem,
                                        //           child: Text(dropDownStringItem),
                                        //         );
                                        //       }).toList(),
                                        //       onChanged: (String? novoItemSelecionado) {
                                        //         //  _dropDownItemSelected(novoItemSelecionado);
                                        //         setState(() {
                                        //           this._itemSelecionado = novoItemSelecionado as String;
                                        //         });
                                        //       },
                                        //       value: _itemSelecionado),
                                        // )
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

import 'package:flutter/material.dart';
import 'package:newapp/models/customer.dart';

class CardList extends StatefulWidget {
  final List<Customer> listData;
  final List<String> listCitys;
  final List<String> listNeighborhood;

  CardList({
    required this.listData,
    required this.listCitys,
    required this.listNeighborhood,
  });

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  bool isLoading = false;

  late List<Customer> autoCompleteData = widget.listData;
  late List<Customer> copyListData = widget.listData;
  late List<String> citys = widget.listCitys;
  late List<String> neighborhood = widget.listNeighborhood;

  late TextEditingController controller;

  Widget setFieldSearch() {
    return TextField(
      controller: controller,
      // focusNode: focusNode,
      // onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        hintText: "Informe a cidade",
        prefixIcon: Icon(Icons.search),
      ),
    );
  }

// Widget _createSectionContainer(Widget child) {
//     return Container(
//       width: 330,
//       height: 200,
//       padding: const EdgeInsets.all(10),
//       margin: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: child,
//     );
//   }

  static String _displayStringForOption(Customer option) => option.city;

  @override
  Widget build(BuildContext context) {
    print('Itens passados: $autoCompleteData');

    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          // Text(
          //   "Informe a Cidade e o Bairro",
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 16,
          //     color: Colors.black,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Autocomplete<Customer>(
                //   // displayStringForOption: _displayStringForOption,
                //   displayStringForOption: _displayStringForOption,
                //   optionsBuilder: (TextEditingValue textEditingValue) {
                //     if (textEditingValue.text.isEmpty) {
                //       return const Iterable<Customer>.empty();
                //     } else {
                //       // return autoCompleteData.where((word) {
                //       //   // return word.toLowerCase().contains(textEditingValue.text.toLowerCase());
                //       //   return word.city.toString().contains(textEditingValue.text.toLowerCase());
                //       // });
                //       return autoCompleteData.where((Customer option) {
                //         return option.toString().contains(
                //               textEditingValue.text.toLowerCase(),
                //             );
                //       });
                //     }
                //   },
                //   onSelected: (Customer selection) {
                //     debugPrint('Opcao selecionada:  $selection');

                //     // print(copyListData.isNotEmpty ? 1 : 0);
                //     // setState(() {
                //     //   // copyListData = ['Serra', 'Vitoria', 'Cariacica'];
                //     // });
                //   },
                //   fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                //     this.controller = controller;

                //     return TextField(
                //       controller: controller,
                //       focusNode: focusNode,
                //       onEditingComplete: onEditingComplete,
                //       decoration: InputDecoration(
                //         border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(8),
                //           borderSide: BorderSide(color: Colors.grey[300]!),
                //         ),
                //         focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(8),
                //           borderSide: BorderSide(color: Colors.grey[300]!),
                //         ),
                //         enabledBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(8),
                //           borderSide: BorderSide(color: Colors.grey[300]!),
                //         ),
                //         hintText: "Informe o nome da cidade",
                //         prefixIcon: Icon(Icons.search),
                //       ),
                //     );
                //   },
                //   optionsViewBuilder: (context, Function(Customer) onSelected, options) {
                //     return Card(
                //       elevation: 4,
                //       child: ListView.separated(
                //         padding: EdgeInsets.zero,
                //         itemBuilder: (context, index) {
                //           final option = options.elementAt(index);

                //           return ListTile(
                //             // title: Text(option.toString()),
                //             title: Text(option.toString()),
                //             // subtitle: Text("This is subtitle"),
                //             onTap: () {
                //               onSelected(option);
                //             },
                //           );
                //           // Widget _createSectionContainer(Widget child) {
                //         },
                //         separatorBuilder: (context, index) => Divider(),
                //         itemCount: options.length,
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
          /* 
            late List<String>   citys        = widget.listCitys;
          late List<String>   neighborhood = widget.listNeighborhood;
          */
          Text(
            "CIDADES",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.separated(
                // itemCount: widget.listData.length,
                itemCount: citys.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      citys[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(
                  thickness: 1,
                ),
              ),
            ),
          ),
          Text(
            "BAIRRO",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.separated(
                // itemCount: widget.listData.length,
                itemCount: neighborhood.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(
                    neighborhood[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ));
                },
                separatorBuilder: (BuildContext context, int index) => Divider(
                  thickness: 1,
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Navigator.pop(context);
              Navigator.of(context).pop('Saved');
            },
            child: const Text('Filtrar'),
          ),
        ],
      ),
    );
  }
}

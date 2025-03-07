import 'package:flutter/material.dart';
import 'package:newapp/models/customer.dart';

class CardList extends StatefulWidget {
  final List<Customer> listData;
  final List<String> listCitys;
  final List<String> listNeighborhood;
  final Map<String, bool> checkNeighborhood;

  CardList({
    required this.listData,
    required this.listCitys,
    required this.listNeighborhood,
    required this.checkNeighborhood,
  });

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  bool isLoading = false;
  bool _isChecked = true;

  late List<Customer> autoCompleteData = widget.listData;
  late List<Customer> copyListData = widget.listData;
  late List<String> citys = widget.listCitys;
  late List<String> neighborhood = widget.listNeighborhood;
  late Map<String, bool> markNeighborhood = widget.checkNeighborhood;

  late TextEditingController controller;

  late final Map<String, bool> _map = {};

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

  void _onCheckboxChanged(String key, bool? value) {
    setState(() {
      print('Chave: $key Valor: $value');
      markNeighborhood[key] = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "CIDADES",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.separated(
                // itemCount: widget.listData.length,
                itemCount: citys.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return
                      // ListTile(
                      //   title: Text(
                      //     citys[index],
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 20,
                      //     ),
                      //   ),
                      // );
                      Column(
                    children: [
                      CheckboxListTile(
                        title: Text(neighborhood[index]),
                        value: markNeighborhood['checked$index'],
                        onChanged: (bool? value) {
                          _onCheckboxChanged('checked$index', value);
                        },
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(
                  thickness: 1,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "BAIRRO",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.separated(
                itemCount: neighborhood.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      CheckboxListTile(
                        title: Text(neighborhood[index]),
                        value: markNeighborhood['checked$index'],
                        onChanged: (bool? value) {
                          _onCheckboxChanged('checked$index', value);
                        },
                      ),
                    ],
                  );
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

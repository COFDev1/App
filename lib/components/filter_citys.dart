import 'package:flutter/material.dart';

class CardList extends StatefulWidget {
  final List<String> listData;

  CardList({required this.listData});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  bool isLoading = false;

  late List<String> autoCompleteData = widget.listData;
  late List<String> copyListData = widget.listData;

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
                Autocomplete<String>(
                  // displayStringForOption: _displayStringForOption,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    } else {
                      // return autoCompleteData.where(
                      //   (word) => word.toLowerCase().contains(textEditingValue.text.toLowerCase()),
                      // );

                      return autoCompleteData.where((word) {
                        return word.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    }
                  },
                  onSelected: (String selection) {
                    debugPrint('Opcao selecionada:  $selection');

                    print(copyListData.isNotEmpty ? 1 : 0);
                    setState(() {
                      copyListData = ['Serra', 'Vitoria', 'Cariacica'];
                    });
                  },
                  fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                    this.controller = controller;

                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onEditingComplete: onEditingComplete,
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
                        hintText: "Informe o nome da cidade",
                        prefixIcon: Icon(Icons.search),
                      ),
                    );
                  },
                  optionsViewBuilder: (context, Function(String) onSelected, options) {
                    return Card(
                      elevation: 4,
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);

                          return ListTile(
                            // title: Text(option.toString()),
                            title: Text(option.toString()),
                            // subtitle: Text("This is subtitle"),
                            onTap: () {
                              onSelected(option.toString());
                            },
                          );
                          // Widget _createSectionContainer(Widget child) {
                        },
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: options.length,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.separated(
                // itemCount: widget.listData.length,
                itemCount: copyListData.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(copyListData[index]),
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

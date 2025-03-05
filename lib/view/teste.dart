import 'package:flutter/material.dart';

class CardList extends StatefulWidget {
  final List<String> listData;

  CardList({required this.listData});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  bool isLoading = false;

  late List<String> autoCompleteData;

  late TextEditingController controller;

  @override
  Widget build(BuildContext context) {
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
                Autocomplete(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    } else {
                      return autoCompleteData.where(
                        (word) => word.toLowerCase().contains(textEditingValue.text.toLowerCase()),
                      );
                    }
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
                            subtitle: Text("This is subtitle"),
                            onTap: () {
                              onSelected(option.toString());
                            },
                          );
                        },
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: options.length,
                      ),
                    );
                  },
                  onSelected: (selectedString) {
                    print(selectedString);
                  },
                  fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                    this.controller = controller;

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
                  },
                )
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Autocomplete<String>(
          //     initialValue: TextEditingValue(text: 'Informe a Cidade'),
          //     // displayStringForOption: _displayStringForOption,
          //     optionsBuilder: (TextEditingValue textEditingValue) {
          //       if (textEditingValue.text == '') {
          //         return const Iterable<String>.empty();
          //       }
          //       return widget.listData.where((String option) {
          //         return option.toString().toLowerCase().contains(textEditingValue.text.toLowerCase());
          //       });
          //     },
          //     onSelected: (String selection) {
          //       debugPrint('Opcao selecionada:  $selection}');
          //     },
          //   ),
          // ),

          // ListTile(
          //   title: Text('List ${listData[0]}'),
          // ),
          // Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.separated(
                itemCount: widget.listData.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.listData[index]),
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
              Navigator.pop(context);
            },
            child: const Text('Filtrar'),
          ),
        ],
      ),
    );
  }
}

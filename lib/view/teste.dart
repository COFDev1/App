import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  final List<String> listData;

  CardList({required this.listData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            "Informe a Cidade e o Bairro",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          Autocomplete<String>(
            // displayStringForOption: _displayStringForOption,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return listData.where((String option) {
                return option.toString().toLowerCase().contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              debugPrint('Opcao selecionada:  $selection}');
            },
          ),
          // ListTile(
          //   title: Text('List ${listData[0]}'),
          // ),
          // Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.builder(
                itemCount: listData.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(listData[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CheckboxListTileExample extends StatefulWidget {
  @override
  _CheckboxListTileExampleState createState() => _CheckboxListTileExampleState();
}

class _CheckboxListTileExampleState extends State<CheckboxListTileExample> {
  // Map to store the checkbox states
  Map<String, bool> _checkboxStates = {
    'Item 1': false,
    'Item 2': false,
    'Item 3': false,
    'Item 4': false,
    'Item 5': false,
  };

  // Function to update the state
  void _onCheckboxChanged(String key, bool? value) {
    setState(() {
      _checkboxStates[key] = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('Chaves : $_checkboxStates.keys );

    return Scaffold(
      appBar: AppBar(
        title: Text('CheckboxListTile with Map Example'),
      ),
      body: ListView(
        children: _checkboxStates.keys.map((String key) {
          print('Valor $key ');
          return CheckboxListTile(
            title: Text(key),
            value: _checkboxStates[key],
            onChanged: (bool? value) {
              _onCheckboxChanged(key, value);
            },
          );
        }).toList(),
      ),
    );
  }
}

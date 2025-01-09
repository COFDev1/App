import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:whatsappcentral/models/contact.dart';

class ContactItem extends StatelessWidget {
  final List<Contact> listContact;
  final void Function(String)? onRemove;
  final void Function(BuildContext, String, int, int) onOpenForm;

  const ContactItem({
    required this.listContact,
    this.onRemove,
    required this.onOpenForm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Contact> teste = [];
    return LayoutBuilder(builder: (ctx, constraints) {
      return Container(
        height: constraints.maxHeight,
        child: ListView.builder(
          itemCount: listContact.length,
          itemBuilder: (ctx, index) {
            final element = listContact[index];
            print("Valor instanciado: ${element.name}");
            teste.add(element);
            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 5,
              ),
              child: ListTile(
                  onTap: () => onOpenForm(context, element.id, index, 4),
                  leading: Padding(
                    padding: const EdgeInsets.all(6),
                    child: FittedBox(
                      child: Text(
                        '${element.id}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    element.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(element.phone),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () => onOpenForm(context, element.id, index, 5),
                  )),
            );
          },
        ),
      );
    });
  }
}

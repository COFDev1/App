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
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Column(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              onOpenForm(context, element.id, index, 4);
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Alterar"),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              onOpenForm(context, element.id, index, 5);
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text("Excluir"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

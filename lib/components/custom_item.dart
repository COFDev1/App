import 'package:flutter/material.dart';
import '/models/customer.dart';
import '/view/customer_form.dart';

class CustomItem extends StatelessWidget {
  final List<Customer> listCustomer;

  const CustomItem({required this.listCustomer, super.key});

  @override
  Widget build(BuildContext context) {
    return listCustomer.isEmpty
        ? Column(
            children: [
              const SizedBox(height: 40),
              Text(
                'Nenhuma cliente encontrado!',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/images/waiting.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          )
        : LayoutBuilder(
            builder: (ctx, constraint) {
              return Container(
                height: constraint.maxHeight * 0.3,
                color: Colors.grey[200],
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: listCustomer.length,
                  itemBuilder: (ctx, index) {
                    final tr = listCustomer[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 5,
                      ),
                      child: ListTile(
                          leading: IconButton(
                            icon: const Icon(
                              Icons.account_circle_rounded,
                              size: 30,
                              color: Colors.blue,
                            ),
                            onPressed: () {},
                          ),
                          title: Text(
                            tr.name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              tr.whatsapp,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CustomerForm(customer: tr),
                                ),
                              );
                            },
                          ),
                          iconColor: Colors.white,
                          textColor: Colors.black,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CustomerForm(customer: tr),
                              ),
                            );
                          }),
                    );
                  },
                ),
              );
            },
          );
  }
}

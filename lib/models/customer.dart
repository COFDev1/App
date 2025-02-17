class Customer {
  final String id;
  final String name;
  final String whatsapp;
  final String address;
  final String burgh;
  final String city;
  final String complement;
  final String state;
  final String zipcode;

  Customer({
    required this.id,
    required this.name,
    this.whatsapp = '',
    this.address = '',
    this.burgh = '',
    this.city = '',
    this.complement = '',
    this.state = '',
    this.zipcode = '',
  });
}

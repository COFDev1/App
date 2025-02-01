class Contact {
  String id;
  final String name;
  final String phone;
  final String type;
  final String description;

  int idac8;
  int idagb;
  int idsa1;
  int idsu5;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
    required this.description,
    this.idac8 = 0,
    this.idagb = 0,
    this.idsa1 = 0,
    this.idsu5 = 0,
  });
}

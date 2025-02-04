class Contact {
  String id;
  final String name;
  final String phone;
  final String type;
  final String description;

  final int idac8;
  final int idagb;
  final int idsa1;
  final int idsu5;

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

  Contact.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        phone = json["phone"],
        type = json["tipo"],
        description = json["descricao"],
        idac8 = json["recac8"],
        idagb = json["recagb"],
        idsa1 = json["recsa1"],
        idsu5 = json["recsu5"];
}

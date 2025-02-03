import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsappcentral/models/contact.dart';

class ContactForm extends StatefulWidget {
  final void Function(Map<String, dynamic>, int, BuildContext) onSubmit;
  final List<Contact>? listContact;
  final int? index;
  final int? operation;

  const ContactForm({
    required this.onSubmit,
    required this.operation,
    this.listContact,
    this.index,
    super.key,
  });

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  bool _lEdit = true;
  bool _addEdit = false;
  String dropdownValue = "";
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _typeContactController = TextEditingController();
  final _descriptionContactController = TextEditingController();
  final email = TextEditingController();
  List<String> options = [];

  @override
  void initState() {
    super.initState();

    options = loadOptionions();

    dropdownValue = options.first;
    _addEdit = (widget.operation == 3 || widget.operation == 4);
  }

  void _editContact() {
    dropdownValue = options.first;

    _lEdit = widget.operation == 3 || widget.operation == 4;
    _nameController.text = widget.listContact![0].name;
    _phoneController.text = widget.listContact![0].phone;
    _typeContactController.text = widget.listContact![0].type;
    _descriptionContactController.text = widget.listContact![0].description;
    _descriptionContactController.text = widget.listContact![0].description;

    int position = options.indexWhere(
        (element) => element.startsWith(_typeContactController.text));

    if (position >= 0) {
      options = _lEdit ? options : [options[position]];

      dropdownValue = _lEdit ? options[position] : options[0];
    }
    _lEdit = false;
  }

  List<String> loadOptionions() {
    List<String> options = <String>[
      "Tipo de Contato",
      "1 - Comercial",
      "2 - Residencial",
      "3 - Celular",
      "4 - WhatsApp",
      "5 - Fax comercial",
    ];

    // =Comercial;2=Residencial;3=Fax comercial;4=Fax residencial;5=Celular
    return options;
  }

  _submitForm(Map<String, dynamic> detailsContact) {
    final int operation = widget.operation!;

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          _addEdit ? "Gravação" : "Exclusão",
          style: TextStyle(color: _addEdit ? Colors.black : Colors.red),
        ),
        content: const Text("Deseja confirmar a operação ?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
              widget.onSubmit(detailsContact, operation, context);
            },
            child: const Text("OK"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, "Cancel");
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_lEdit && widget.listContact!.isNotEmpty) {
      _editContact();
    }

    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  readOnly: !_addEdit,
                  decoration: const InputDecoration(labelText: "Nome"),
                  // textInputAction: TextInputAction.next,
                  maxLength: 30,
                  validator: (value) {
                    final name = value ?? '';

                    if ((name.trim().isEmpty) && (_addEdit)) {
                      return "Nome é obrigatório.";
                    }

                    if ((name.trim().length < 3) && (_addEdit)) {
                      return "Nome precisa no mínimo de 3 letras.";
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  readOnly: !_addEdit,
                  decoration: const InputDecoration(
                    labelText: "Telefone", /*icon: Icon(Icons.phone)*/
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  maxLength:
                      dropdownValue.contains("3") || dropdownValue.contains("4")
                          ? 11
                          : 10,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    final phone = value ?? '';
                    int maxLim = dropdownValue.contains("3") ||
                            dropdownValue.contains("4")
                        ? 11
                        : 10;

                    if ((phone.trim().isEmpty) && (_addEdit)) {
                      return "Telefone é obrigatório.";
                    }

                    if ((phone.trim().length < maxLim) && (_addEdit)) {
                      return "Telefone deve ter $maxLim dígitos.";
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: DropdownButtonFormField<String>(
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      validator: (String? value) {
                        if ((value == options.first) && (_addEdit)) {
                          return "Opção inválida";
                        }
                        return null;
                      },
                      items:
                          options.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: TextFormField(
                    controller: _descriptionContactController,
                    readOnly: !_addEdit,
                    decoration: const InputDecoration(
                        labelText: "Descrição do Contato"),
                    maxLength: 30,
                    validator: (value) {
                      final description = value ?? '';

                      if ((description.trim().isEmpty) && (_addEdit)) {
                        return "O preenchimento do campo Descrição do Contato é obrigatório.";
                      }

                      if ((description.trim().length < 6) && (_addEdit)) {
                        return "Descrição do Contato precisa ter,no mínimo, de 6 letras.";
                      }

                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Map<String, dynamic> detail = Map();

                        detail["index"] = widget.index;
                        detail["name"] = _nameController.text;
                        detail["phone"] = _phoneController.text;
                        detail["tipo"] = dropdownValue;
                        detail["descricao"] =
                            _descriptionContactController.text;
                        detail["recac8"] =
                            _lEdit ? 0 : widget.listContact![0].idac8;
                        detail["recagb"] =
                            _lEdit ? 0 : widget.listContact![0].idagb;
                        detail["recsa1"] =
                            _lEdit ? 0 : widget.listContact![0].idsa1;
                        detail["recsu5"] =
                            _lEdit ? 0 : widget.listContact![0].idsu5;

                        _submitForm(detail);
                      },
                      child: const Text("Gravar"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  final Contact contact;

  ContactForm(this.contact);

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: setTextToAppBar(widget.contact.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            nameTextField(widget.contact.name),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: accountTextField(widget.contact.accountNumber),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () => lister(widget.contact.id),
                  child: setTextForButton(widget.contact.name),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void lister(int id) {
    final String name = _nameController.text;
    final int accountNumber = int.tryParse(_accountNumberController.text);
    if (id != 0) {
      Contact contact = Contact(id, name, accountNumber);
      _dao.update(contact).then((value) => Navigator.pop(context));
    } else {
      final Contact newContact = Contact(0, name, accountNumber);
      _dao.save(newContact).then((id) => Navigator.pop(context));
    }
  }

  Text setTextForButton(String contactName) {
    if (contactName.isEmpty) {
      return Text("Create");
    } else {
      return Text("Update");
    }
  }

  Text setTextToAppBar(String contactName) {
    if(contactName.isEmpty) {
      return Text("Add new contact");
    } else {
      return Text("Update contact");
    }
  }

  TextField accountTextField(int accountNumber) {
    if (accountNumber != 0) {
      _accountNumberController.text = accountNumber.toString();
    }
    return TextField(
      controller: _accountNumberController,
      decoration: InputDecoration(
        labelText: "Account number",
      ),
      style: TextStyle(
        fontSize: 24.0,
      ),
      keyboardType: TextInputType.number,
    );
  }

  TextField nameTextField(String name) {
    if (name.isNotEmpty) {
      _nameController.text = name;
    }
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: "Full name",
      ),
      style: TextStyle(
        fontSize: 24.0,
      ),
    );
  }
}

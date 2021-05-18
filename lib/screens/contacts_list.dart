import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _dao = ContactDao();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      body: FutureBuilder<List<Contact>>(
        initialData: [],
        future: _dao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              // Cenario quando o future ainda não foi carregado, podendo implementar alguma ação que faça o mesmo ser executado
              break;
            case ConnectionState.waiting:
              // Cenário quando o future ainda está carregando as informações
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator(), Text("Loading")],
                ),
              );
              break;
            case ConnectionState.active:
              // Significa que o future ainda está sendo executado, porém já existe um dado disponivel
              // Exemplo, download de um arquivo no qual vai mostrando os dados conforme o arquivo é baixado
              break;
            case ConnectionState.done:
              final List<Contact> contacts = snapshot.data;
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  debugPrint(index.toString());
                  return Dismissible(
                    key: UniqueKey(),
                    //child: _ContactItem(contacts[index]),
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ContactForm(contacts[index]),
                            ),
                          ).then((value) => {
                            setState(() {}),
                          });
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                              contacts[index].name,
                              style: TextStyle(
                                fontSize: 24.0,
                              ),
                            ),
                            subtitle: Text(
                              contacts[index].accountNumber.toString(),
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    onDismissed: (DismissDirection direction) async {
                      await _dao.delete(contacts[index].id);
                      setState(() {});
                    },
                  );
                },
              );

              break;
          }

          return Text("Unknown error was identified");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ContactForm(Contact(0, "", 0)),
            ),
          ).then((value) => {
            setState(() {})
          });
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
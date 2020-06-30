import 'package:flutter/material.dart';
import '../../bloc_Transition/transitions.dart';
import '../../AllPages/RegisteredContacts/contact_card.dart';
import '../../AllPages/RegisteredContacts/edit_contacts_api.dart';
import '../../AllPages/RegisteredContacts/select_contacts_page.dart';
import '../../global_data.dart' as server;
import '../../Sign_in_up/components/constants.dart';
import '../../Sign_in_up/components/round_button.dart';

class EditRegisteredContacts extends StatefulWidget with Navigationstates {
  String tokens;
  EditRegisteredContacts({this.tokens});
  @override
  _EditRegisteredContactsState createState() =>
      _EditRegisteredContactsState(tokens);
}

class _EditRegisteredContactsState extends State<EditRegisteredContacts> {
  String tokens;
  _EditRegisteredContactsState(this.tokens);

  @override
  Future<Map> _all_contacts() async {
    server.registered_contacts =
        await EditContactsApi.registered_contacts(tokens);
    print(server.registered_contacts);
    return server.registered_contacts;
  }

  initials(String name) {
    if (name.length > 0) {
      List initial = name.split(' ');
      return (initial.length > 0 ? initial[0][0].toUpperCase() : "") +
          (initial.length > 1 ? initial[1][0].toUpperCase() : "");
    }
    return " ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryLightColor,
        centerTitle: true,
        title: Text(
          'Your Registered Contacts',
          style: TextStyle(color: primaryColor),
          textAlign: TextAlign.center,
        ),
        leading: Icon(
          Icons.contacts,
          color: primaryColor,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            // flex: 4,
            child: FutureBuilder(
                future: _all_contacts(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                        child: Center(
                      child: CircularProgressIndicator(), // Text('Loading...'),
                    ));
                  } else {
                    return Container(
                      child: ListView.builder(
                          itemCount: snapshot.data['contacts'].length,
                          itemBuilder: (context, index) {
                            // var contact = registeredContacts[index];
                            var contact2 = snapshot.data['contacts'][index];
                            // print(snapshot.data['contacts'][index]);
                            // print(contact2['username']);
                            return ContactCard(
                              name: contact2['username'],
                              initials: initials(contact2['username']),
                              mobileNumber: contact2['phone_number'],
                              color: Colors.white,
                              onLongPress: () {},
                              onTap: () {},
                              trailing: GestureDetector(
                                child: Icon(Icons.delete),
                                onTap: () async {
                                  if (server.registered_contacts['contacts']
                                          .length >
                                      2) {
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Alert_Delete_Contact(
                                              contact: contact2,
                                              tokens: tokens);
                                        });
                                    setState(() {
                                      _all_contacts();
                                    });
                                  } else {
                                    final snackbar = SnackBar(
                                        content: Text(
                                            'You must have registered atleast 2 contacts !'));
                                    Scaffold.of(context).showSnackBar(snackbar);
                                  }
                                },
                              ),
                            );
                          }),
                    );
                  }
                }),
          ),
          RoundButton(
              buttonName: 'Add Contacts',
              onPress: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RegisterContacts(tokens: tokens)));
                setState(() {
                  _all_contacts();
                });
              }),
        ],
      ),
    );
  }
}

class Alert_Delete_Contact extends StatelessWidget {
  String tokens;
  var contact;
  Alert_Delete_Contact({this.contact, this.tokens});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Contact !'),
      content: Text(
          "Are you sure you want to delete the the contact ${contact['username']} ?"),
      actions: <Widget>[
        FlatButton(
          color: primaryColor,
          onPressed: () async {
            await EditContactsApi.delete_contact(
                contact['phone_number'], tokens);
            Navigator.of(context).pop();
          },
          child: Text('Yes, I want to delete this contact'),
        ),
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No',
                style: TextStyle(
                  color: Colors.black,
                )))
      ],
    );
  }
}

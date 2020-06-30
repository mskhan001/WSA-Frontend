import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'contact_card.dart';
import 'display_registered_contacts.dart';
import '../Sign_in_up/components/constants.dart';

class ContactsList<T> {
  bool isSelected = false;
  T data;
  ContactsList({this.data});
}

class RegisterContacts extends StatefulWidget {
  String tokens;
  String phonenum;
  String name;
  RegisterContacts({this.tokens, this.phonenum, this.name});
  @override
  _RegisterContactsState createState() =>
      _RegisterContactsState(tokens, phonenum, name);
}

class _RegisterContactsState extends State<RegisterContacts> {
  String tokens;
  String phonenum;
  String name;
  _RegisterContactsState(this.tokens, this.phonenum, this.name);
  List contacts =
      []; // All the contacts of the mobile as instances of ContactsList
  List selectedContacts =
      []; //All the contacts which are finally selected i.e. where isSelected == True
  int numberOfContactsSelected = 0; // number of selectedContacts
  final Color notSelectedColor = Colors.white; //Default Contact card color
  final Color selectedColor =
      Colors.grey; // Color when contact card is selected

  @override
  void initState() {
    super.initState();
    getAllContacts();
  }

//Loads all the contacts from the mobile to the variable(list) 'contacts'
  Future<void> getAllContacts() async {
    List<Contact> _contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();
    setState(() {
      // contacts = _contacts;
      for (int i = 0; i < _contacts.length; i++) {
        contacts.add(ContactsList<Contact>(data: _contacts[i]));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryLightColor,
        title: Text(
          numberOfContactsSelected > 0
              ? '$numberOfContactsSelected Contacts Selected'
              : 'Emergency Contacts',
          style: TextStyle(color: primaryColor),
        ),
        actions: <Widget>[
          numberOfContactsSelected > 0
              ? IconButton(
                  icon: Icon(
                    Icons.done,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    print(tokens);
                    selectedContacts = (contacts
                        .where((element) => element.isSelected)).toList();

                    List testList2 = selectedContacts
                        .map((e) => {
                              'name': e.data.displayName,
                              'phone_num': e.data.phones.elementAt(0).value,
                              'initials': e.data.initials()
                            })
                        .toList();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DisplayRegisteredContacts(
                                registeredContacts: testList2,
                                tokens: tokens,
                                phonenum: phonenum,
                                name: name)));
                  },
                )
              : Text(''),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Please select 5 Emergency contacts.',
              style: TextStyle(fontSize: 15.0),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    Contact contact = contacts[index].data;
                    return ContactCard(
                      name: contact.displayName,
                      initials: contact.initials(),
                      mobileNumber: contact.phones.elementAt(0).value,
                      color: contacts[index].isSelected
                          ? selectedColor
                          : notSelectedColor,
                      onLongPress: () {
                        setState(() {
                          contacts[index].isSelected = true;
                          numberOfContactsSelected++;
                          print(numberOfContactsSelected);
                        });
                      },
                      onTap: () {
                        setState(() {
                          if (numberOfContactsSelected > 0) {
                            setState(() {
                              contacts[index].isSelected
                                  ? numberOfContactsSelected--
                                  : numberOfContactsSelected++;
                              contacts[index].isSelected =
                                  !contacts[index].isSelected;
                              print(numberOfContactsSelected);
                            });
                          }
                        });
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

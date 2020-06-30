import 'package:flutter/material.dart';
import '../../AllPages/RegisteredContacts/contact_card.dart';
import 'edit_contacts_api.dart';
import '../../Sign_in_up/components/constants.dart';
import '../../Sign_in_up/components/round_button.dart';

class DisplayRegisteredContacts extends StatelessWidget {
  String tokens;
  final List registeredContacts;
  DisplayRegisteredContacts(this.registeredContacts, this.tokens);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryLightColor,
        title:
            Text('Emergency Contacts', style: TextStyle(color: primaryColor)),
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'The following ${registeredContacts.length} have been selected',
              style: TextStyle(fontSize: 15.0),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              child: ListView.builder(
                  itemCount: registeredContacts.length,
                  itemBuilder: (context, index) {
                    var contact = registeredContacts[index];
                    print(contact);
                    return ContactCard(
                      name: contact['name'],
                      initials: contact['initials'],
                      mobileNumber: contact['phone_num'],
                      color: Colors.white,
                      onLongPress: () {},
                      onTap: () {},
                    );
                  }),
            ),
          ),
          RoundButton(
            buttonName: 'Confirm',
            onPress: () async {
              await EditContactsApi.save_emergency_contact(
                  registeredContacts, tokens);
              Navigator.pop(context);
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: RaisedButton(
          //     color: Colors.blue,
          //     child: Text('Confirm'),
          //     onPressed: () async {
          //       await EditContactsApi.save_emergency_contact(
          //           registeredContacts, tokens);
          //       Navigator.pop(context);
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
}

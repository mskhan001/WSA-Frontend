import 'package:flutter/material.dart';
import 'package:scbproject/Sign_in_up/components/round_button.dart';
import 'contact_card.dart';
import 'contact_api.dart';
import '../Sidebar/SideBarLayout.dart';
import '../global_data.dart' as server;
import '../AllPages/RegisteredContacts/edit_contacts_api.dart';
import '../Sign_in_up/components/constants.dart';

class DisplayRegisteredContacts extends StatelessWidget {
  String tokens;
  String phonenum;
  String name;
  List registeredContacts;
  DisplayRegisteredContacts(
      {this.registeredContacts, this.tokens, this.phonenum, this.name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryLightColor,
        title: Text(
          'Emergency Contacts',
          style: TextStyle(color: primaryColor),
        ),
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
                    print(tokens);
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
              // This is saving the contacts to backend
              await ContactApi(registeredContacts: registeredContacts)
                  .save_emergency_contact(tokens);
              // This takes us to the Sidebar
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SidebarLayout(
                          tokens: tokens, phonenum: phonenum, name: name)),
                  (route) => false);
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: RaisedButton(
          //     color: Colors.blue,
          //     child: Text('Confirm'),
          //     onPressed: () async {
          //       // This is saving the contacts to backend
          //       await ContactApi(registeredContacts: registeredContacts)
          //           .save_emergency_contact(tokens);
          //       // This takes us to the Sidebar
          //       Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => SidebarLayout(
          //             tokens: tokens, phonenum: phonenum, name: name),
          //       ));
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
}

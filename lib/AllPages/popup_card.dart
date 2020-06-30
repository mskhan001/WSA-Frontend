import 'package:flutter/material.dart';
import 'send_message_api.dart';
import '../global_data.dart' as server;
import 'RegisteredContacts/edit_contacts_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Sign_in_up/components/constants.dart';

class PopupCard extends StatefulWidget {
  String tokens;
  PopupCard(this.tokens);
  @override
  _PopupCardState createState() => _PopupCardState(tokens);
}

class _PopupCardState extends State<PopupCard> {
  String tokens;
  _PopupCardState(this.tokens);

  @override
  void initState() {
    super.initState();
    _all_contacts();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('POPUP CARD STATE WAS DISPOSED');
  }

  var registered_contacts;
  List<bool> isSelected;
  @override
  Future<Map> _all_contacts() async {
    registered_contacts = await EditContactsApi.registered_contacts(tokens);
    setState(() {
      isSelected = List.filled(registered_contacts['contacts'].length, true);
    });
  }

// for custom message text field
  TextEditingController _controller = TextEditingController();

// stores the selected phone numbers
  _phone_nums_selected() {
    var phone_nums = [];
    for (int i = 0; i < registered_contacts['contacts'].length; i++) {
      if (isSelected[i]) {
        phone_nums.add(registered_contacts['contacts'][i]['phone_number']);
      }
    }
    return phone_nums;
  }

  @override
  Widget build(BuildContext context) {
    if (isSelected != null) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Text(
          'Emergency Message',
        ),
        content: Builder(
          builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return Container(
              width: width,
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        labelText: 'Custom Message',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.message, color: primaryColor)),
                  ),
                  Expanded(
                    child: Container(
                      // height: 200,
                      // width: 500,
                      child: ListView.builder(
                          // shrinkWrap: true,
                          itemCount: registered_contacts['contacts'].length,
                          itemBuilder: (context, index) {
                            var contact2 =
                                registered_contacts['contacts'][index];
                            print(contact2);
                            return Card(
                              elevation: 1.0,
                              child: ListTile(
                                title: Text(
                                  contact2['username'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(contact2['phone_number']),
                                trailing: Switch(
                                  value: isSelected[index],
                                  onChanged: (value) {
                                    setState(() {
                                      isSelected[index] = !isSelected[index];
                                      print(isSelected[index]);
                                    });
                                    print(isSelected);
                                  },
                                  activeColor: primaryColor,
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                // print(_phone_nums_selected());

                SendMessageApi.send_messages(
                    _phone_nums_selected(), _controller.text, widget.tokens);
                _controller.text = "";
                Navigator.pop(context, true);
              },
              child: Text('SEND MESSAGE'),
              color: primaryColor),
        ],
      );
    } else {
      return AlertDialog(
        content: Text('Loading'),
      );
    }
  }
}

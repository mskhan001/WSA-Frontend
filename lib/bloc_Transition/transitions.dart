import '../AllPages/EmergencyNotification.dart';
import '../AllPages/HomePage.dart';
import '../AllPages/LogOut.dart';
import "../AllPages/RegisteredContacts/EditRegisteredContacts.dart";
import '../AllPages/UserProfile/UserProfile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationEvents {
  MyHomePageClickedEvent,
  UserProfileClickedEvent,
  EmergencyNotificationClickedEvent,
  RegisteredContactsClickedEvent,
  LogOutClickedevent,
  //ChangeSafetyPinClickedEvent,
}

abstract class Navigationstates {}

class NavigationBloc extends Bloc<NavigationEvents, Navigationstates> {
  String tokens;
  String phonenum;
  String name;
  NavigationBloc({this.tokens, this.phonenum, this.name});
  @override
  get initialState =>
      MyHomePage(tokens: tokens, phonenum: phonenum, name: name);

  @override
  Stream<Navigationstates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.MyHomePageClickedEvent:
        yield MyHomePage(tokens: tokens, phonenum: phonenum, name: name);
        break;
      case NavigationEvents.EmergencyNotificationClickedEvent:
        yield EmergencyNotification();
        break;
      case NavigationEvents.UserProfileClickedEvent:
        yield Userprofile();
        break;
      case NavigationEvents.RegisteredContactsClickedEvent:
        yield EditRegisteredContacts();
        break;
      case NavigationEvents.LogOutClickedevent:
        yield LogOut();
        break;
      //case NavigationEvents.ChangeSafetyPinClickedEvent: yield  ChangePin();
      //break;

    }
  }
}

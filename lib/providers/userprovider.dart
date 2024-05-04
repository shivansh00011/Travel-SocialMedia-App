import 'package:flutter/widgets.dart';
import 'package:zoltrakk/models/user.dart';
import 'package:zoltrakk/resources/auth_method.dart';

class UserProvider with ChangeNotifier {
   User? _user;
  final AuthMethods _authMethods = AuthMethods();
   User? get getUser => _user;




 Future<void> refreshUser() async {
  try {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  } catch (e) {
    print("Error getting user details: $e");
    // Handle the error appropriately (e.g., show a snackbar to the user)
  }
}
}
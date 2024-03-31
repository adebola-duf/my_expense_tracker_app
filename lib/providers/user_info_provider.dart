import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker_app/models/user.dart';

class UserInfoNotifier extends StateNotifier<User> {
  UserInfoNotifier()
      : super(
          const User(
            email: "noone",
            password: "noone",
            // firstName: "noone",
            // lastName: "noone",
          ),
        );

  void setUserObject(User user) {
    state = user;
  }

  User getUserObject() {
    return state;
  }
}

final userInfoProvider = StateNotifierProvider<UserInfoNotifier, User>(
  (ref) => UserInfoNotifier(),
);

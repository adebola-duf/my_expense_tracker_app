class LoginUser {
  const LoginUser({
    required this.email,
    required this.password,
    // required this.firstName,
    // required this.lastName,
  });

  final String email;
  final String password;
  // final String firstName;
  // final String lastName;
}

final List<SignupUser> myUsers = [
  const SignupUser(
    email: "adeboladuf@gmail.com",
    password: "bolexyro",
    firstName: "Adebola",
    lastName: "Odufuwa",
  ),
];

class SignupUser {
  const SignupUser({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  final String email;
  final String password;
  final String firstName;
  final String lastName;
}




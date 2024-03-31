import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late String _firstName;
  late String _lastName;
  late String _email;
  late String _password;
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
  }

  bool _isLoading = false;
  bool _obscureText = true;

  Future<http.Response> _sendRequest() async {
    final url = Uri.http('localhost:8000', '/create-user');
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "first_name": _firstName,
        "last_name": _lastName,
        "email": _email,
        "password": _password
      }),
    );
    setState(() {
      _isLoading = false;
    });

    return response;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    final http.Response response = await _sendRequest();

    if (response.statusCode == 200) {
      _showSnackBar("Your account has been created successfully. Sign In");
      _goToLoginPage();
    }

    if (response.statusCode == 409) {
      _showSnackBar("You already have an account. Sign in instead");
      _goToLoginPage();
    }
  }

  void _goToLoginPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonContent = const Text("SIGNUP");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create Account",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Text("Please fill the input below here"),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (newValue) {
                    _firstName = newValue!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a valid name";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: const Text("FIRSTNAME"),
                    labelStyle: const TextStyle(fontSize: 10),
                    icon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (newValue) {
                    _lastName = newValue!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a valid name";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: const Text("LASTNAME"),
                    labelStyle: const TextStyle(fontSize: 10),
                    icon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (newValue) {
                    _email = newValue!;
                  },
                  validator: (value) {
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (value == null || !emailRegex.hasMatch(value)) {
                      return "Invalid email.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: const Text("EMAIL"),
                    labelStyle: const TextStyle(fontSize: 10),
                    icon: const Icon(Icons.mail),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (newValue) {
                    _password = newValue!;
                  },
                  validator: (value) {
                    final passwordRegex = RegExp(r'^.{8,}$');
                    if (value == null || !passwordRegex.hasMatch(value)) {
                      return "password should be at least 8 characters long";
                    }
                    return null;
                  },
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        icon: _obscureText
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    label: const Text("PASSWORD"),
                    labelStyle: const TextStyle(fontSize: 10),
                    icon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: _isLoading ? null : _signup,
                        borderRadius: BorderRadius.circular(23),
                        child: Container(
                          alignment: Alignment.center,
                          width: 190,
                          height: 50,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(23),
                          ),
                          child: _isLoading == false
                              ? buttonContent
                              : const CircularProgressIndicator(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // const Expanded(
                      //   child: SizedBox(),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: _goToLoginPage,
                            child: const Text("Sign in"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

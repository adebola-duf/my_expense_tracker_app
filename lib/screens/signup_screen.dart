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
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _firstnameTextController = TextEditingController();
  final _lastnameTextController = TextEditingController();

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _firstnameTextController.dispose();
    _lastnameTextController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  Future<http.Response> _sendRequest() async {
    String firstName = _firstnameTextController.text;
    String lastName = _lastnameTextController.text;
    String email = _emailTextController.text;
    String password = _passwordTextController.text;

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
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password
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
              TextField(
                controller: _firstnameTextController,
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
              TextField(
                controller: _lastnameTextController,
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
              TextField(
                controller: _emailTextController,
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
              TextField(
                controller: _passwordTextController,
                decoration: InputDecoration(
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
                          color: Theme.of(context).colorScheme.primaryContainer,
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
    );
  }
}

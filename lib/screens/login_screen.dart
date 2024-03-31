import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker_app/models/user.dart';
import 'package:my_expense_tracker_app/providers/all_expenses_provider.dart';
import 'package:my_expense_tracker_app/providers/user_info_provider.dart';
import 'package:my_expense_tracker_app/screens/expenses_app_screen.dart';
import 'package:my_expense_tracker_app/screens/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  late String _email;
  late String _password;

  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
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

  Future<http.Response> _sendRequest() async {
    final url = Uri.http('localhost:8000', '/verify-user');
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
      url,
      body: json.encode({
        "email": _email,
        "password": _password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    return response;
  }

  Future<List<dynamic>> _getAllExpenses() async {
    final url = Uri.http('localhost:8000', '/get-expenses/$_email');
    final http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  void _attemptLogin() async {
    bool emailAndPasswordIsValid = _setEmailAndPassword();
    if (emailAndPasswordIsValid) {
      final http.Response response = await _sendRequest();
      if (response.statusCode == 200) {
        final userMap = json.decode(response.body);
        ref.read(userInfoProvider.notifier).setUserObject(
              User(
                email: userMap['email'],
                firstName: userMap['first_name'],
                lastName: userMap['last_name'],
              ),
            );
        ref
            .read(allExpensesProvider.notifier)
            .setAllExpenses(await _getAllExpenses());
        setState(() {
          _isLoading = false;
        });

        _showSnackBar('Login successful');
        _goToExpenseAppPage();
      }

      if (response.statusCode == 401) {
        _showSnackBar(json.decode(response.body)['detail']);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _setEmailAndPassword() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  void _goToExpenseAppPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ExpensesAppScreen(),
      ),
    );
  }

  void _goToSignupPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget logingButtonContent = const Text("LOGIN");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "login_icon.png",
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Text("Please sign in to contine"),
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
                  obscureText: true,
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
                        onTap: _isLoading ? null : _attemptLogin,
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
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : logingButtonContent,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Forgot Password?"),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: _goToSignupPage,
                            child: const Text("Sign up"),
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

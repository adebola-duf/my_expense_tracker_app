import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/models/user.dart';
import 'package:my_expense_tracker_app/screens/expenses_app_screen.dart';
import 'package:my_expense_tracker_app/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  bool _isValidCredentials(LoginUser user) {
    for (final eachUser in myUsers) {
      if (eachUser.email == user.email && eachUser.password == user.password) {
        return true;
      }
    }
    return false;
  }

  void _attemptLogin() {
    String email = _emailTextController.text;
    String password = _passwordTextController.text;

    bool userIsValid =
        _isValidCredentials(LoginUser(email: email, password: password));
    if (userIsValid) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ExpensesAppScreen(),
        ),
      );
    } else {
      showAdaptiveDialog(
        context: context,
        builder: (context) => const AlertDialog.adaptive(
          title: Text("You suck bro"),
        ),
      );
    }
  }

  void _goToSignupPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
            TextField(
              controller: _emailTextController,
              decoration: InputDecoration(
                label: const Text("EMAIL"),
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
                    onTap: _attemptLogin,
                    borderRadius: BorderRadius.circular(23),
                    child: Container(
                      alignment: Alignment.center,
                      width: 190,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: const Text(
                        "login",
                        style: TextStyle(color: Colors.white),
                      ),
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
    );
  }
}

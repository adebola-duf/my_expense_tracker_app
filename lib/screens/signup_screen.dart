import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/models/user.dart';
import 'package:my_expense_tracker_app/screens/login_screen.dart';

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
  void _signup() async {
    String firstName = _firstnameTextController.text;
    String lastName = _lastnameTextController.text;
    String email = _emailTextController.text;
    String password = _passwordTextController.text;

    SignupUser newUser = SignupUser(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName);
    myUsers.add(newUser);

    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        content: Text(
          "Your account has been created successfully.",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    await Future.delayed(
      const Duration(seconds: 1),
    );

    _goToLoginPage();
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

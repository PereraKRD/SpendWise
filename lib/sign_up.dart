import 'package:flutter/material.dart';
import 'package:spendwise/common/color_extension.dart';
import 'package:spendwise/constants.dart';
import 'package:spendwise/log_in.dart';
import 'package:spendwise/services/auth_service.dart';
import 'package:spendwise/validators.dart';

// ignore: must_be_immutable
class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _BudgetController = TextEditingController();

  var authService = AuthService();
  var isLoader = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      var data = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'budget': int.parse(_BudgetController.text),
        'remainingAmount': int.parse(_BudgetController.text),
        'totalExpenses': 0,
        'totalIncomes': 0,
      };

      await authService.createUser(data, context);
      setState(() {
        isLoader = false;
      });
      // ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
      //   const SnackBar(content: Text('Form Submitted Successfully !!')),
      // );
    }
  }

  var appValidators = AppValidators();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text(
                        "Create new Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.name,
                      style: TextStyle(color: TColor.primary),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration:
                          buildInputDecoration("Username", Icons.person),
                      validator: appValidators.validateName,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: TColor.primary),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: buildInputDecoration("Email", Icons.email),
                      validator: appValidators.validateEmail,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(color: TColor.primary),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: true,
                      decoration:
                          buildInputDecoration("Password", Icons.password),
                      validator: appValidators.validatePassword,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // for the telephone number
                    TextFormField(
                      controller: _BudgetController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: TColor.primary),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration:
                          buildInputDecoration("Budget", Icons.monetization_on),
                      validator: appValidators.validateBudget,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      width: 300,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amber),
                        ),
                        onPressed: () {
                          isLoader ? print("Loading") : _submitForm();
                        },
                        child: isLoader
                            ? const Center(child: CircularProgressIndicator())
                            : const Text('Sign Up'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //google sign in
            Container(
              height: 50,
              width: 300,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(TColor.primary)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.g_mobiledata, color: Colors.white),
                    Text('Sign Up with Google',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //sign in anonymously
            // Container(
            //   height: 50,
            //   width: 300,
            //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     child: const Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(Icons.person),
            //         Text('Sign Up Anonymously'),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.black),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LogInView()),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: TColor.primary),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}

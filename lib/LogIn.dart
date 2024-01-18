import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:spendwise/common/color_extension.dart';
import 'package:spendwise/Constants.dart';
import 'package:spendwise/services/auth_service.dart';
import 'package:spendwise/SignUp.dart';
import 'package:spendwise/Validators.dart';

// ignore: must_be_immutable
class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  var isLoader = false;
  var authService = AuthService();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      var data = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };
      await authService.loginUser(data, context);
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
        title: Text(
          'Login',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w700, color: TColor.white),
        ),
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _formKey,
                  child: Column(children: [
                    const SizedBox(
                      height: 50,
                    ),
                    LottieBuilder.network(
                      "https://lottie.host/0cfa1d2b-a3b7-4a40-bf27-d35b79d44a92/BldlBKcksB.json",
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black),
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
                      style: const TextStyle(color: Colors.black),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: true,
                      decoration:
                          buildInputDecoration("Password", Icons.password),
                      validator: appValidators.validatePassword,
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Container(
                        height: 50,
                        width: 300,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.amber)),
                            onPressed: _submitForm,
                            child: const Text('Login'))),
                  ])),
            ),
            //google sign in
            // Container(
            //   height: 50,
            //   width: 300,
            //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     style: ButtonStyle(
            //         backgroundColor: MaterialStateProperty.all(TColor.primary)),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(Icons.g_mobiledata, color: TColor.white),
            //         const SizedBox(
            //           width: 10,
            //         ),
            //         Text('Log in with Google',
            //             style: TextStyle(color: TColor.white)),
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
                  "Don't have an account?",
                  style: TextStyle(color: Colors.black),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpView()));
                    },
                    child: Text(
                      "Sign Up",
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

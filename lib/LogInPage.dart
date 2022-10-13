import 'package:chatappfirbase/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'Auth_Service.dart';
import 'Functions.dart';
import 'constants.dart';
import 'Widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'RegisterPage.dart';
import 'Database_Service.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String email = "";
  String password = "";
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffede6ef),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor))
            : SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 70),
                    child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Groupie",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                                "Login now to see what they are talking!",
                                style: TextStyle(
                                    color: Color(0xd2080101),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 15),
                            Image.asset("images/register.png"),
                            const SizedBox(height: 33),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Email",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: primaryColor,
                                  )),
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },

                              // check tha validation
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)
                                    ? null
                                    : "Please Enter A Valid Email";
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              obscureText: true,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Password",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: primaryColor,
                                  )),
                              validator: (val) {
                                if (val!.length < 6) {
                                  return "Password must be at least 6 characters";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: primaryColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  login();
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text.rich(TextSpan(
                                text: "Don't Have An Acount? ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w200),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: " REGISTER HERE ",
                                      style: TextStyle(
                                          color: Color(0xff0a0a0a),
                                          decoration: TextDecoration.underline,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          nextScreen(
                                              context, const RegisterPage());
                                        }),
                                ])),
                          ],
                        ))),
              ));
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences
          await Functions.saveUserLoggedInStatus(true);
          await Functions.saveUserEmail(email);
          await Functions.saveUserFirstName(snapshot.docs[0]['firstName']);
          await Functions.saveUserLastName(snapshot.docs[0]['lastName']);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackBar(context, Colors.purple, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}

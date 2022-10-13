import 'package:chatappfirbase/Auth_Service.dart';
import 'package:chatappfirbase/HomePage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'Functions.dart';
import 'LogInPage.dart';
import 'constants.dart';
import 'Widgets.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String firstName = "";
  String lastName = "";
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 70),
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
                              "Create your account now to chat and explore!",
                              style: TextStyle(
                                  color: Color(0xd2080101),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 15),
                          Image.asset("images/group.png"),
                          const SizedBox(height: 15),
                          TextFormField(
                            //obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                labelText: "First Name",
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: primaryColor,
                                )),
                            validator: (val) {
                              if (val!.isNotEmpty) {
                                return null;
                              } else {
                                return "Name cannot be empty";
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                firstName = val;
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            // obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                labelText: "Last Name",
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: primaryColor,
                                )),
                            validator: (val) {
                              if (val!.isNotEmpty) {
                                return null;
                              } else {
                                return "Name cannot be empty";
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                lastName = val;
                              });
                            },
                          ),
                          const SizedBox(height: 15),
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
                                      borderRadius: BorderRadius.circular(30))),
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                register();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text.rich(TextSpan(
                              text: "Already Have An Account? ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w200),
                              children: <TextSpan>[
                                TextSpan(
                                    text: " LOGIN ",
                                    style: TextStyle(
                                        color: Color(0xff0a0a0a),
                                        decoration: TextDecoration.underline,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(context, const LogInPage());
                                      }),
                              ])),
                        ],
                      ))),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(
              firstName, lastName, email, password)
          .then((value) async {
        if (value == true) {
          await Functions.saveUserLoggedInStatus(true);
          await Functions.saveUserEmail(email);
          await Functions.saveUserFirstName(firstName);
          await Functions.saveUserLastName(lastName);
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

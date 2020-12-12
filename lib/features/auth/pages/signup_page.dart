import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grroom/features/auth/widgets/auth_success.dart';
import 'package:http/http.dart' as http;

import 'forgot_password_page.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _signupFormKey = GlobalKey<FormState>();
  final _client = http.Client();

  final _firstNameController = new TextEditingController();
  final _lastNameController = new TextEditingController();
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();

  bool _isLoading = false;
  String _errorMessage;

  final String _signupEndpoint = "http://134.209.158.65/api/v1/user/signup";
  Future<void> _handleSignup(BuildContext context) async {
    setState(() => _isLoading = true);
    if (_signupFormKey.currentState.validate()) {
      var response = await _client.post(_signupEndpoint, body: {
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
      });

      var decodedRes = json.decode(response.body);
      print(decodedRes);

      if (decodedRes["status"] == "success") {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: AuthSuccess(
                    "Account created successfully",
                    secondaryMessage: "Please Wait for admin approval :)",
                  ),
                )));
      } else {
        setState(() {
          if (decodedRes["message"].contains("E11000")) {
            _errorMessage = "User with this email already exists.";
          }
        });
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    super.dispose();
    _client.close();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: _isLoading
            ? SpinKitDoubleBounce(color: Colors.redAccent)
            : Form(
                key: _signupFormKey,
                child: ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.10,
                    ),
                    Text(
                      "Sign Up",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).textScaleFactor * 40.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    _errorMessage == null
                        ? SizedBox(height: 0)
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Colors.redAccent,
                              elevation: 5.0,
                              shadowColor: Colors.red,
                              child: ListTile(
                                leading: Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  _errorMessage,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: "First Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) =>
                            val.isEmpty ? "Please fill this field" : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) =>
                            val.isEmpty ? "Please fill this field" : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val.isEmpty ||
                                !EmailValidator.validate(_emailController.text)
                            ? "Please fill this field with valid email"
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "password",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => (val.isEmpty || val.length < 8)
                            ? "Please fill this field with min 8 characters"
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton.icon(
                          onPressed: () => _handleSignup(context),
                          icon: Icon(Icons.add),
                          label: Text("Signup")),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton.icon(
                          padding: EdgeInsets.all(12.0),
                          color: Colors.green,
                          onPressed: () => Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  body: LoginPage(),
                                ),
                              )),
                          icon: Icon(
                            Icons.supervised_user_circle,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton.icon(
                          padding: EdgeInsets.all(12.0),
                          color: Colors.green,
                          onPressed: () => Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  body: ForgotPasswordPage(),
                                ),
                              )),
                          icon: Icon(
                            Icons.input,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

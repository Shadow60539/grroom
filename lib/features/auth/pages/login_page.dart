import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grroom/features/auth/pages/signup_page.dart';
import 'package:grroom/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _storage = new FlutterSecureStorage();
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();

  final client = http.Client();
  final String _loginEndpoint = "http://134.209.158.65/api/v1/user/login";

  bool _isLoading = false;
  String _errorMessage;

  Future<void> _handleLogin(BuildContext context) async {
    setState(() => _isLoading = true);
    if (_loginFormKey.currentState.validate()) {
      var response = await client.post(_loginEndpoint, body: {
        "email": _emailController.text,
        "password": _passwordController.text,
      }).catchError((onError) {
        print(onError.toString());
      });

      var decodedRes = json.decode(response.body);
      print(decodedRes);
      if (decodedRes["status"] == "fail") {
        setState(() {
          _errorMessage = decodedRes["message"];
        });
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await _storage.write(key: "token", value: decodedRes["token"]);
        await _storage.write(key: "role", value: decodedRes["data"]["role"]);

        await prefs.setString("email", decodedRes["data"]["email"]);
        await prefs.setString("firstName", decodedRes["data"]["firstName"]);

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: MyHomePage(),
                )));
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    super.dispose();
    client.close();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: _isLoading
            ? SpinKitDoubleBounce(color: Colors.redAccent)
            : Form(
                key: _loginFormKey,
                child: ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    Text(
                      "Log In",
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
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val.isEmpty ||
                                !EmailValidator.validate(_emailController.text)
                            ? "Please enter valid email"
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "password",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val.isEmpty || val.length < 8
                            ? "Please fill this field with min 8 Characters"
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton.icon(
                          onPressed: () => _handleLogin(context),
                          icon: Icon(Icons.input),
                          label: Text("Login")),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton.icon(
                          padding: EdgeInsets.all(12.0),
                          color: Colors.green,
                          onPressed: () => Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  body: SignupPage(),
                                ),
                              )),
                          icon: Icon(
                            Icons.supervised_user_circle,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Create Account",
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

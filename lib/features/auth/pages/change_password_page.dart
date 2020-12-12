import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _passwordController = new TextEditingController();
  final _confirmPasswordController = new TextEditingController();

  final client = http.Client();
  final String _loginEndpoint =
      "http://134.209.158.65/api/v1/user/changepassword";
  bool _isLoading = false;
  String _errorMessage;

  String token;

  final _storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _storage.read(key: "token").then((val) => setState(() => token = val));
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    if (_loginFormKey.currentState.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          _errorMessage = "Passwords didn't match";
          _isLoading = false;
          return;
        });
      }
      var response = await client.post(
        _loginEndpoint,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
        body: {
          "passwordCurrent": _passwordController.text,
          "password": _confirmPasswordController.text,
        },
      );

      var decodedRes = json.decode(response.body);
      print(decodedRes);
      if (decodedRes["status"] == "error") {
        setState(() {
          _errorMessage = "Something went wrong! Try again.";
        });
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
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    Text(
                      "Change Password",
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
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "confirm password",
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
                          onPressed: _handleLogin,
                          icon: Icon(Icons.refresh),
                          label: Text("Change Password")),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

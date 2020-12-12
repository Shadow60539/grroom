import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grroom/features/auth/pages/signup_page.dart';
import 'package:grroom/features/auth/widgets/auth_success.dart';
import 'package:http/http.dart' as http;

import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = new TextEditingController();

  final client = http.Client();
  final String _forgotPasswordEndpoint =
      "http://134.209.158.65/api/v1/user/forgotPassword";
  bool _isLoading = false;
  String _errorMessage;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    if (_loginFormKey.currentState.validate()) {
      // var response = await client.post(_forgotPasswordEndpoint, body: {
      //     "password": _emailController.text,
      //   },
      // );

      // var decodedRes = json.decode(response.body);
      // print(decodedRes);

      // logic for handling the error

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Scaffold(
                body: AuthSuccess("Reset Mail Sent Successfully.",
                    secondaryMessage:
                        "Please check your mail for reset password mail."),
              )));
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
                      "Forgot Password",
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
                      child: RaisedButton.icon(
                          onPressed: _handleLogin,
                          icon: Icon(Icons.mail),
                          label: Text("Send reset password mail")),
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
                                  body: SignupPage(),
                                ),
                              )),
                          icon: Icon(
                            Icons.input,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Create Account",
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

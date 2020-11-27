import 'package:flutter/material.dart';
import 'package:grroom/features/auth/pages/login_page.dart';

class AuthSuccess extends StatelessWidget {
  final String mainMessage;
  final String secondaryMessage;

  AuthSuccess(this.mainMessage, {this.secondaryMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blueAccent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/success.png",
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  mainMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).textScaleFactor * 20),
                ),
              ),
              secondaryMessage == null
                  ? SizedBox()
                  : Text(
                      secondaryMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton.icon(
                    padding: EdgeInsets.all(12.0),
                    color: Colors.green,
                    onPressed: () =>
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Scaffold(
                            body: LoginPage(),
                          ),
                        )),
                    icon: Icon(
                      Icons.input,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ));
  }
}

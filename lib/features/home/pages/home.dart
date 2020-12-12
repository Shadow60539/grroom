import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String token;
  String role;
  String email;
  String firstName;

  final _storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _storage.read(key: "token").then((val) => setState(() => token = val));
    _storage.read(key: "role").then((val) => setState(() => role = val));

    SharedPreferences.getInstance().then((prefs) {
      email = prefs.getString("email");
      firstName = prefs.getString("firstName");
    });
  }

  Future<void> _getInfluencers() async {
    var res = await http.get(
      "http://134.209.158.65/api/v1/meta",
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );

    print(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(token ?? "token"),
          Text(role ?? "role"),
          Text(email ?? "email"),
          Text(firstName ?? "firstName"),
          RaisedButton(
            child: Text("click"),
            onPressed: _getInfluencers,
          )
        ],
      ),
    );
  }
}

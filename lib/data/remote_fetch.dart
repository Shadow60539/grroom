import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grroom/models/influencer.dart';
import 'package:http/http.dart' as http;

class RemoteFetch {
  static Future<List<Influencer>> getAllInfluencers() async {
    String headerToken = await FlutterSecureStorage().read(key: "token");

    String _endpoint = "https://groombackend.herokuapp.com/api/v1/influencer";
    var resp = await http.get(_endpoint,
        headers: {HttpHeaders.authorizationHeader: "Bearer $headerToken"});

    var data = jsonDecode(resp.body)["data"];

    List<Influencer> influencers = [];

    data.forEach((inf) {
      influencers.add(Influencer.fromResp(inf));
    });
    return influencers.reversed.toList();
  }
}

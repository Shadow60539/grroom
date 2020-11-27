import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grroom/models/user.dart';
import 'package:http/http.dart' as http;

class HandleUsersPage extends StatefulWidget {
  @override
  _HandleUsersPageState createState() => _HandleUsersPageState();
}

class _HandleUsersPageState extends State<HandleUsersPage> {
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVmYjBmODc3M2NiOTgzMDAxNzA0MDM5OCIsImlhdCI6MTYwNTg1MTQ3MiwiZXhwIjoxNjEzNjI3NDcyfQ.vDCEocYHHUxtYlwy7mF0Las5gASDkTE0xU02yp2xbH0";
//  eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVmYjBmODc3M2NiOTgzMDAxNzA0MDM5OCIsImlhdCI6MTYwNTg1MTQ3MiwiZXhwIjoxNjEzNjI3NDcyfQ.vDCEocYHHUxtYlwy7mF0Las5gASDkTE0xU02yp2xbH0
  List<UserModel> users = [];
  @override
  void initState() {
    super.initState();
    final storage = FlutterSecureStorage();
    // storage.read(key: "token").then((val) => setState(() => token = val));

    http.get("https://groombackend.herokuapp.com/api/v1/user", headers: {
      HttpHeaders.authorizationHeader: "Bearer $token"
    }).then((value) {
      var resp = jsonDecode(value.body);
      print(resp);
      List<UserModel> tempUsers = [];
      if (resp["status"] == "success") {
        List data = resp["data"];
        data.forEach((_user) {
          if (_user["role"] != "admin") {
            tempUsers.add(UserModel.fromResp(_user));
          }
        });
        setState(() => users = tempUsers);
      } else {
        print("Oops! some error occured");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              elevation: 1,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              stretch: true,
              floating: true,
              expandedHeight: 60,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: null,
                background: InkWell(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white54,
                          size: 16,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Search users',
                          style: TextStyle(
                              color: Colors.white54,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                stretchModes: [
                  StretchMode.zoomBackground,
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                          key: Key(index.toString()),
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                  "${users[index].firstName} ${users[index].lastName}"),
                              subtitle: Text("${users[index].email}"),
                              trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    size: 16,
                                    color: Colors.black26,
                                  ),
                                  onPressed: () {}),
                            ),
                          ),
                          onDismissed: (dir) =>
                              activateUser(dir, users[index].id, index),
                          background: Container(
                            padding: const EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            color: Colors.green[400],
                            child: Row(
                              children: [
                                Text(
                                  'Accept',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                          secondaryBackground: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Reject',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ],
                            ),
                            color: Colors.red[500],
                          ));
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> activateUser(DismissDirection dir, String id, int index) async {
    if (dir == DismissDirection.startToEnd) {
      var resp = await http.patch(
          "https://groombackend.herokuapp.com/api/v1/user/$id",
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

      print(resp.body);
      var data = jsonDecode(resp.body);
      if (data["status"] == "success") {
        print("success");
      } else {
        print(data);
      }
    }
  }
}

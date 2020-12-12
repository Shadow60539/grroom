import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grroom/data/remote_fetch.dart';
import 'package:grroom/features/stylist/pages/handle_stylist_page.dart';
import 'package:grroom/models/stylist.dart';
import 'package:grroom/models/user.dart';
import 'package:http/http.dart' as http;

class HandleUsersPage extends StatefulWidget {
  @override
  _HandleUsersPageState createState() => _HandleUsersPageState();
}

class _HandleUsersPageState extends State<HandleUsersPage> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVmYjBmODc3M2NiOTgzMDAxNzA0MDM5OCIsImlhdCI6MTYwNTg1MTQ3MiwiZXhwIjoxNjEzNjI3NDcyfQ.vDCEocYHHUxtYlwy7mF0Las5gASDkTE0xU02yp2xbH0";
//  eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVmYjBmODc3M2NiOTgzMDAxNzA0MDM5OCIsImlhdCI6MTYwNTg1MTQ3MiwiZXhwIjoxNjEzNjI3NDcyfQ.vDCEocYHHUxtYlwy7mF0Las5gASDkTE0xU02yp2xbH0
  List<UserModel> allUsers = [];
  List<UserModel> verifiedUsers = [];
  List<UserModel> deletedUsers = [];
  bool isLoading = false;

  Future<void> getToken() async {
    token = await FlutterSecureStorage().read(key: 'token');
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
    // getToken();
    // storage.read(key: "token").then((val) => setState(() => token = val));
  }

  _getUsers() {
    http.get("http://134.209.158.65/api/v1/user", headers: {
      HttpHeaders.authorizationHeader: "Bearer $token"
    }).then((value) {
      var resp = jsonDecode(value.body);
      List<UserModel> tempUsers = [];
      if (resp["status"] == "success") {
        List data = resp["data"];
        data.forEach((_user) {
          if (_user["role"] != "admin") {
            tempUsers.add(UserModel.fromResp(_user));
          }
        });
        setState(() => allUsers = tempUsers);
        verifiedUsers = allUsers.where((e) => e.isVerified).toList();
        // deletedUsers = allUsers.where((e) => e.isDeleted).toList();
      } else {
        print("Oops! some error occured");
      }
    });
  }

  Widget listBody(
      {List<UserModel> users, bool showDelete, bool showDismissible}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        if (showDismissible) {
          return Dismissible(
              key: Key(index.toString()),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: users[index].isVerified
                        ? Colors.green.withOpacity(0.1)
                        : Colors.black12),
                child: Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 2)),
                  color: users[index].isVerified
                      ? Colors.green.withOpacity(0.5)
                      : Colors.black12,
                  elevation: 2,
                  child: ListTile(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      List<Stylist> stylists =
                          await RemoteFetch.getParticularMeta(
                              id: users[index].id);

                      setState(() {
                        isLoading = false;
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HandleStylistPage(
                            stylistsList: stylists,
                          ),
                        ),
                      );
                    },
                    title: Text(
                      "${users[index].firstName} ${users[index].lastName}",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "${users[index].email}",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: showDelete
                        ? IconButton(
                            icon: Icon(
                              Icons.delete,
                              size: 16,
                              color: Colors.black26,
                            ),
                            onPressed: () {
                              deleteUser(users[index].id, index);
                            })
                        : OutlineButton(
                            onPressed: () {
                              restoreUser(users[index].id, index);
                            },
                            child: Text(
                              'Restore',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                          ),
                  ),
                ),
              ),
              onDismissed: (dir) => activateUser(dir, users[index].id, index),
              background: Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                color: Colors.green[400],
                child: Row(
                  children: [
                    Text(
                      'Accept',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
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
                          color: Colors.white, fontWeight: FontWeight.w300),
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
        } else {
          return DecoratedBox(
            decoration: BoxDecoration(
                color: users[index].isVerified
                    ? Colors.green.withOpacity(0.1)
                    : Colors.black12),
            child: Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 2)),
              color: users[index].isVerified
                  ? Colors.green.withOpacity(0.5)
                  : Colors.black12,
              elevation: 2,
              child: ListTile(
                title: Text(
                  "${users[index].firstName} ${users[index].lastName}",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  "${users[index].email}",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: showDelete
                    ? IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: 16,
                          color: Colors.black26,
                        ),
                        onPressed: () {
                          deleteUser(users[index].id, index);
                        })
                    : OutlineButton(
                        onPressed: () {
                          restoreUser(users[index].id, index);
                        },
                        child: Text(
                          'Restore',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          key: key,
          body: Stack(
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    expandedHeight: 100,
                    flexibleSpace: FlexibleSpaceBar(
                      background: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.black),
                        child: TabBar(
                          indicatorColor: Colors.white,
                          tabs: [
                            Tab(
                              text: "All users",
                            ),
                            Tab(
                              text: "Verified Users",
                            ),
                            Tab(
                              text: "Not-verified Users",
                            ),
                            Tab(
                              text: "Deleted Users",
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        listBody(
                            users: allUsers,
                            showDelete: true,
                            showDismissible: true),
                        listBody(
                            users: verifiedUsers,
                            showDelete: true,
                            showDismissible: false),
                        listBody(
                            users: allUsers
                                .where((element) => !element.isVerified)
                                .toList(),
                            showDelete: true,
                            showDismissible: false),
                        listBody(
                            users: allUsers
                                .where((element) => element.isDeleted)
                                .toList(),
                            showDelete: false,
                            showDismissible: false),
                      ],
                    ),
                  ),
                ],
              ),
              isLoading
                  ? Container(
                      color: Colors.black12,
                      child: SpinKitPouringHourglass(
                        color: Colors.black87,
                        size: 20,
                      ),
                    )
                  : SizedBox.shrink()
            ],
          )),
    );
  }

  Future<void> activateUser(DismissDirection dir, String id, int index) async {
    var resp =
        await http.patch("http://134.209.158.65/api/v1/user/$id", headers: {
      HttpHeaders.authorizationHeader: "Bearer $token"
    }, body: {
      'isVerified': dir == DismissDirection.startToEnd ? 'true' : 'false',
    });

    var data = jsonDecode(resp.body);
    if (data["status"] == "success") {
      print("success");
      setState(() {
        _getUsers();
      });
      key.currentState.showSnackBar(SnackBar(
          content: Text(dir == DismissDirection.startToEnd
              ? 'User verified'
              : 'User rejected')));
    } else {
      print(data);
    }
  }

  Future<void> deleteUser(String id, int index) async {
    var resp =
        await http.patch("http://134.209.158.65/api/v1/user/$id", headers: {
      HttpHeaders.authorizationHeader: "Bearer $token"
    }, body: {
      'isDeleted': 'true',
    });

    var data = jsonDecode(resp.body);
    if (data["status"] == "success") {
      print("success");
      setState(() {
        _getUsers();
      });
      key.currentState.showSnackBar(SnackBar(content: Text('User deleted')));
    } else {
      print(data);
    }
  }

  Future<void> restoreUser(String id, int index) async {
    var resp =
        await http.patch("http://134.209.158.65/api/v1/user/$id", headers: {
      HttpHeaders.authorizationHeader: "Bearer $token"
    }, body: {
      'isDeleted': 'false',
    });

    var data = jsonDecode(resp.body);
    if (data["status"] == "success") {
      print("success");

      _getUsers();
      key.currentState.showSnackBar(SnackBar(content: Text('User restored')));
    } else {
      print(data);
    }
  }
}

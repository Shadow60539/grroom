import 'dart:async';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grroom/data/remote_fetch.dart';
import 'package:grroom/features/admin/pages/handle_users_page.dart';
import 'package:grroom/features/influencer/pages/handle_influencers_page.dart';
import 'package:grroom/features/stylist/pages/handle_stylist_page.dart';
import 'package:grroom/features/stylist/pages/stylist_page.dart';
import 'package:grroom/models/influencer.dart';
import 'package:grroom/models/stylist.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  const IndexPage();
  @override
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  final ValueNotifier<int> pageNumberNotifier = ValueNotifier<int>(0);
  DateTime currentBackPressTime;
  Future _future;
  bool isAdmin = false;

  final ScrollController scrollController = ScrollController();

  List<Widget> _widgets(
          {ScrollController scrollController,
          List<Influencer> influencersList,
          List<Stylist> stylistsList}) =>
      <Widget>[
        HandleInfluencersPage(
          scrollController: scrollController,
          influencersList: influencersList,
        ),
        HandleStylistPage(
          scrollController: scrollController,
          stylistsList: stylistsList,
        ),
      ];

  @override
  void initState() {
    super.initState();
    FlutterSecureStorage().read(key: 'role').then((value) {
      setState(() {
        isAdmin = value == 'admin';
      });
    });
  }

  @override
  void didChangeDependencies() {
    _future = Future.wait([
      RemoteFetch.getAllInfluencers(),
      RemoteFetch.getAllStylists(),
      RemoteFetch.getConstants(
          provider: Provider.of<AllProvider>(context, listen: false))
    ]);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
    pageNumberNotifier.dispose();
  }

  void _selectedTab(int index) {
    Provider.of<AllProvider>(context, listen: false)
        .updateBottomNavigationIndex(index);
    if (pageNumberNotifier.value == index) {
      scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      pageNumberNotifier.value = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (pageNumberNotifier.value != 0) {
          pageNumberNotifier.value = 0;
          return false;
        } else {
          scrollController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );

          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime) > Duration(seconds: 2)) {
            currentBackPressTime = now;
            showFlash(
                onWillPop: () async {
                  return true;
                },
                duration: Duration(seconds: 2),
                context: context,
                builder: (context, controller) => Flash(
                      controller: controller,
                      backgroundColor: Colors.black87,
                      borderRadius: BorderRadius.circular(8.0),
                      style: null,
                      position: null,
                      alignment: Alignment.center,
                      enableDrag: false,
                      onTap: () => controller.dismiss(),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Press again to exit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ));
            return Future.value(false);
          }
          return Future.value(true);
        }
      },
      child: FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return ValueListenableBuilder(
              key: UniqueKey(),
              valueListenable: pageNumberNotifier,
              builder: (BuildContext context, int value, Widget child) {
                return SafeArea(
                  child: Scaffold(
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.miniStartFloat,
                    floatingActionButton: isAdmin
                        ? FloatingActionButton(
                            heroTag: UniqueKey(),
                            mini: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.black87,
                            child: FaIcon(
                              FontAwesomeIcons.userGraduate,
                              size: 12,
                            ),
                            onPressed: () =>
                                Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return HandleUsersPage();
                                  },
                                  transitionsBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation,
                                      Widget child) {
                                    return SlideTransition(
                                      position: new Tween<Offset>(
                                        begin: const Offset(0.0, 1.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeIn)),
                                      child: child,
                                    );
                                  },
                                )))
                        : null,
                    body: !snapshot.hasData
                        ? SpinKitPouringHourglass(
                            color: Colors.black87,
                            size: 20,
                          )
                        : Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              IndexedStack(
                                index: pageNumberNotifier.value,
                                children: _widgets(
                                    scrollController: scrollController,
                                    stylistsList: snapshot.data[1],
                                    influencersList: snapshot.data[0]),
                              ),
                              Container(
                                height: kBottomNavigationBarHeight,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 80)
                                        .copyWith(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(500),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(500),
                                  child: BottomNavigationBar(
                                    backgroundColor: Colors.black87,
                                    items: <BottomNavigationBarItem>[
                                      BottomNavigationBarItem(
                                        backgroundColor: Colors.white,
                                        icon: FaIcon(
                                          FontAwesomeIcons.userCircle,
                                          size: 18,
                                          color: pageNumberNotifier.value == 0
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            'Influencer',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color:
                                                  pageNumberNotifier.value == 0
                                                      ? Colors.white
                                                      : Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      BottomNavigationBarItem(
                                        backgroundColor: Colors.white,
                                        icon: FaIcon(
                                          FontAwesomeIcons.userAlt,
                                          size: 18,
                                          color: pageNumberNotifier.value == 1
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            'Data',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color:
                                                  pageNumberNotifier.value == 1
                                                      ? Colors.white
                                                      : Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                    currentIndex: value,
                                    fixedColor: Colors.redAccent,
                                    onTap: _selectedTab,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              });
        },
      ),
    );
  }
}

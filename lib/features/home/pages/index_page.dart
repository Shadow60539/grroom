import 'dart:async';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grroom/features/influencer/pages/handle_influencers_page.dart';
import 'package:grroom/features/stylist/pages/handle_stylist_page.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  const IndexPage();
  @override
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> with TickerProviderStateMixin {
  IndexPageState();
  Future<void> setPage(int page) async {
    pageNumberNotifier.value = page;
  }

  final ValueNotifier<int> pageNumberNotifier = ValueNotifier<int>(0);
  DateTime currentBackPressTime;

  final ScrollController scrollController = ScrollController();

  List<Widget> _widgets({ScrollController scrollController}) => <Widget>[
        HandleStylistPage(),
        HandleInfluencersPage(
          scrollController: scrollController,
        ),
      ];

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
      child: ValueListenableBuilder(
          key: UniqueKey(),
          valueListenable: pageNumberNotifier,
          builder: (BuildContext context, int value, Widget child) {
            return SafeArea(
              child: Scaffold(
                body: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    IndexedStack(
                      index: pageNumberNotifier.value,
                      children: _widgets(scrollController: scrollController),
                    ),
                    Transform.translate(
                      offset: Offset(-20, 0),
                      child: Container(
                        height: kBottomNavigationBarHeight,
                        margin: const EdgeInsets.symmetric(horizontal: 50)
                            .copyWith(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: BottomNavigationBar(
                            backgroundColor: Colors.black87,
                            items: <BottomNavigationBarItem>[
                              BottomNavigationBarItem(
                                backgroundColor: Colors.white,
                                icon: FaIcon(
                                  FontAwesomeIcons.userAlt,
                                  size: 18,
                                  color: pageNumberNotifier.value == 0
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Stylist',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: pageNumberNotifier.value == 0
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
                                  FontAwesomeIcons.userCircle,
                                  size: 18,
                                  color: pageNumberNotifier.value == 1
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Influencer',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: pageNumberNotifier.value == 1
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
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

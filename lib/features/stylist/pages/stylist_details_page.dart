import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grroom/features/stylist/pages/edit_stylist_page.dart';
import 'package:grroom/models/stylist.dart';

class StylistDetailsPage extends StatefulWidget {
  final Stylist stylist;
  const StylistDetailsPage({this.stylist});

  @override
  _StylistDetailsPageState createState() => _StylistDetailsPageState();
}

class _StylistDetailsPageState extends State<StylistDetailsPage> {
  @override
  Widget build(BuildContext context) {
    Widget tablechild({String title, subtitle, String gender}) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              gender == null
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          gender == 'Female'
                              ? 'https://icons.iconarchive.com/icons/custom-icon-design/flatastic-7/512/Female-icon.png'
                              : 'https://icons.iconarchive.com/icons/custom-icon-design/flatastic-7/256/Male-icon.png',
                          height: 12,
                          width: 12,
                        ),
                        SizedBox(
                          width: 5,
                        )
                      ],
                    ),
              Text(
                title,
                style: TextStyle(
                    fontSize: 16, color: Colors.black.withOpacity(0.7)),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context)),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 100),
              padding: const EdgeInsets.only(
                  top: 150, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, spreadRadius: 1, blurRadius: 10)
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2),
                    topRight: Radius.circular(2),
                  )),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Text(
                    '5fbc9f0bb650340b207a2183',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.locationArrow,
                        color: Colors.black26,
                        size: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'India',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Stack(
                    alignment: Alignment.topCenter,
                    overflow: Overflow.visible,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20)
                            .copyWith(top: 50),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 0,
                                  blurRadius: 4)
                            ],
                            borderRadius: BorderRadius.circular(5)),
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            tablechild(
                                title: 'Cocktail Party, Costume, Trekking',
                                subtitle: 'Events'),
                            Divider(
                              indent: 50,
                              endIndent: 50,
                            ),
                            tablechild(title: 'Formal', subtitle: 'Style'),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -15,
                        child: Image.asset(
                          'assets/star.png',
                          height: 30,
                          width: 30,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Stack(
                    overflow: Overflow.visible,
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20)
                            .copyWith(top: 50),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 0,
                                  blurRadius: 4)
                            ],
                            borderRadius: BorderRadius.circular(5)),
                        child: Wrap(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            tablechild(
                                title: 'Summer, Winter', subtitle: 'Season'),
                            Divider(
                              indent: 50,
                              endIndent: 50,
                            ),
                            tablechild(title: 'Good', subtitle: 'Type'),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -15,
                        child: Image.asset(
                          'assets/star.png',
                          height: 30,
                          width: 30,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 0),
                  height: 200,
                  width: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1000)),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: Image.network(
                          'https://cdn.dribbble.com/users/1958940/screenshots/14068382/media/0fd6ec812bbcc346f6a140d3b45e2877.png',
                          height: 190,
                          width: 190,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 10)
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 150,
                  child: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                        splashRadius: 25,
                        icon: FaIcon(
                          FontAwesomeIcons.userEdit,
                          size: 12,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return Scaffold(
                                    appBar: AppBar(
                                      automaticallyImplyLeading: false,
                                      leading: IconButton(
                                        icon: Icon(Icons.arrow_back_ios,
                                            size: 16),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      backgroundColor: Colors.black87,
                                      title: Text(
                                        'Edit Stylist',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    body: EditStylistPage(),
                                  );
                                },
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: new Tween<Offset>(
                                        begin: const Offset(-1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeIn)),
                                      child: child,
                                    ),
                                  );
                                },
                              ));
                        }),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

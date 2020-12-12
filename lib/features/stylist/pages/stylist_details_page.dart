import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grroom/core/globals.dart';
import 'package:grroom/features/influencer/pages/full_screen_image_page.dart';
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
    final Stylist stylist = widget.stylist;
    Widget tablechild({String title, subtitle, String gender}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              gender == null
                  ? Container()
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                    stylist.influencerId,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  stylist.place == ''
                      ? Text('')
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.locationArrow,
                              color: stylist.place == null
                                  ? Colors.white
                                  : Colors.black26,
                              size: 16,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              stylist.place,
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
                        alignment: Alignment.center,
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
                                title: stylist.events
                                    .join(",\n\n\u2022 ")
                                    .replaceFirst('', '\u2022 '),
                                subtitle: 'Events'),
                            Divider(
                              indent: 50,
                              endIndent: 50,
                            ),
                            tablechild(
                                title:
                                    '${stylist.style.category} : ${stylist.style.value.join(",")}',
                                subtitle: 'Style'),
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
                                title: stylist.season.join(","),
                                subtitle: 'Season'),
                            Divider(
                              indent: 50,
                              endIndent: 50,
                            ),
                            tablechild(title: stylist.type, subtitle: 'Type'),
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
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return FullScreenImagePreview(
                                      img: stylist.image,
                                      animation: animation,
                                    );
                                  },
                                  transitionDuration:
                                      const Duration(milliseconds: 200),
                                  transitionsBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation,
                                      Widget child) {
                                    return SlideTransition(
                                      position: new Tween<Offset>(
                                        begin: const Offset(-1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeIn)),
                                      child: child,
                                    );
                                  },
                                ));
                          },
                          child: Hero(
                            tag: stylist.image,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: CachedNetworkImage(
                                imageUrl: stylist.image,
                                height: 190,
                                width: 190,
                                fit: BoxFit.contain,
                                errorWidget: (context, url, error) {
                                  return Image.asset('assets/no_image.jpg');
                                },
                              ),
                            ),
                          ),
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
                                  return EditStylistPage(
                                    stylist: stylist,
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

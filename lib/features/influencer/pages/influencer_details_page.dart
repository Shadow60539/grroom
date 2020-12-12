import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grroom/features/influencer/pages/edit_influencer_page.dart';
import 'package:grroom/features/influencer/pages/full_screen_image_page.dart';
import 'package:grroom/models/influencer.dart';
import 'package:url_launcher/url_launcher.dart';

class InfluencerDetailsPage extends StatefulWidget {
  final Influencer influencer;
  InfluencerDetailsPage({@required this.influencer});

  @override
  _InfluencerDetailsPageState createState() => _InfluencerDetailsPageState();
}

class _InfluencerDetailsPageState extends State<InfluencerDetailsPage> {
  bool isAdmin = false;
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
  Widget build(BuildContext context) {
    final Influencer influencer = widget.influencer;
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

    _launchURL() async {
      final url = influencer.igProfileLink;
      if (await canLaunch(url)) {
        await launch(url, enableJavaScript: true);
      } else {
        print('url cannot be launched');
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          elevation: 0,
          actions: [
            IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.instagram,
                  color: Colors.white,
                ),
                onPressed: () {
                  _launchURL();
                })
          ],
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context)),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black87, Colors.black54]),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 180),
                    padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 1,
                              blurRadius: 10)
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        )),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 30, top: 130),
                      children: [
                        Text(
                          '${influencer.firstName} ${influencer.lastName}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black54),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.locationArrow,
                              size: 14,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              influencer.country,
                              style: GoogleFonts.nunito(color: Colors.black54),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://www.transparentpng.com/thumb/instagram-logo-icon/yVnfo1-instagram-logo-photo-icon.png',
                              height: 15,
                              width: 15,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              influencer.igUsername,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              '${influencer.noOfFollower} followers',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                      title: influencer.bodyShape.gender,
                                      subtitle: 'Gender'),
                                  Divider(
                                    indent: 50,
                                    endIndent: 50,
                                  ),
                                  tablechild(
                                      title: influencer.undertone,
                                      subtitle: 'Undertone'),
                                  Divider(
                                    indent: 50,
                                    endIndent: 50,
                                  ),
                                  tablechild(
                                      title: influencer.bodyShape.shape,
                                      subtitle: 'Bodyshape'),
                                  Divider(
                                    indent: 50,
                                    endIndent: 50,
                                  ),
                                  tablechild(
                                      title: influencer.bodySize ?? 'Bodyshape',
                                      subtitle: 'Bodysize'),
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
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 80),
                        height: 200,
                        width: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1000)),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double>
                                              secondaryAnimation) {
                                        return FullScreenImagePreview(
                                          img: influencer.image,
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
                                tag: influencer.id,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(1000),
                                  child: CachedNetworkImage(
                                    imageUrl: influencer.image,
                                    errorWidget: (context, url, error) {
                                      return Image.asset('assets/no_image.jpg');
                                    },
                                    height: 190,
                                    width: 190,
                                    fit: BoxFit.contain,
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
                      isAdmin
                          ? Positioned(
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
                                                Animation<double>
                                                    secondaryAnimation) {
                                              return EditInfluencerPage(
                                                influncer: influencer,
                                              );
                                            },
                                            transitionsBuilder:
                                                (BuildContext context,
                                                    Animation<double> animation,
                                                    Animation<double>
                                                        secondaryAnimation,
                                                    Widget child) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: SlideTransition(
                                                  position: new Tween<Offset>(
                                                    begin:
                                                        const Offset(-1.0, 0.0),
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
                          : SizedBox.shrink()
                    ],
                  ),
                  Text(
                    '${influencer.speciality}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        color: Colors.white70,
                        fontSize: 30,
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

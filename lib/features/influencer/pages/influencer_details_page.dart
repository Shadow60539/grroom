import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grroom/features/influencer/pages/edit_influencer_page.dart';
import 'package:grroom/models/influencer.dart';
import 'package:url_launcher/url_launcher.dart';

class InfluencerDetailsPage extends StatefulWidget {
  final Influencer influencer;
  InfluencerDetailsPage({@required this.influencer});

  @override
  _InfluencerDetailsPageState createState() => _InfluencerDetailsPageState();
}

class _InfluencerDetailsPageState extends State<InfluencerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final Influencer influencer = widget.influencer;

    Widget tablechild({String title, subtitle, String gender}) {
      return Column(
        children: [
          Row(
            children: [
              gender == null
                  ? Container()
                  : Row(
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
          Spacer(),
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

    return GestureDetector(
      onTap: () => print(influencer.bodyShape),
      child: SafeArea(
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Text(
                      'I\'m  ${influencer.speciality}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          color: Colors.white70,
                          fontSize: 30,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 180),
                          padding: const EdgeInsets.only(
                              top: 0, left: 20, right: 20),
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
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Positioned(
                                top: 20,
                                right: 10,
                                child: Row(
                                  children: [
                                    Text(
                                      '${influencer.country}n',
                                      style: GoogleFonts.nunito(
                                          color: Colors.black54),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Flag(
                                      'in',
                                      height: 15,
                                      width: 15,
                                    ),
                                  ],
                                ),
                              ),
                              ListView(
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.only(bottom: 30, top: 130),
                                shrinkWrap: true,
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
                                    height: 8,
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
                                            fontSize: 14,
                                            color: Colors.black54),
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
                                            fontSize: 14,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: 70,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              spreadRadius: 0,
                                              blurRadius: 4)
                                        ],
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        tablechild(
                                            title: influencer.undertone,
                                            subtitle: 'Under Tone'),
                                        VerticalDivider(),
                                        tablechild(
                                            title: influencer.bodyShape[0]
                                                    ['shape'] ??
                                                'Rectangle',
                                            subtitle: 'Body Shape',
                                            gender: influencer.bodyShape[0]
                                                    ['gender'] ??
                                                'Male'),
                                        VerticalDivider(),
                                        tablechild(
                                            title: influencer.bodySize,
                                            subtitle: 'Body Size'),
                                      ],
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
                              margin: const EdgeInsets.only(top: 80),
                              height: 200,
                              width: 200,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(1000)),
                                  ),
                                  Hero(
                                    tag: influencer.id,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1000),
                                      child: Image.network(
                                        influencer.image,
                                        height: 190,
                                        width: 190,
                                        fit: BoxFit.cover,
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
                                                Animation<double>
                                                    secondaryAnimation) {
                                              return Scaffold(
                                                appBar: AppBar(
                                                  backgroundColor:
                                                      Colors.black87,
                                                  title: Text(
                                                    'Edit Influencer',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                body: EditInfluencerPage(
                                                  influncer: influencer,
                                                ),
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
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class StylistScreen extends StatefulWidget {
  @override
  _StylistScreenState createState() => _StylistScreenState();
}

class _StylistScreenState extends State<StylistScreen> {
  List<Map<String, dynamic>> influencers;
  final storage = FlutterSecureStorage();
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVmYjBmODc3M2NiOTgzMDAxNzA0MDM5OCIsImlhdCI6MTYwNTg1MTQ3MiwiZXhwIjoxNjEzNjI3NDcyfQ.vDCEocYHHUxtYlwy7mF0Las5gASDkTE0xU02yp2xbH0";
  @override
  void initState() {
    super.initState();
    // storage.read(key: "token").then((value) => setState(() => token = value));
    http.get("http://134.209.158.65/api/v1/meta", headers: {
      HttpHeaders.authorizationHeader: "Bearer $token"
    }).then((value) => print(value.body));
    setState(() {
      influencers = [
        {
          "image_url": "assets/designer.jpg",
          "seasons": <String>[],
          "type": null,
          "events": <String>[],
          "mainStyle": null,
          "subStyle": null,
        },
        {
          "image_url": "assets/designer-men.jpg",
          "seasons": <String>[],
          "type": null,
          "events": <String>[],
          "mainStyle": null,
          "subStyle": null,
        }
      ];
    });
  }

  List<String> _seasonOptions = ["summer", "winter", "autumn", "spring"];

  List<String> _mainStyles = ["Formal", "Casual", "Sportwear"];
  Map<String, List<String>> _styleOptions = {
    "Formal": <String>[
      "Office wear",
      "Bussiness Casual",
      "Evening Formal",
      "Semi Formal",
      "Neautral / Androgynous"
    ],
    "Casual": <String>[
      "Smart Casual",
      "Streetwear",
      "Boho chic",
      "Girly",
      "Retro",
      "Evening casual",
      "Resort",
      "Neutral / Androgynous"
    ],
    "Sportwear": <String>[
      "Athleisure",
      "Yoga clothic",
      "Swimwear / beach",
      "Gym wear",
      "Neutral / Androgynous"
    ]
  };

  List<String> _typesOptions = ["Basic", "Good", "Experimental"];
  List<String> _mainEvents = [
    "Formal Interview",
    "Semi Formal Office",
    "College Casual",
    "Airport Casual Chic",
    "Cocktail Party",
    "Birthday Party",
    "Weddign Party",
    "Gymming",
    "Beachwear",
    "Trekking",
    "Costume",
    "Fashion Week",
    "Prom",
    "Golf",
    "Hip Hop",
    "Masquerade"
  ];
  Map<String, List<String>> _eventOptions = {
    "Formal Interview": <String>[
      "Meetings",
      "Conference",
      "Convocation",
      "Interview",
      "Presentations",
      "State Dinner",
      "Co-operate Dinners"
    ],
    "Semi Formal Office": <String>[
      "Office",
      "Guest Lectures",
      "National Award Show",
      "Political Meet and Greet",
      "Jury",
      "Farewell",
      "Office Party",
      "Product Lauch",
      "Seminars",
      "Exhibitions",
      "Auctions",
      "Racegoers",
      "Parent's Meet",
      "Debates",
      "Chat Show",
      "Openings",
      "Symposium",
      "Art Show",
      "Trade Shows",
      "Business Travel"
    ],
    "College Casual": <String>[
      "Shopping",
      "College",
      "outings",
      "Picnic",
      "Travelling",
      "Long Drives",
      "Going to Cafes",
      "Brunch",
      "Breakfast",
      "Theme Parks",
      "Rally March",
      "Flash Mob",
      "Going for Movie",
      "Safari",
      "Informal Meetups",
      "Get Together",
      "Family Gatherings",
      "Salon Visits",
      "Meetups",
      "Re-union",
      "Site Visit",
      "Cards Party",
      "Game Night Party",
      "Karaoke Party",
    ],
    "Airport Casual Chic": <String>[
      "Vacations",
      "Stadiums",
      "Airports",
      "Resort Wear",
      "Charity Work",
      "Wine Tasting",
      "Workshops",
      "Networking Evemts",
      "Tea Party",
    ],
    "Cocktail Party": <String>["Cocktail Party"],
    "Birthday Party": <String>[
      "College Fest",
      "Concerts",
      "First Dates",
      "Dates",
      "Birthday Party",
      "Valentines Party",
      "Freshers Party",
      "Farewell Party",
      "Women's Party",
      "New Year Eve Party",
      "Bachelor's Party",
      "Bachelorette Party",
      "Date Night",
      "Bridal Shower",
    ],
    "Wedding Party": <String>[
      "Wedding Party",
      "Engagement Party",
      "Reception Party",
      "Wedding Anniversary",
      "Holi Party",
      "Diwali Party",
      "Festive Party",
    ],
    "Gymming": <String>["Gymming", "Jogging", "Cycling", "Yoga", "Zumba"],
    "Beachwear": <String>["Pool Party", "Beach Wear"],
    "Trekking": <String>[
      "Trekking",
      "Adventure Activity",
      "Sports Activity",
      "Dance Rehearsals"
    ],
    "Costume": <String>["Costume Party", "Halloween Party"],
    "Fashion Week": <String>["Fashion Week", "Award Night"],
    "Prom": <String>["Prom Night", "Dall (Dance Party)"],
    "Golf": <String>["Golf Events"],
    "Hip Hop": <String>["Hip Hop Dance"],
    "Masquerade": <String>["Masquerade"],
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CarouselSlider.builder(
            itemCount: influencers.length,
            itemBuilder: (BuildContext context, int itemIndex) {
              Map<String, dynamic> _influencer = influencers[itemIndex];

              var _image = Image.asset(
                _influencer["image_url"],
                height: MediaQuery.of(context).size.height * 0.8,
              );

              var _seasons = ExpansionTile(
                title: Text("Seasons"),
                subtitle: influencers[itemIndex]["seasons"].length == 0
                    ? null
                    : Text(influencers[itemIndex]["seasons"].join(", ")),
                children: [
                  ChipsChoice<String>.multiple(
                    wrapped: true,
                    value: influencers[itemIndex]["seasons"],
                    choiceItems: C2Choice.listFrom<String, String>(
                      source: _seasonOptions,
                      value: (i, v) => v,
                      label: (i, v) => v,
                      style: (index, item) {
                        return C2ChoiceStyle(
                          borderRadius: BorderRadius.circular(0),
                        );
                      },
                    ),
                    onChanged: (val) =>
                        setState(() => influencers[itemIndex]["seasons"] = val),
                  ),
                ],
              );

              var _styles = ExpansionTile(
                title: Text("Styles"),
                subtitle: Text(
                    "${influencers[itemIndex]["mainStyle"] ?? ""} ${influencers[itemIndex]["subStyle"] ?? ""}"),
                children: [
                  ChipsChoice<String>.single(
                    wrapped: true,
                    value: influencers[itemIndex]["mainStyle"],
                    onChanged: (val) => setState(
                        () => influencers[itemIndex]["mainStyle"] = val),
                    choiceItems: C2Choice.listFrom(
                      source: _mainStyles,
                      value: (i, v) => v,
                      label: (i, v) => v,
                    ),
                  ),
                  influencers[itemIndex]["mainStyle"] == null
                      ? SizedBox(height: 0)
                      : ChipsChoice<String>.single(
                          wrapped: true,
                          value: influencers[itemIndex]["subStyle"],
                          onChanged: (val) => setState(
                              () => influencers[itemIndex]["subStyle"] = val),
                          choiceItems: C2Choice.listFrom(
                              source: _styleOptions[influencers[itemIndex]
                                  ["mainStyle"]],
                              value: (i, v) => v,
                              label: (i, v) => v),
                        )
                ],
              );

              var _events = ExpansionTile(
                title: Text("Events"),
                subtitle: influencers[itemIndex]["events"].length == 0
                    ? null
                    : Text(influencers[itemIndex]["events"].join(", ")),
                children: [
                  ChipsChoice<String>.multiple(
                    wrapped: true,
                    value: influencers[itemIndex]["events"],
                    onChanged: (val) =>
                        setState(() => influencers[itemIndex]["events"] = val),
                    choiceItems: C2Choice.listFrom(
                      source: _mainEvents,
                      value: (i, v) => v,
                      label: (i, v) => v,
                    ),
                  ),
                ],
                maintainState: true,
              );

              var _types = ExpansionTile(
                title: Text("Type"),
                subtitle: Text(influencers[itemIndex]["type"] ?? ""),
                children: [
                  ChipsChoice<String>.single(
                      wrapped: true,
                      value: influencers[itemIndex]["type"],
                      onChanged: (val) =>
                          setState(() => influencers[itemIndex]["type"] = val),
                      choiceItems: C2Choice.listFrom(
                        source: _typesOptions,
                        value: (i, v) => v,
                        label: (i, v) => v,
                      ))
                ],
              );

              return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        sliver: SliverSafeArea(
                          top: false,
                          sliver: SliverAppBar(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            automaticallyImplyLeading: false,
                            forceElevated: innerBoxIsScrolled,
                            stretch: true,
                            titleSpacing: -5,
                            pinned: true,
                            snap: true,
                            floating: true,
                            expandedHeight: _image.height,
                            flexibleSpace: FlexibleSpaceBar(background: _image),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        _seasons,
                        _styles,
                        _events,
                        _types,
                        Center(
                          child: RaisedButton.icon(
                              onPressed: () async {
                                await _saveInfluencer(itemIndex);
                              },
                              icon: Icon(Icons.save),
                              label: Text("Save")),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ));
            },
            options: CarouselOptions(
                viewportFraction: 1,
                height: MediaQuery.of(context).size.height)),
      ),
    );
  }

  Future<void> _saveInfluencer(int index) {
    print("saved influencer");
  }
}

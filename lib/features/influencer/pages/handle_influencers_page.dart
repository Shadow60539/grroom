import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grroom/models/influencer.dart';
import 'package:http/http.dart' as http;

import 'influencer_details_page.dart';
import 'influencer_page.dart';

class HandleInfluencersPage extends StatefulWidget {
  final ScrollController scrollController;

  const HandleInfluencersPage({Key key, this.scrollController})
      : super(key: key);
  @override
  _HandleInfluencersPageState createState() => _HandleInfluencersPageState();
}

class _HandleInfluencersPageState extends State<HandleInfluencersPage>
    with SingleTickerProviderStateMixin {
  final storage = FlutterSecureStorage();
  String token;
  AnimationController topAnimationController;
  Animation topAnimation;

  @override
  void initState() {
    topAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward()
      ..repeat();
    topAnimation = Tween(begin: Offset(0, -0.1), end: Offset.zero).animate(
        CurvedAnimation(
            parent: topAnimationController, curve: Curves.easeOutExpo));
    storage.read(key: "token").then((val) => setState(() => token = val));
    super.initState();
  }

  @override
  void dispose() {
    topAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: _getInfluencersList(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                if (data["status"] == "error") {
                  return Column(
                    children: [
                      Text("Ooops! Some error occured"),
                      RaisedButton.icon(
                        icon: Icon(Icons.refresh),
                        label: Text("Refresh"),
                        onPressed: () => setState(() {}),
                      )
                    ],
                  );
                }
                List<Influencer> influencers = <Influencer>[];
                data["data"].forEach(
                    (inf) => influencers.add(Influencer.fromResp(inf)));

                influencers = influencers.reversed.toList();

                return CustomScrollView(
                  controller: widget.scrollController,
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
                          onTap: () {
                            showSearch(
                                context: context,
                                delegate: TheSearch(influencers,
                                    contextPage: context));
                          },
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
                                  'Search influencers',
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
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 100),
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: influencers.length > 12
                                  ? influencers.length + 1
                                  : influencers.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == influencers.length &&
                                    influencers.length > 12) {
                                  return InkWell(
                                    onTap: () {
                                      widget.scrollController.animateTo(0.0,
                                          duration:
                                              const Duration(milliseconds: 800),
                                          curve: Curves.linearToEaseOut);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Back to top',
                                              style: GoogleFonts.nunito(
                                                color: Colors.grey,
                                              )),
                                          SlideTransition(
                                            position: topAnimation,
                                            child: Icon(
                                              Icons.arrow_upward,
                                              size: 14,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return Card(
                                  elevation: 5,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  shadowColor:
                                      Image.asset('assets/designer.jpg').color,
                                  child: ListTile(
                                    isThreeLine: true,
                                    leading: CircleAvatar(
                                      radius: 26,
                                      backgroundColor: Colors.black87,
                                      child: influencers[index].image.isEmpty
                                          ? Hero(
                                              tag: influencers[index].id,
                                              child: ClipRRect(
                                                child: Image.asset(
                                                  "assets/designer.jpg",
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Image.network(
                                                influencers[index].image,
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                    title: Text(influencers[index].igUsername),
                                    subtitle: Text(
                                        "${influencers[index].firstName} ${influencers[index].lastName}"),
                                    onTap: () => Navigator.of(context)
                                        .push(PageRouteBuilder(
                                      pageBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double>
                                              secondaryAnimation) {
                                        return InfluencerDetailsPage(
                                          influencer: influencers[index],
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
                                              begin: const Offset(1.0, 0.0),
                                              end: Offset.zero,
                                            ).animate(CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.easeIn)),
                                            child: child,
                                          ),
                                        );
                                      },
                                    )),
                                  ),
                                );
                              })
                        ],
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("error");
              }
              return SpinKitPouringHourglass(
                color: Colors.black87,
                size: 20,
              );
            }),
        floatingActionButton: FloatingActionButton(
            heroTag: UniqueKey(),
            mini: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.black87,
            child: FaIcon(
              FontAwesomeIcons.plus,
              size: 12,
            ),
            onPressed: () => Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.black87,
                        title: Text(
                          'Add Influencer',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      body: InfluencerPage(),
                    );
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
                          parent: animation, curve: Curves.easeIn)),
                      child: child,
                    );
                  },
                ))),
      ),
    );
  }

  Future<dynamic> _getInfluencersList() async {
    String _endpoint = "https://groombackend.herokuapp.com/api/v1/influencer";
    var resp = await http.get(_endpoint,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    return json.decode(resp.body);
  }
}

class TheSearch extends SearchDelegate<String> {
  TheSearch(this.list, {this.contextPage});

  final BuildContext contextPage;
  final List<Influencer> list;

  @override
  String get searchFieldLabel => "Search for influencer";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final igUserNameList = list.map((e) => e.igUsername).toList();
    final suggestions = query.isEmpty
        ? igUserNameList
        : igUserNameList
            .where((element) => element
                .trim()
                .toLowerCase()
                .contains(query.trim().toLowerCase()))
            .toList();
    if (suggestions.isEmpty)
      return Center(
        child: Text(
          'No influencer found with \'$query\'',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
        ),
      );
    else {
      return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (content, index) => InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => InfluencerDetailsPage(
                influencer: list[list.indexWhere(
                    (element) => element.igUsername == suggestions[index])],
              ),
            ),
          ),
          child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.verified_user,
                  color: Colors.blue[200],
                  size: 14,
                ),
              ),
              title: Text(suggestions[index])),
        ),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final igUserNameList = list.map((e) => e.igUsername).toList();
    final suggestions = query.isEmpty
        ? igUserNameList
        : igUserNameList
            .where((element) => element
                .trim()
                .toLowerCase()
                .contains(query.trim().toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (content, index) => InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => InfluencerDetailsPage(
              influencer: list[list.indexWhere(
                  (element) => element.igUsername == suggestions[index])],
            ),
          ),
        ),
        child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.verified_user,
                color: Colors.blue[200],
                size: 14,
              ),
            ),
            title: Text(suggestions[index])),
      ),
    );
  }
}

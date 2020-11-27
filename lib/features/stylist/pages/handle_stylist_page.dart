import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grroom/features/stylist/pages/stylist_details_page.dart';
import 'package:grroom/features/stylist/pages/stylist_page.dart';
import 'package:grroom/models/stylist.dart';
import 'package:http/http.dart' as http;

class HandleStylistPage extends StatefulWidget {
  final ScrollController scrollController;
  final List<Stylist> stylistsList;

  const HandleStylistPage({Key key, this.scrollController, this.stylistsList})
      : super(key: key);
  @override
  _HandleStylistPageState createState() => _HandleStylistPageState();
}

class _HandleStylistPageState extends State<HandleStylistPage>
    with SingleTickerProviderStateMixin {
  final storage = FlutterSecureStorage();
  String token;
  AnimationController topAnimationController;
  Animation topAnimation;
  List<Stylist> stylists = [];

  @override
  void initState() {
    stylists = widget.stylistsList;

    topAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward()
      ..repeat();
    topAnimation = Tween(begin: Offset(0, -0.1), end: Offset.zero).animate(
        CurvedAnimation(
            parent: topAnimationController, curve: Curves.easeOutExpo));
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
        body: CustomScrollView(
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
                        delegate:
                            StylistSearch(stylists, contextPage: context));
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
                          'Search stylists',
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
                      padding: const EdgeInsets.only(top: 20, bottom: 100),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: stylists.length > 12
                          ? stylists.length + 1
                          : stylists.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == stylists.length && stylists.length > 12) {
                          return InkWell(
                            onTap: () {
                              widget.scrollController.animateTo(0.0,
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.linearToEaseOut);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                        return InkWell(
                          child: Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            shadowColor:
                                Image.asset('assets/designer.jpg').color,
                            child: ListTile(
                              isThreeLine: true,
                              onTap: () =>
                                  Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return StylistDetailsPage(
                                    stylist: stylists[index],
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
                              leading: CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.black87,
                                child: stylists[index].image.isEmpty
                                    ? ClipRRect(
                                        child: Image.asset(
                                          "assets/designer.jpg",
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          stylists[index].image,
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              title: Text(stylists[index].id),
                            ),
                          ),
                        );
                      })
                ],
              ),
            )
          ],
        ),
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
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back_ios, size: 16),
                          onPressed: () => Navigator.pop(context),
                        ),
                        backgroundColor: Colors.black87,
                        title: Text(
                          'Add Stylist',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      body: StylistPage(),
                    )))),
      ),
    );
  }
}

class StylistSearch extends SearchDelegate<String> {
  StylistSearch(this.list, {this.contextPage});

  final BuildContext contextPage;
  final List<Stylist> list;

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
    final igUserNameList = list.map((e) => e.influencerId).toList();
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
          'No stylist found with \'$query\'',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
        ),
      );
    else {
      return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (content, index) => InkWell(
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
    final igUserNameList = list.map((e) => e.id).toList();
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

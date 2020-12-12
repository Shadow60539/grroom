import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grroom/data/remote_fetch.dart';
import 'package:grroom/models/influencer.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

enum InfH { lastOne, lastSecond, none }

class InfluencerCodeBuilder extends StatefulWidget {
  final String code;

  const InfluencerCodeBuilder({Key key, this.code}) : super(key: key);
  @override
  _InfluencerCodeBuilderState createState() => _InfluencerCodeBuilderState();
}

class _InfluencerCodeBuilderState extends State<InfluencerCodeBuilder> {
  InfH pastCode = InfH.none;
  TextEditingController controller = TextEditingController();
  List<Influencer> influencersList = [];

  @override
  void initState() {
    _fetchInfluencers();
    if (widget.code != null) {
      controller.text = widget.code;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<AllProvider>(context, listen: false)
            .updateInfluencerCode(widget.code);
      });
    }
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      controller.text =
          Provider.of<AllProvider>(context, listen: false).influencerCode;
    });
  }

  _fetchInfluencers() async {
    influencersList = await RemoteFetch.getAllInfluencers();
  }

  @override
  Widget build(BuildContext context) {
    return WatchBoxBuilder(
      box: Hive.box('influencerBox'),
      builder: (context, box) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 14),
                    child: Text('Influencer code'),
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: TextField(
                        controller: controller,
                        readOnly: true,
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w200),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            labelStyle: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.normal),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide: BorderSide(
                                    color: Colors.black12, width: 1))),
                        onTap: () {
                          if (influencersList.isNotEmpty) {
                            showSearch(
                                context: context,
                                delegate: CodeSearch(
                                    context, influencersList, controller, box));
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              if (box.length < 2)
                Container()
              else
                Wrap(
                  spacing: 0,
                  runSpacing: 10,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (pastCode == InfH.lastOne) {
                            pastCode = InfH.none;
                            controller.text = '';
                          } else {
                            controller.text = box.getAt(box.length - 1);
                            Provider.of<AllProvider>(context, listen: false)
                                .updateInfluencerCode(
                                    box.getAt(box.length - 1));
                            pastCode = InfH.lastOne;
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                            color: pastCode == InfH.lastOne
                                ? Colors.black87
                                : Colors.white,
                            borderRadius: BorderRadius.circular(2),
                            border:
                                Border.all(color: Colors.black12, width: 1)),
                        child: Text(
                          box.getAt(box.length - 1),
                          style: TextStyle(
                              color: pastCode == InfH.lastOne
                                  ? Colors.white
                                  : Colors.black54,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (pastCode == InfH.lastSecond) {
                            controller.text = '';
                            pastCode = InfH.none;
                          } else {
                            controller.text = box.getAt(box.length - 2);

                            Provider.of<AllProvider>(context, listen: false)
                                .updateInfluencerCode(
                                    box.getAt(box.length - 2));
                            pastCode = InfH.lastSecond;
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                            color: pastCode == InfH.lastSecond
                                ? Colors.black87
                                : Colors.white,
                            borderRadius: BorderRadius.circular(2),
                            border:
                                Border.all(color: Colors.black12, width: 1)),
                        child: Text(
                          box.getAt(box.length - 2),
                          style: TextStyle(
                              color: pastCode == InfH.lastSecond
                                  ? Colors.white
                                  : Colors.black54,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        );
      },
    );
  }
}

class CodeSearch extends SearchDelegate<String> {
  final BuildContext contextPage;
  final List<Influencer> list;
  final TextEditingController controller;
  final Box influencerBox;

  CodeSearch(this.contextPage, this.list, this.controller, this.influencerBox);

  @override
  String get searchFieldLabel => "Choose code";

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
    final igUserNameList = list.map((e) {
      return e.igUsername;
    }).toList();
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
        itemBuilder: (content, index) {
          final influencer = list
              .where((element) => element.igUsername == suggestions[index])
              .first;
          return ListTile(
              onTap: () {
                controller.text = influencer.id;
                influencerBox.add(controller.text);
                Provider.of<AllProvider>(context, listen: false)
                    .updateInfluencerCode(controller.text);
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black26, width: 1)),
              isThreeLine: true,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: CachedNetworkImage(
                  imageUrl: influencer.image,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(influencer.igUsername),
              subtitle: Text(
                influencer.id,
              ));
        },
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final codeList = list.map((e) => e.igUsername).toList();

    final suggestions = query.isEmpty
        ? codeList
        : codeList
            .where((element) => element
                .trim()
                .toLowerCase()
                .contains(query.trim().toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (content, index) {
        final influencer = list
            .where((element) => element.igUsername == suggestions[index])
            .first;

        return ListTile(
            onTap: () {
              controller.text = influencer.id;
              influencerBox.add(controller.text);
              Provider.of<AllProvider>(context, listen: false)
                  .updateInfluencerCode(controller.text);
              Navigator.pop(context);
            },
            isThreeLine: true,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: CachedNetworkImage(
                imageUrl: influencer.image,
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(influencer.igUsername),
            subtitle: Text(
              influencer.id,
            ));
      },
    );
  }
}

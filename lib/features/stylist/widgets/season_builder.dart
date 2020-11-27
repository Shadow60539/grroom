import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:provider/provider.dart';

List<String> _seasonOptions = ["Summer", "Winter", "Autumn", "Spring"];

class SeasonBuilder extends StatefulWidget {
  final List<String> seasons;

  const SeasonBuilder({Key key, this.seasons}) : super(key: key);
  @override
  _SeasonBuilderState createState() => _SeasonBuilderState();
}

class _SeasonBuilderState extends State<SeasonBuilder> {
  bool isExpanded = false;
  List<String> selectedSeason = [];

  @override
  void initState() {
    if (widget.seasons != null) {
      selectedSeason = widget.seasons;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<AllProvider>(context, listen: false)
            .updateSeasonOption(widget.seasons);
      });
    }
    super.initState();
  }

  String selectedEventsString() {
    if (selectedSeason.length < 3) {
      String selectedEvents =
          selectedSeason.toString().replaceAll('[', '').replaceAll(']', '');
      return selectedEvents;
    } else {
      List<String> sE = selectedSeason.sublist(0, 2);
      String selectedEvents =
          sE.toString().replaceAll('[', '').replaceAll(']', '');
      return '$selectedEvents, and ${selectedSeason.length - 2} more';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: isExpanded
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
              : BorderRadius.zero),
      child: ExpansionTileCard(
          animateTrailing: selectedSeason.isEmpty,
          trailing: selectedSeason.isEmpty
              ? Icon(Icons.arrow_drop_down)
              : Text(
                  selectedEventsString(),
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w300),
                ),
          baseColor: Colors.white,
          onExpansionChanged: (value) {
            setState(() {
              isExpanded = value;
            });
          },
          expandedColor: Colors.white,
          elevation: 0,
          title: Text(
            'Seasons',
            style: TextStyle(fontSize: 14),
          ),
          children: [
            GridView.count(
              crossAxisCount: 3,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20)
                  .copyWith(bottom: 20),
              crossAxisSpacing: 20,
              childAspectRatio: 3,
              children: _seasonOptions
                  .map((e) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedSeason.contains(e)) {
                              selectedSeason.remove(e);
                            } else {
                              selectedSeason.add(e);
                            }

                            Provider.of<AllProvider>(context, listen: false)
                                .updateSeasonOption(selectedSeason);
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            e,
                            style: TextStyle(
                                fontSize: 12,
                                color: selectedSeason.contains(e)
                                    ? Colors.white
                                    : Colors.black54),
                          ),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black12),
                              color: selectedSeason.contains(e)
                                  ? Colors.black87
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(2)),
                        ),
                      ))
                  .toList(),
            )
          ]),
    );
  }
}

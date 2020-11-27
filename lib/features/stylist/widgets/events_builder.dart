import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:provider/provider.dart';

List<String> _mainEvents = [
  "Formal interview",
  "Semi formal office",
  "Gymming",
  "College casual",
  "Airport casual chic",
  "Beachwear",
  "Cocktail party",
  "Birthday party",
  "Wedding Party",
  "Costume",
  "Fashion week",
  "Prom",
  "Trekking",
  "Hip Hop",
  "Masquerade",
  "Golf",
];

class EventsBuilder extends StatefulWidget {
  final List<String> events;

  const EventsBuilder({Key key, this.events}) : super(key: key);
  @override
  _EventsBuilderState createState() => _EventsBuilderState();
}

class _EventsBuilderState extends State<EventsBuilder> {
  bool isExpanded = false;
  List<String> selectedEvent = [];

  String selectedEventsString() {
    if (selectedEvent.length < 3) {
      String selectedEvents =
          selectedEvent.toString().replaceAll('[', '').replaceAll(']', '');
      return selectedEvents;
    } else {
      List<String> sE = selectedEvent.sublist(0, 2);
      String selectedEvents =
          sE.toString().replaceAll('[', '').replaceAll(']', '');
      return '$selectedEvents, and ${selectedEvent.length - 2} more';
    }
  }

  @override
  void initState() {
    if (widget.events != null) {
      selectedEvent = widget.events;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<AllProvider>(context, listen: false)
            .updateEventsOption(widget.events);
      });
    }

    super.initState();
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
        onExpansionChanged: (value) {
          setState(() {
            isExpanded = value;
          });
        },
        animateTrailing: selectedEvent.isEmpty,
        trailing: selectedEvent.isEmpty
            ? Icon(Icons.arrow_drop_down)
            : Text(
                selectedEventsString(),
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w300),
              ),
        baseColor: Colors.white,
        expandedColor: Colors.white,
        elevation: 0,
        title: Text(
          'Events',
          style: TextStyle(fontSize: 14),
        ),
        children: [
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 10)
                .copyWith(bottom: 20, left: 10),
            crossAxisSpacing: 20,
            childAspectRatio: 2.5,
            children: _mainEvents
                .map((e) => GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedEvent.contains(e)) {
                            selectedEvent.remove(e);
                          } else
                            selectedEvent.add(e);
                          Provider.of<AllProvider>(context, listen: false)
                              .updateEventsOption(selectedEvent);
                          //     Provider.of<AllProvider>(context, listen: false)
                          // .updateInfluencerCode(value);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        alignment: Alignment.center,
                        child: Text(
                          e,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              color: selectedEvent.contains(e)
                                  ? Colors.white
                                  : Colors.black54),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black12),
                            color: selectedEvent.contains(e)
                                ? Colors.black87
                                : Colors.white,
                            borderRadius: BorderRadius.circular(2)),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

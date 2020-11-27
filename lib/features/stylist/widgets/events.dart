import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:grroom/core/globals.dart' as globals;

class EventsSelector extends StatefulWidget {
  @override
  _EventsSelectorState createState() => _EventsSelectorState();
}

class _EventsSelectorState extends State<EventsSelector> {

  List<S2Choice<String>> _options = [
    S2Choice<String>(value: "festival", title: "Festivals"),
    S2Choice<String>(value: "party", title: "Party"),
    S2Choice<String>(value: "holiday", title: "Holiday"),
    S2Choice<String>(value: "picnic", title: "Picnic"),
  ];

  @override
  Widget build(BuildContext context) {
    return SmartSelect<String>.multiple(
      title: 'Events',
      value: globals.events,
      choiceItems: _options,
      onChange: (state) => setState(() => globals.events = state.value),
    );
  }
}
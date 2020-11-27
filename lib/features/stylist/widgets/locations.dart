import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:grroom/core/globals.dart' as globals;

class LocationsSelector extends StatefulWidget {
  @override
  _LocationsSelectorState createState() => _LocationsSelectorState();
}

class _LocationsSelectorState extends State<LocationsSelector> {

  List<S2Choice<String>> _options = [
    S2Choice<String>(value: "mumbai", title: "Mumbai"),
    S2Choice<String>(value: "jaipur", title: "Jaipur"),
    S2Choice<String>(value: "punjab", title: "Punjab"),
    S2Choice<String>(value: "tamilnadu", title: "Tamil Nadu"),
  ];

  @override
  Widget build(BuildContext context) {
    return SmartSelect<String>.multiple(
      modalFilter: true,
      modalFilterAuto: true,
      title: 'Locations',
      value: globals.locations,
      choiceItems: _options,
      onChange: (state) => setState(() => globals.locations = state.value),
    );
  }
}
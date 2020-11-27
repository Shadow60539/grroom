import 'package:flutter/material.dart';
import 'package:grroom/core/globals.dart' as globals;
import 'package:chips_choice/chips_choice.dart';

class SeasonsSelector extends StatefulWidget {
  @override
  _SeasonsSelectorState createState() => _SeasonsSelectorState();
}

class _SeasonsSelectorState extends State<SeasonsSelector> {
  
  List<String> _options = ["summer", "winter", "autumn", "spring"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: ChipsChoice<String>.multiple(
        wrapped: true,
        value: globals.seasons,
        choiceItems: C2Choice.listFrom<String, String>(
          source: _options,
          value: (i, v) => v,
          label: (i, v) => v,
        ),
        onChanged: (val) => setState(() => globals.seasons = val),
      ),
    );
  }
}


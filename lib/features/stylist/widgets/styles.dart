import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:grroom/core/globals.dart' as globals;

class StylesSelector extends StatefulWidget {
  @override
  _StylesSelectorState createState() => _StylesSelectorState();
}

class _StylesSelectorState extends State<StylesSelector> {

  List<S2Choice<String>> _options = [
    S2Choice<String>(value: "formal", title: "Formal"),
    S2Choice<String>(value: "casual", title: "Casual"),
    S2Choice<String>(value: "office", title: "Office"),
    S2Choice<String>(value: "sports", title: "Sports"),
    S2Choice<String>(value: "party",  title: "Party")
  ];

  @override
  Widget build(BuildContext context) {
    return SmartSelect<String>.multiple(
      title: 'Styles',
      value: globals.styles,
      choiceItems: _options,
      onChange: (state) => setState(() => globals.styles = state.value),
    );
  }
}
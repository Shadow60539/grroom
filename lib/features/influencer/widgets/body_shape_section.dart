import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:provider/provider.dart';

List<String> _mainStyles = ["Female", "Male"];
Map<String, List<String>> _styleOptions = {
  "Female": <String>[
    "Pear",
    "Inverted triangle",
    "Hourglass",
    "Rectangle",
    "Round"
  ],
  "Male": <String>[
    "Rectangle",
    "Inverted triangle",
    "Square",
    "Apple",
  ]
};

class BodyShapeSection extends StatefulWidget {
  @override
  _BodyShapeSectionState createState() => _BodyShapeSectionState();
}

class _BodyShapeSectionState extends State<BodyShapeSection> {
  bool isExpanded = false;
  String selectedStyle;
  String selectedSubStyle = '';
  Map<String, dynamic> styleBody = {};

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
        animateTrailing: selectedStyle == null,
        trailing: selectedStyle == null
            ? Icon(Icons.arrow_drop_down)
            : Text(
                selectedSubStyle.isEmpty
                    ? '$selectedStyle'
                    : '$selectedStyle : $selectedSubStyle',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w300),
              ),
        baseColor: Colors.white,
        expandedColor: Colors.white,
        elevation: 0,
        title: Text(
          'Body Shape',
          style: TextStyle(fontSize: 14),
        ),
        children: [
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
            crossAxisSpacing: 20,
            childAspectRatio: 3,
            children: _mainStyles
                .map((e) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStyle = e;
                          selectedSubStyle = '';
                          //     Provider.of<AllProvider>(context, listen: false)
                          // .updateInfluencerCode(value);
                          styleBody["gender"] = selectedStyle;
                          Provider.of<AllProvider>(context, listen: false)
                              .updateBodyShape(styleBody);
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          e,
                          style: TextStyle(
                              color: selectedStyle == e
                                  ? Colors.white
                                  : Colors.black54),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black12),
                            color: selectedStyle == e
                                ? Colors.black87
                                : Colors.white,
                            borderRadius: BorderRadius.circular(2)),
                      ),
                    ))
                .toList(),
          ),
          selectedStyle == null
              ? SizedBox(height: 0)
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            endIndent: 10,
                          ),
                        ),
                        Text(
                          'Shapes',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w200),
                        ),
                        Expanded(
                          child: Divider(
                            indent: 10,
                            color: Colors.black12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 20)
                          .copyWith(bottom: 20),
                      crossAxisSpacing: 20,
                      childAspectRatio: 2.5,
                      children: _styleOptions[selectedStyle]
                          .map((e) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedSubStyle == e) {
                                      selectedSubStyle = '';
                                    } else
                                      selectedSubStyle = e;

                                    styleBody["gender"] = selectedStyle;
                                    styleBody["shape"] = selectedSubStyle;
                                    Provider.of<AllProvider>(context,
                                            listen: false)
                                        .updateBodyShape(styleBody);
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    e,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: selectedSubStyle.contains(e)
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.black12),
                                      color: selectedSubStyle.contains(e)
                                          ? Colors.black87
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(2)),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

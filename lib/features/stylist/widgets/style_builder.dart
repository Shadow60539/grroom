import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:provider/provider.dart';

class StyleBuilder extends StatefulWidget {
  final Map<String, dynamic> styleBody;

  const StyleBuilder({Key key, this.styleBody}) : super(key: key);
  @override
  _StyleBuilderState createState() => _StyleBuilderState();
}

class _StyleBuilderState extends State<StyleBuilder> {
  bool isExpanded = false;
  String selectedStyle;
  List<String> selectedSubStyle = [];
  Map<String, dynamic> styleBody = {};

  String selectedStylesString() {
    if (selectedSubStyle.length < 2) {
      String selectedEvents =
          selectedSubStyle.toString().replaceAll('[', '').replaceAll(']', '');
      return selectedEvents;
    } else {
      List<String> sE = selectedSubStyle.sublist(0, 1);
      String selectedEvents =
          sE.toString().replaceAll('[', '').replaceAll(']', '');
      return '$selectedEvents, and ${selectedSubStyle.length - 1} more';
    }
  }

  @override
  void initState() {
    if (widget.styleBody != null) {
      selectedStyle = widget.styleBody["category"];
      selectedSubStyle = widget.styleBody["value"];
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<AllProvider>(context, listen: false)
            .updateStyles(widget.styleBody);
      });
    }
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      selectedStyle = Provider.of<AllProvider>(context, listen: false)
          .stylesOption["category"];
      selectedSubStyle = Provider.of<AllProvider>(context, listen: false)
          .stylesOption["value"];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> _mainStyles = Provider.of<AllProvider>(context)
        .baseStyles
        .map((element) => element['category'] as String)
        .toList();

    Map<String, dynamic> _styleOptions = {};
    Provider.of<AllProvider>(context).baseStyles.forEach((element) {
      _styleOptions[element["category"]] = element["value"];
    });

    List<Widget> children() {
      return _styleOptions[selectedStyle]
          .map((e) => GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedSubStyle.contains(e)) {
                      selectedSubStyle.remove(e);
                    } else
                      selectedSubStyle.add(e);
                    styleBody["category"] = selectedStyle;
                    styleBody["value"] = selectedSubStyle;
                    Provider.of<AllProvider>(context, listen: false)
                        .updateStyles(styleBody);
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
                      border: Border.all(width: 1, color: Colors.black12),
                      color: selectedSubStyle.contains(e)
                          ? Colors.black87
                          : Colors.white,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ))
          .cast<Widget>()
          .toList();
    }

    return Consumer<AllProvider>(
      builder: (context, value, child) {
        selectedStyle = value.stylesOption["category"];
        selectedSubStyle = value.stylesOption["value"];
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
                    _styleOptions[selectedStyle].contains(selectedSubStyle)
                        ? '$selectedStyle'
                        : '$selectedStyle : ${selectedStylesString()}',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w300),
                  ),
            baseColor: Colors.white,
            expandedColor: Colors.white,
            elevation: 0,
            title: Text(
              'Styles',
              style: TextStyle(fontSize: 14),
            ),
            children: [
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20)
                    .copyWith(bottom: 20),
                crossAxisSpacing: 20,
                childAspectRatio: 3,
                children: _mainStyles
                    .map((e) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedStyle = e;
                              selectedSubStyle = [];
                              styleBody["category"] = selectedStyle;
                              styleBody["value"] = selectedSubStyle;
                              Provider.of<AllProvider>(context, listen: false)
                                  .updateStyles(styleBody);
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
                                border:
                                    Border.all(width: 1, color: Colors.black12),
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
                              'Sub-styles',
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
                            children: children()),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }
}

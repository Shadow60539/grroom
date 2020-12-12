import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:provider/provider.dart';

class UndertoneSection extends StatefulWidget {
  final String selectedTypes;

  const UndertoneSection({Key key, this.selectedTypes}) : super(key: key);
  @override
  _UndertoneSectionState createState() => _UndertoneSectionState();
}

class _UndertoneSectionState extends State<UndertoneSection> {
  String _selectedTypes = '';
  bool isExpanded = false;
  @override
  void initState() {
    _selectedTypes = widget.selectedTypes ?? '';
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AllProvider>(context, listen: false)
          .updateUndertone(widget.selectedTypes);
    });

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _selectedTypes =
          Provider.of<AllProvider>(context, listen: false).underTone;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AllProvider>(
      builder: (context, value, child) {
        _selectedTypes = value.underTone;
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: isExpanded
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    )
                  : BorderRadius.zero),
          child: ExpansionTileCard(
            baseColor: Colors.white,
            expandedColor: Colors.white,
            onExpansionChanged: (value) {
              setState(() {
                isExpanded = value;
              });
            },
            elevation: 0,
            title: Text(
              'Undertone',
              style: TextStyle(fontSize: 14),
            ),
            animateTrailing: _selectedTypes == null,
            trailing: _selectedTypes == null
                ? Icon(Icons.arrow_drop_down)
                : Text(
                    _selectedTypes,
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w300),
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
                children: Provider.of<AllProvider>(context)
                    .baseUnderTone
                    .map((e) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTypes = e;
                              Provider.of<AllProvider>(context, listen: false)
                                  .updateUndertone(e);
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              e,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: _selectedTypes == e
                                      ? Colors.white
                                      : Colors.black54),
                            ),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black12),
                                color: _selectedTypes == e
                                    ? Colors.black87
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(2)),
                          ),
                        ))
                    .toList(),
              )
            ],
          ),
        );
      },
    );
  }
}

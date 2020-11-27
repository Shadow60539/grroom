import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grroom/features/influencer/pages/influencer_page.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'drop_down_search/my_drop_down_search.dart';

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

  @override
  void initState() {
    if (widget.code != null) {
      controller.text = widget.code;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<AllProvider>(context, listen: false)
            .updateInfluencerCode(widget.code);
      });
    }
    super.initState();
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
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => InfluencerPage())),
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 14),
                      child: Text('Influencer code'),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: DropdownSearch(
                      controller: controller,
                      onSubmitted: (item) {
                        if (item.isNotEmpty) {
                          box.add(item);
                          Provider.of<AllProvider>(context, listen: false)
                              .updateInfluencerCode(item);
                        }
                      },
                      dropdownSearchDecoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2))),
                      mode: Mode.MENU,
                      items: box.isNotEmpty
                          ? List.generate(
                                  box.length, (index) => box.getAt(index))
                              .reversed
                              .toList()
                          : [],
                      onChanged: print,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              if (box.length < 3)
                Container()
              else
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                        child: AnimatedContainer(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              color: pastCode == InfH.lastOne
                                  ? Colors.black87
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(2),
                              border:
                                  Border.all(color: Colors.black12, width: 1)),
                          duration: const Duration(milliseconds: 100),
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
                        child: AnimatedContainer(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              color: pastCode == InfH.lastSecond
                                  ? Colors.black87
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(2),
                              border:
                                  Border.all(color: Colors.black12, width: 1)),
                          duration: const Duration(milliseconds: 100),
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

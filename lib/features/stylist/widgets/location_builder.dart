import 'package:flutter/material.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

enum LocationH { lastOne, lastSecond, none }

class LocationBuilder extends StatefulWidget {
  @override
  _LocationBuilderState createState() => _LocationBuilderState();
}

class _LocationBuilderState extends State<LocationBuilder> {
  LocationH lastLocation = LocationH.none;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WatchBoxBuilder(
      box: Hive.box('locationBox'),
      builder: (context, box) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      autofocus: false,
                      controller: controller,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          box.add(value);
                          Provider.of<AllProvider>(context, listen: false)
                              .updateLocation(value);
                        }
                      },
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w200),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Location',
                          labelStyle: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.normal),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                              borderSide:
                                  BorderSide(color: Colors.black12, width: 1))),
                    )),
                if (box.length < 3)
                  Container()
                else
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Wrap(
                          runSpacing: 10,
                          spacing: 5,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (lastLocation == LocationH.lastOne) {
                                    controller.text = '';
                                    lastLocation = LocationH.none;
                                  } else {
                                    controller.text = box.getAt(box.length - 1);
                                    Provider.of<AllProvider>(context,
                                            listen: false)
                                        .updateLocation(
                                            box.getAt(box.length - 1));
                                    lastLocation = LocationH.lastOne;
                                  }
                                });
                              },
                              child: AnimatedContainer(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                    color: lastLocation == LocationH.lastOne
                                        ? Colors.black
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                        color: Colors.black12, width: 1)),
                                duration: const Duration(milliseconds: 100),
                                child: Text(
                                  box.getAt(box.length - 1),
                                  style: TextStyle(
                                      color: lastLocation == LocationH.lastOne
                                          ? Colors.white
                                          : Colors.black54,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (lastLocation == LocationH.lastSecond) {
                                    controller.text = '';
                                    lastLocation = LocationH.none;
                                  } else {
                                    controller.text = box.getAt(box.length - 2);
                                    Provider.of<AllProvider>(context,
                                            listen: false)
                                        .updateLocation(
                                            box.getAt(box.length - 2));
                                    lastLocation = LocationH.lastSecond;
                                  }
                                });
                              },
                              child: AnimatedContainer(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                    color: lastLocation == LocationH.lastSecond
                                        ? Colors.black87
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                        color: Colors.black12, width: 1)),
                                duration: const Duration(milliseconds: 100),
                                child: Text(
                                  box.getAt(box.length - 2),
                                  style: TextStyle(
                                      color:
                                          lastLocation == LocationH.lastSecond
                                              ? Colors.white
                                              : Colors.black54,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

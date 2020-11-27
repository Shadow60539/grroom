import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grroom/features/stylist/widgets/events_builder.dart';
import 'package:grroom/features/stylist/widgets/location_builder.dart';
import 'package:grroom/features/stylist/widgets/season_builder.dart';
import 'package:grroom/features/stylist/widgets/style_builder.dart';
import 'package:grroom/features/stylist/widgets/submit_button.dart';
import 'package:grroom/features/stylist/widgets/type_builder.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/influencer_code_bar.dart';
import '../widgets/keys.dart';

List<Widget> listOfWidgets = [
  InfluencerCodeBuilder(),
  SeasonBuilder(),
  StyleBuilder(),
  TypeBuilder(),
  EventsBuilder(),
  LocationBuilder(),
  SubmitButton()
];

class StylistPage extends StatefulWidget {
  @override
  _StylistPageState createState() => _StylistPageState();
}

class _StylistPageState extends State<StylistPage> {
  PickedFile _image;
  List<Widget> listItems = <Widget>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _sHeight = MediaQuery.of(context).size.height;
    final _sWidth = MediaQuery.of(context).size.width;

    Future getImage() async {
      final _pickedImage =
          await ImagePicker().getImage(source: ImageSource.gallery);
      setState(() {
        if (_pickedImage != null) {
          _image = _pickedImage;
        }
      });
      Provider.of<AllProvider>(context, listen: false)
          .updateStylistPageImage(_image.path);
    }

    Widget imageHeader() {
      return AnimatedCrossFade(
          firstChild: InkWell(
            onTap: getImage,
            child: _image != null
                ? Container()
                : Center(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        color: Colors.grey,
                        size: 14,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Upload Image',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )),
          ),
          secondChild: LimitedBox(
            maxHeight: 100,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.bottomCenter,
              children: [
                _image != null
                    ? Image.file(
                        File(_image?.path),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 50,
                        width: 50,
                      ),
                AnimatedList(
                  shrinkWrap: true,
                  key: backgroundKey,
                  initialItemCount: stringList.length,
                  itemBuilder: (context, index, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: animation.drive(
                            Tween(begin: Offset(-2, 0), end: Offset.zero)),
                        child: Container(
                          width: 10,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.black12),
                          margin: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                size: 10,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                stringList[index],
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          crossFadeState: _image == null
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(seconds: 1));
    }

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          // Provider.of<AllProvider>(context, listen: false).hideInfluencerCode();
        },
        child: Scaffold(
            body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              elevation: 1,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              stretch: true,
              expandedHeight: _sHeight * 0.5,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: _image != null
                    ? Container(
                        height: 30,
                        child: RaisedButton(
                          color: Colors.white,
                          child: Text(
                            'Select another',
                            style: TextStyle(fontSize: 10),
                          ),
                          onPressed: getImage,
                        ),
                      )
                    : null,
                background: imageHeader(),
                stretchModes: [
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(listOfWidgets),
            )
          ],
        )),
      ),
    );
  }
}

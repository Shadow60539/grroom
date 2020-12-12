import 'dart:io';
import 'dart:math';
import 'dart:ui';

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
  int _imageHeight;
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController()..addListener(() {});

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _sHeight = MediaQuery.of(context).size.height;
    final _sWidth = MediaQuery.of(context).size.width;

    Future getImage() async {
      final _pickedImage =
          await ImagePicker().getImage(source: ImageSource.gallery);
      setState(() async {
        if (_pickedImage != null) {
          _image = _pickedImage;
          final image = File(_image?.path);
          var decodedImage = await decodeImageFromList(image.readAsBytesSync());

          setState(() {
            _imageHeight = decodedImage.height;
          });

          Provider.of<AllProvider>(context, listen: false)
              .updateStylistPageImage(_image.path);
        }
      });
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
          secondChild: Stack(
            fit: StackFit.expand,
            alignment: Alignment.bottomCenter,
            children: [
              _image != null
                  ? Image.file(
                      File(_image?.path),
                      fit: BoxFit.contain,
                    )
                  : Container(
                      height: 50,
                      width: 50,
                    ),
            ],
          ),
          crossFadeState: _image == null
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(seconds: 1));
    }

    return WillPopScope(
      onWillPop: () async {
        Provider.of<AllProvider>(context, listen: false).clearAll();

        Navigator.pop(context);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Transform.rotate(
                    angle: -pi / 2,
                    child: Icon(Icons.arrow_back_ios, size: 16)),
                onPressed: () {
                  Provider.of<AllProvider>(context, listen: false).clearAll();

                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.black87,
              title: Text(
                'Add Stylist',
                style: TextStyle(fontSize: 14),
              ),
            ),
            body: CustomScrollView(
              controller: _controller,
              // physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  elevation: 1,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  stretch: true,
                  expandedHeight: _imageHeight?.toDouble() ?? _sHeight * 0.5,
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

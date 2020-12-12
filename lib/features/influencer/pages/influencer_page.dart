import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grroom/features/influencer/widgets/body_size_section.dart';
import 'package:grroom/features/influencer/widgets/country_section.dart';
import 'package:grroom/features/influencer/widgets/followers_section.dart';
import 'package:grroom/features/influencer/widgets/gender_section.dart';
import 'package:grroom/features/influencer/widgets/instagram_handle_section.dart';
import 'package:grroom/features/influencer/widgets/instagram_link_section.dart';
import 'package:grroom/features/influencer/widgets/speciality_section.dart';
import 'package:grroom/features/influencer/widgets/undertone_section.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/body_shape_section.dart';
import '../widgets/i_submit_button.dart';

class InfluencerPage extends StatefulWidget {
  @override
  _InfluencerPageState createState() => _InfluencerPageState();
}

class _InfluencerPageState extends State<InfluencerPage> {
  PickedFile _image;
  List<Widget> listItems = <Widget>[];
  int _imageHeight;

  List<Widget> listOfWidgets = [
    InstagramHandleSection(),
    InstagramLinkSection(),
    FollowersSection(),
    CountrySection(),
    BodySizeSection(),
    GenderSection(),
    BodyShapeSection(),
    UndertoneSection(),
    SpecialitySection(),
    ISubmitButton()
  ];

  @override
  Widget build(BuildContext context) {
    final _sHeight = MediaQuery.of(context).size.height;

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
              .updateInfluencerPageImage(_image.path);
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
        child: GestureDetector(
          onTap: () {
            // Provider.of<AllProvider>(context, listen: false).hideInfluencerCode();
          },
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: Transform.rotate(
                  angle: -pi / 2,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 16),
                    onPressed: () {
                      Provider.of<AllProvider>(context, listen: false)
                          .clearAll();

                      Navigator.pop(context);
                    },
                  ),
                ),
                backgroundColor: Colors.black87,
                title: Text(
                  'Add Influencer',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              body: CustomScrollView(
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
      ),
    );
  }
}

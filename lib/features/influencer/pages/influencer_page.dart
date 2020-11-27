import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grroom/features/influencer/widgets/body_size_section.dart';
import 'package:grroom/features/influencer/widgets/country_section.dart';
import 'package:grroom/features/influencer/widgets/followers_section.dart';
import 'package:grroom/features/influencer/widgets/instagram_handle_section.dart';
import 'package:grroom/features/influencer/widgets/instagram_link_section.dart';
import 'package:grroom/features/influencer/widgets/name_section.dart';
import 'package:grroom/features/influencer/widgets/speciality_section.dart';
import 'package:grroom/features/influencer/widgets/undertone_section.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/body_shape_section.dart';
import '../widgets/i_submit_button.dart';

List<Widget> listOfWidgets = [
  NameSection(),
  InstagramHandleSection(),
  FollowersSection(),
  CountrySection(),
  BodySizeSection(),
  UndertoneSection(),
  SpecialitySection(),
  BodyShapeSection(),
  ISubmitButton()
];

class InfluencerPage extends StatefulWidget {
  @override
  _InfluencerPageState createState() => _InfluencerPageState();
}

class _InfluencerPageState extends State<InfluencerPage> {
  PickedFile _image;
  List<Widget> listItems = <Widget>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _sHeight = MediaQuery.of(context).size.height;

    Future getImage() async {
      final _pickedImage =
          await ImagePicker().getImage(source: ImageSource.gallery);
      setState(() {
        if (_pickedImage != null) {
          _image = _pickedImage;
        }
      });
      Provider.of<AllProvider>(context, listen: false)
          .updateInfluencerPageImage(_image.path);
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

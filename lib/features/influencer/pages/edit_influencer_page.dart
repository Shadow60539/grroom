import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grroom/features/influencer/widgets/body_size_section.dart';
import 'package:grroom/features/influencer/widgets/country_section.dart';
import 'package:grroom/features/influencer/widgets/followers_section.dart';
import 'package:grroom/features/influencer/widgets/gender_section.dart';
import 'package:grroom/features/influencer/widgets/instagram_handle_section.dart';
import 'package:grroom/features/influencer/widgets/name_section.dart';
import 'package:grroom/features/influencer/widgets/speciality_section.dart';
import 'package:grroom/features/influencer/widgets/undertone_section.dart';
import 'package:grroom/models/influencer.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/body_shape_section.dart';
import '../widgets/i_submit_button.dart';

class EditInfluencerPage extends StatefulWidget {
  final Influencer influncer;

  const EditInfluencerPage({Key key, this.influncer}) : super(key: key);
  @override
  _EditInfluencerPageState createState() => _EditInfluencerPageState();
}

class _EditInfluencerPageState extends State<EditInfluencerPage> {
  PickedFile _image;
  List<Widget> listItems = <Widget>[];

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AllProvider>(context, listen: false)
          .updateInfluencerPageImage(widget.influncer.image);
    });
    super.initState();
  }

  List<Widget> listOfWidgets(Influencer influencer) => [
        InstagramHandleSection(
          igHandle: influencer.igUsername,
        ),
        FollowersSection(
          noOfFollowers: influencer.noOfFollower,
        ),
        CountrySection(
          country: influencer.country,
        ),
        BodySizeSection(
          selectedTypes: influencer.bodySize,
        ),
        GenderSection(
          selectedTypes: influencer.gender,
        ),
        BodyShapeSection(
          bodyShape: influencer.bodyShape,
          gender: influencer.gender,
        ),
        UndertoneSection(
          selectedTypes: influencer.undertone,
        ),
        SpecialitySection(speciality: influencer.speciality),
        ISubmitButton(
          isEdit: true,
          networkImage: influencer.image,
          id: influencer.id,
        )
      ];

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
      return LimitedBox(
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
                : Image.network(
                    widget.influncer.image,
                    fit: BoxFit.cover,
                  )
          ],
        ),
      );
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
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 16),
                  onPressed: () {
                    Provider.of<AllProvider>(context, listen: false).clearAll();

                    Navigator.pop(context);
                  },
                ),
                backgroundColor: Colors.black87,
                title: Text(
                  'Edit Influencer',
                  style: TextStyle(fontSize: 14),
                ),
              ),
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
                      title: Container(
                        height: 30,
                        child: RaisedButton(
                          color: Colors.white,
                          child: Text(
                            'Select another',
                            style: TextStyle(fontSize: 10),
                          ),
                          onPressed: getImage,
                        ),
                      ),
                      background: imageHeader(),
                      stretchModes: [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                        listOfWidgets(widget.influncer)),
                  )
                ],
              )),
        ),
      ),
    );
  }
}

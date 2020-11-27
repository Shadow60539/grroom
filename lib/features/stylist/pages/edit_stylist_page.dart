import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grroom/features/stylist/widgets/events_builder.dart';
import 'package:grroom/features/stylist/widgets/location_builder.dart';
import 'package:grroom/features/stylist/widgets/season_builder.dart';
import 'package:grroom/features/stylist/widgets/style_builder.dart';
import 'package:grroom/features/stylist/widgets/submit_button.dart';
import 'package:grroom/features/stylist/widgets/type_builder.dart';
import 'package:grroom/models/stylist.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/influencer_code_bar.dart';
import '../widgets/keys.dart';

class EditStylistPage extends StatefulWidget {
  final Stylist stylist;

  const EditStylistPage({Key key, this.stylist}) : super(key: key);
  @override
  _EditStylistPageState createState() => _EditStylistPageState();
}

class _EditStylistPageState extends State<EditStylistPage> {
  PickedFile _image;
  List<Widget> listItems = <Widget>[];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AllProvider>(context, listen: false)
          .updateStylistPageImage(widget.stylist.image);
    });
  }

  List<Widget> listOfWidgets(Stylist stylist) => [
        InfluencerCodeBuilder(
          code: stylist.id,
        ),
        SeasonBuilder(
          seasons: stylist.season,
        ),
        StyleBuilder(
          styleBody: {
            "category": stylist.style.category,
            "value": stylist.style.value,
          },
        ),
        TypeBuilder(
          type: stylist.type,
        ),
        EventsBuilder(
          events: stylist.events,
        ),
        LocationBuilder(
          location: stylist.place,
        ),
        SubmitButton(
          isEdit: true,
          networkImage: stylist.image,
          id: stylist.id,
        )
      ];

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
      return _image != null
          ? Image.file(
              File(_image?.path),
              fit: BoxFit.cover,
            )
          : Image.network(
              widget.stylist.image,
              fit: BoxFit.cover,
            );
    }

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Provider.of<AllProvider>(context, listen: false).hideInfluencerCode();
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
              delegate: SliverChildListDelegate(listOfWidgets(widget.stylist)),
            )
          ],
        )),
      ),
    );
  }
}

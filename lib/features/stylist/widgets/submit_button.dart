import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grroom/features/stylist/widgets/simple_dialog.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';

import 'package:grroom/utils/all_provider.dart';

import 'feedback_dialog.dart';

class SubmitButton extends StatefulWidget {
  final bool isEdit;
  final String id;
  final String networkImage;

  const SubmitButton({
    Key key,
    this.isEdit = false,
    this.id,
    this.networkImage,
  }) : super(key: key);

  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool isLoading = false;
  bool isImageDifferent = false;

  @override
  Widget build(BuildContext context) {
    final AllProvider _provider = Provider.of<AllProvider>(context);

    isImageDifferent = _provider.stylistPageImage != widget.networkImage;

    bool isAllOptionsChosen = (_provider.influencerCode.isNotEmpty &&
        _provider.seasonsOption.isNotEmpty &&
        _provider.stylistPageImage.isNotEmpty &&
        _provider.stylesOption.isNotEmpty &&
        _provider.eventsOption.isNotEmpty &&
        _provider.typeOption.isNotEmpty);

    return AnimatedContainer(
      margin: const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isAllOptionsChosen ? Colors.black87 : Colors.transparent,
          border: Border.all(color: Colors.black12, width: 1)),
      height: 50,
      duration: const Duration(milliseconds: 200),
      child: OutlineButton(
        splashColor: Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black87, width: 2),
            borderRadius: BorderRadius.circular(5)),
        onPressed: () {
          print(_provider.influencerCode.isNotEmpty);
          if (isLoading) {
          } else if (isAllOptionsChosen) {
            submitData(context);
          } else if (widget.isEdit) {
            submitData(context);
          }
        },
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 1,
                ),
              )
            : Text(
                'SUBMIT',
                style: TextStyle(
                    color: isAllOptionsChosen ? Colors.white : Colors.black12),
              ),
      ),
    );
  }

  void submitData(context) async {
    final provider = Provider.of<AllProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });
    final String bearerToken = await FlutterSecureStorage().read(key: 'token');

    final Map<String, dynamic> body = {
      "influencerID": "5fbc9f0bb650340b207a2183",
      "events": jsonEncode(provider.eventsOption),
      "style": jsonEncode({
        "category": provider.stylesOption["category"],
        "value": provider.stylesOption["value"]
      }),
      "season": jsonEncode(provider.seasonsOption),
      "location": jsonEncode(provider.location),
      "type": provider.typeOption.toString(),
      "place": provider.location.toString(),
    };

    FormData formData = FormData.fromMap(body);

    if (isImageDifferent) {
      MultipartFile image = await MultipartFile.fromFile(
          provider.stylistPageImage,
          contentType: MediaType('image', 'jpg'));
      formData.files.add(MapEntry('image', image));
    }

    Dio dio = Dio();
    dio.options.baseUrl = 'http://134.209.158.65/api/v1';
    dio.options.headers = {
      HttpHeaders.authorizationHeader: "Bearer $bearerToken",
      "Content-Type": "multipart/form-data"
    };

    final response = widget.isEdit
        ? await dio
            .patch('/meta/${widget.id}', data: formData)
            .catchError((onError) {
            DioError dioError = onError;
            print(jsonDecode(dioError.response.toString())["message"]);
          })
        : await dio.post('/meta', data: formData).catchError((onError) {
            DioError dioError = onError;
            print(jsonDecode(dioError.response.toString())["message"]);
          });

    setState(() {
      isLoading = false;
    });

    if (response?.statusCode == 201 || response?.statusCode == 200) {
      showDialog(context: context, child: MySimpleDialog(isSuccess: true));
    } else {
      showDialog(context: context, child: FeedbackDialog(isSuccess: false));
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grroom/features/stylist/widgets/feedback_dialog.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';

class ISubmitButton extends StatefulWidget {
  final bool isEdit;
  final String id;
  final String networkImage;
  const ISubmitButton(
      {Key key, this.isEdit = false, this.networkImage, this.id})
      : super(key: key);

  @override
  _ISubmitButtonState createState() => _ISubmitButtonState();
}

class _ISubmitButtonState extends State<ISubmitButton> {
  bool isLoading = false;
  bool isImageDifferent = false;
  @override
  Widget build(BuildContext context) {
    final AllProvider _provider = Provider.of<AllProvider>(context);

    isImageDifferent = _provider.influencerPageImage != widget.networkImage;

    bool isAllOptionsChosen = (_provider.igHandle.isNotEmpty &&
            _provider.firstName.isNotEmpty &&
            _provider.influencerPageImage.isNotEmpty &&
            _provider.lastName.isNotEmpty &&
            _provider.followerCount != 0 &&
            _provider.counrty.isNotEmpty &&
            _provider.bodySize.isNotEmpty &&
            _provider.bodyShape.isNotEmpty &&
            _provider.speciality.isNotEmpty &&
            _provider.underTone.isNotEmpty) ||
        widget.isEdit;

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
          if (isLoading) {
          } else if (isAllOptionsChosen) {
            submitData(context);
          } else if (widget.isEdit) {
            submitData(context);
          } else {}
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
      // "_id": "5fbd1e7b313302001771c71a",
      "firstName": provider.firstName.toString(),
      "lastName": provider.lastName.toString(),
      "igUsername": provider.igHandle.toString(),
      "igProfileLink":
          'https://www.instagram.com/${provider.igHandle}'.toString(),
      "undertone": provider.underTone.toString(),
      "bodyShape": jsonEncode(provider.bodyShape),
      "bodySize": provider.bodySize.toString(),
      "noOfFollower": provider.followerCount.toString(),
      "country": provider.counrty.toString(),
      "speciality": provider.speciality.toString()
    };

    FormData formData = FormData.fromMap(body);
    if (isImageDifferent) {
      MultipartFile image = await MultipartFile.fromFile(
          provider.influencerPageImage,
          contentType: MediaType('image', 'jpg'));
      formData.files.add(MapEntry('image', image));
    }
    Dio dio = Dio();
    dio.options.baseUrl = 'https://groombackend.herokuapp.com/api';
    dio.options.headers = {
      HttpHeaders.authorizationHeader: "Bearer $bearerToken",
      "Content-Type": "multipart/form-data"
    };

    String errorMessage;

    final response = widget.isEdit
        ? await dio
            .patch('/v1/influencer/${widget.id}', data: formData)
            .catchError((onError) {
            DioError dioError = onError;
            errorMessage =
                jsonDecode(dioError.response.toString())['message'].toString();
            print(jsonDecode(dioError.response.toString()));
          })
        : await dio
            .post('/v1/influencer', data: formData)
            .catchError((onError) {
            DioError dioError = onError;
            errorMessage =
                jsonDecode(dioError.response.toString())['message'].toString();

            print(jsonDecode(dioError.response.toString()));
          });

    setState(() {
      isLoading = false;
    });

    if (response?.statusCode == 201) {
      showDialog(
          context: context,
          child: FeedbackDialog(
            isSuccess: true,
          ));
    } else {
      showDialog(
          context: context,
          child: FeedbackDialog(
            isSuccess: false,
            errorMessage: errorMessage,
          ));
    }
  }
}

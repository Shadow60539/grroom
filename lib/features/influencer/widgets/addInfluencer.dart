import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class AddInfluencerScreen extends StatefulWidget {
  @override
  _AddInfluencerScreenState createState() => _AddInfluencerScreenState();
}

class _AddInfluencerScreenState extends State<AddInfluencerScreen> {
  // library helpers
  final Dio dio = new Dio();
  final picker = ImagePicker();
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVmYjBmODc3M2NiOTgzMDAxNzA0MDM5OCIsImlhdCI6MTYwNTg1MTQ3MiwiZXhwIjoxNjEzNjI3NDcyfQ.vDCEocYHHUxtYlwy7mF0Las5gASDkTE0xU02yp2xbH0";

  final _formKey = GlobalKey<FormState>();

  // form inputs
  PickedFile _image;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _igUserNameController = TextEditingController();
  final _igProfileLinkController = TextEditingController();
  final _noOfFollowerController = TextEditingController();
  final _countryController = TextEditingController();

  String _selectedBodyTone;
  String _selectedBodyShape;
  String _selectedBodySize;
  String _selectedSpeciality;

  // options
  List<String> _bodyToneOptions = <String>["fair", "neutral", "dark"];
  List<String> _bodyShapeOptions = <String>["fat", "slim", "fit"];
  List<String> _bodySizeOptions = <String>[
    "small",
    "medium",
    "large",
    "extra large"
  ];
  List<String> _specialityOptions = <String>[
    "special",
    "not special",
    "very special"
  ];

  @override
  void initState() {
    super.initState();
    // final storage = FlutterSecureStorage();
    // storage.read(key: "token").then((val) => setState(() => token = val));
    _firstNameController.text = "first name 1";
    _lastNameController.text = "last name";
    _igProfileLinkController.text = "ig link";
    _igUserNameController.text = "ig name";
    _countryController.text = "country";
    _noOfFollowerController.text = "1000";
    _selectedBodyShape = "fat";
    _selectedBodySize = "small";
    _selectedBodyTone = "fair";
    _selectedSpeciality = "special";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // image
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _image == null
                    ? SizedBox(height: 0)
                    : Image.file(File(_image.path)),
              ),

              // image picker
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton.icon(
                    onPressed: pickImage,
                    icon: Icon(_image == null ? Icons.add : Icons.refresh),
                    label:
                        Text(_image == null ? "Select Image" : "Update Image")),
              ),

              // firstName
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: "First Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val.isEmpty ? "Please fill this field" : null,
                ),
              ),

              // secondName
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    border: OutlineInputBorder(),
                  ),
                  // validator: (val) => val.isEmpty ? "Please fill this field" : null,
                ),
              ),

              // igUserName
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _igUserNameController,
                  decoration: InputDecoration(
                    labelText: "Instagram Username",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val.isEmpty ? "Please fill this field" : null,
                ),
              ),

              // igProfileLink
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _igProfileLinkController,
                  decoration: InputDecoration(
                    labelText: "Instagram Profile Link",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val.isEmpty ? "Please fill this field" : null,
                ),
              ),

              // body tone
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: "Select Body Tone",
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedBodyTone,
                  items: _bodyToneOptions
                      .map((_tone) =>
                          DropdownMenuItem(value: _tone, child: Text(_tone)))
                      .toList(),
                  validator: (val) => val == null || val.isEmpty
                      ? "Please select a option"
                      : null,
                  onChanged: (val) => setState(() => _selectedBodyTone = val),
                ),
              ),

              // body shape
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: "Select Body Shape",
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedBodyShape,
                  items: _bodyShapeOptions
                      .map((_shape) =>
                          DropdownMenuItem(value: _shape, child: Text(_shape)))
                      .toList(),
                  validator: (val) =>
                      val.isEmpty ? "Please select a option" : null,
                  onChanged: (val) => setState(() => _selectedBodyShape = val),
                ),
              ),

              // bodySize
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: "Select Body Size",
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedBodySize,
                  items: _bodySizeOptions
                      .map((_size) =>
                          DropdownMenuItem(value: _size, child: Text(_size)))
                      .toList(),
                  validator: (val) =>
                      val.isEmpty ? "Please select a option" : null,
                  onChanged: (val) => setState(() => _selectedBodySize = val),
                ),
              ),

              // noOfFollower
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _noOfFollowerController,
                  decoration: InputDecoration(
                    labelText: "No of followers",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      val.isEmpty ? "Please fill this field" : null,
                ),
              ),

              // country
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    labelText: "Enter Country",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val.isEmpty ? "Please fill this field" : null,
                ),
              ),

              // speciality
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: "Select Speciality",
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedSpeciality,
                  items: _specialityOptions
                      .map((_speciality) => DropdownMenuItem(
                          value: _speciality, child: Text(_speciality)))
                      .toList(),
                  validator: (val) =>
                      val.isEmpty ? "Please select a option" : null,
                  onChanged: (val) => setState(() => _selectedSpeciality = val),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton.icon(
                    onPressed: handleSubmitInfluencer,
                    icon: Icon(Icons.add),
                    label: Text("Add Influencer")),
              )
            ],
          )),
    );
  }

  Future<void> pickImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() => _image = pickedImage);
    }
  }

  Future<void> handleSubmitInfluencer() async {
    if (_formKey.currentState.validate()) {
      if (_image == null) {
        print("image not taken");
      } else {
        const String endpoint = "http://134.209.158.65/api/v1/influencer";
        print(_image.path.split('/').last);
        print(_image.path.split('.').last);

        var req = http.MultipartRequest('POST', Uri.parse(endpoint));

        req.headers[HttpHeaders.authorizationHeader] = "Bearer $token";

        req.fields["firstName"] = _firstNameController.text;
        req.fields["lastName"] = _lastNameController.text;
        req.fields["igUsername"] = _igUserNameController.text ?? "";
        req.fields["igProfileLink"] = _igProfileLinkController.text ?? "";
        req.fields["undertone"] = _selectedBodyTone ?? "";
        req.fields["bodyShape"] = _selectedBodyShape ?? "";
        req.fields["bodySize"] = _selectedBodySize ?? "";
        req.fields["noOfFollower"] = _noOfFollowerController.text ?? "";
        req.fields["country"] = _countryController.text ?? "";
        req.fields["speciality"] = _selectedSpeciality ?? "";

        req.files.add(await http.MultipartFile.fromPath('image', _image.path,
            filename: _image.path.split('/').last,
            contentType:
                MediaType.parse("image/${_image.path.split('.').last}")));

        var resp = await req.send();
        print(resp.statusCode);
        // print(resp.stream);
        print(await resp.stream.bytesToString());

        // FormData formData = new FormData.fromMap({
        //     "firstName": _firstNameController.text,
        //     "lastName": _lastNameController.text,
        //     "igUsername": _igUserNameController.text ?? "",
        //     "igProfileLink": _igProfileLinkController.text ?? "",
        //     "undertone": _selectedBodyTone ?? "",
        //     "bodyShape": _selectedBodyShape ?? "",
        //     "bodySize": _selectedBodySize ?? "",
        //     "noOfFollower": _noOfFollowerController.text ?? "",
        //     "country": _countryController.text ?? "",
        //     "speciality": _selectedSpeciality ?? "",
        //     "image": await MultipartFile.fromFile(
        //       _image.path,
        //       filename: _image.path.split('/').last,
        //       contentType: new MediaType.parse("image/${_image.path.split('.').last}")
        //     )
        //     // "image": new UploadFileInfo(new File(_image.path), _image.path.split('/').last),
        //   });

        // var res = await dio.post(endpoint, data: formData, options: RequestOptions(
        //   headers: {HttpHeaders.authorizationHeader : "Bearer $token"},
        // ));

        // print(res.data);
      }
    }
  }
}

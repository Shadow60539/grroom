import 'package:flutter/cupertino.dart';

class AllProvider extends ChangeNotifier {
  bool _influencerStatus = false;
  int _bottomNavigationIndex = 0;

  String _influencerCode = '';
  String _igLink = '';
  String _firstName = '';
  String _gender = 'Male';
  String _lastName = '';
  String _igHandle = '';
  String _country = '';
  String _bodySize = '';
  String _underTone = '';
  String _speciality = '';
  int _followersCount = 0;
  List<String> _seasonsOption = ["Summer", "Winter", "Autumn", "Spring"];
  List<String> _eventsOption = [];
  Map<String, dynamic> _stylesOption = {};
  Map<String, dynamic> _bodyShape = {};
  String _typeOption = '';
  String _location = '';
  String _stylistPageImage = '';
  String _influencerPageImage = '';
  // bool _seasonsStatus = false;
  // bool get seasonsStatus => _seasonsStatus;

  List<String> _baseEvents = [];
  List<Map<String, dynamic>> _baseStyles = [];
  List<String> _baseSeason = [];
  List<String> _baseTypes = [];
  List<String> _baseGender = [];
  List<String> _baseBodySize = [];
  List<String> _baseUnderTone = [];
  Map<String, dynamic> _baseBodyShape = {};

  String get typeOption => _typeOption;
  List<String> get baseEvents => _baseEvents;
  List<String> get baseSeason => _baseSeason;
  List<String> get baseUnderTone => _baseUnderTone;
  List<String> get baseGender => _baseGender;
  List<String> get baseBodySize => _baseBodySize;
  List<String> get baseTypes => _baseTypes;
  List<Map<String, dynamic>> get baseStyles => _baseStyles;
  Map<String, dynamic> get baseBodyShape => _baseBodyShape;
  String get gender => _gender;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get igLink => _igLink;
  String get igHandle => _igHandle;
  String get underTone => _underTone;
  String get speciality => _speciality;
  String get bodySize => _bodySize;
  String get counrty => _country;
  int get followerCount => _followersCount;
  int get bottomNavigationIndex => _bottomNavigationIndex;
  String get location => _location;
  Map<String, dynamic> get stylesOption => _stylesOption;
  Map<String, dynamic> get bodyShape => _bodyShape;
  List<String> get seasonsOption => _seasonsOption;
  List<String> get eventsOption => _eventsOption;
  bool get influencerStatus => _influencerStatus;
  String get influencerCode => _influencerCode;
  String get stylistPageImage => _stylistPageImage;
  String get influencerPageImage => _influencerPageImage;

  void updateBaseEvents(List<String> events) {
    _baseEvents = events;
    notifyListeners();
  }

  void updateBaseSeason(List<String> seasons) {
    _baseSeason = seasons;
    notifyListeners();
  }

  void updateBaseTypes(List<String> types) {
    _baseTypes = types;
    notifyListeners();
  }

  void updateBaseGender(List<String> gender) {
    _baseGender = gender;
    notifyListeners();
  }

  void updateBaseBodySize(List<String> bodySize) {
    _baseBodySize = bodySize;
    notifyListeners();
  }

  void updateBaseUndertone(List<String> underTone) {
    _baseUnderTone = underTone;
    notifyListeners();
  }

  void updateBaseBodyshape(Map<String, dynamic> shape) {
    _baseBodyShape = shape;
    notifyListeners();
  }

  void updateBaseStyles(List<Map<String, dynamic>> styles) {
    _baseStyles = styles;
    notifyListeners();
  }

  void showInfluencerCode() {
    _influencerStatus = true;
    notifyListeners();
  }

  void updateBottomNavigationIndex(int index) {
    _bottomNavigationIndex = index;
    notifyListeners();
  }

  void updateInfluencerCode(String code) {
    _influencerCode = code;
    notifyListeners();
  }

  void updateGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void updateFirstName(String firstName) {
    _firstName = firstName;
    notifyListeners();
  }

  void updateLastName(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  void updateStylistPageImage(String img) {
    _stylistPageImage = img;
    notifyListeners();
  }

  void updateInfluencerPageImage(String img) {
    _influencerPageImage = img;
    notifyListeners();
  }

  void updateIgLink(String link) {
    _igLink = link;
    notifyListeners();
  }

  void updateIgHangle(String igHandle) {
    _igHandle = igHandle;
    notifyListeners();
  }

  void updateCountry(String country) {
    _country = country;
    notifyListeners();
  }

  void updateBodySize(String bodySize) {
    _bodySize = bodySize;
    notifyListeners();
  }

  void updateUndertone(String undertone) {
    _underTone = undertone;
    notifyListeners();
  }

  void updateSpeciality(String speciality) {
    _speciality = speciality;
    notifyListeners();
  }

  void updateFollowerCount(int followerCount) {
    _followersCount = followerCount;
    notifyListeners();
  }

  void updateLocation(String location) {
    _location = location;
    notifyListeners();
  }

  void updateStyles(Map<String, dynamic> stylesMap) {
    _stylesOption = stylesMap;
    notifyListeners();
  }

  void updateBodyShape(Map<String, dynamic> bodyShape) {
    _bodyShape = bodyShape;
    notifyListeners();
  }

  void updateSeasonOption(List<String> season) {
    _seasonsOption = season;
    notifyListeners();
  }

  void updateEventsOption(List<String> events) {
    _eventsOption = events;
    notifyListeners();
  }

  void updateTypeOption(String type) {
    _typeOption = type;
    notifyListeners();
  }

  void hideInfluencerCode() {
    _influencerStatus = false;
    notifyListeners();
  }

  void clearAll() {
    _influencerStatus = false;
    _bottomNavigationIndex = 0;

    _influencerCode = '';
    _igLink = '';
    _firstName = '';
    _gender = 'Male';
    _lastName = '';
    _igHandle = '';
    _country = '';
    _bodySize = '';
    _underTone = '';
    _speciality = '';
    _followersCount = 0;
    _seasonsOption = ["Summer", "Winter", "Autumn", "Spring"];
    _eventsOption = [];
    _stylesOption = {};
    _bodyShape = {};
    _typeOption = '';
    _location = '';
    _stylistPageImage = '';
    _influencerPageImage = '';
    // _seasonsStatus = false;

    notifyListeners();
  }
}

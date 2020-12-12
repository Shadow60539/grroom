// To parse this JSON data, do
//
//     final stylist = stylistFromJson(jsonString);

import 'dart:convert';

Stylist stylistFromJson(String str) => Stylist.fromJson(json.decode(str));

String stylistToJson(Stylist data) => json.encode(data.toJson());

class Stylist {
  Stylist({
    this.image,
    this.style,
    this.location,
    this.events,
    this.season,
    this.createdAt,
    this.id,
    this.influencerId,
    this.type,
    this.place,
  });

  final Style style;
  final String location;
  final List<String> events;
  final List<String> season;
  final DateTime createdAt;
  final String id;
  final String image;

  final String influencerId;
  final String type;
  final String place;

  factory Stylist.fromJson(Map<String, dynamic> json) {
    return Stylist(
        style: Style.fromJson(json["style"]),
        location: json["location"].toString(),
        events: List<String>.from(json["events"].map((x) => x)),
        season: List<String>.from(json["season"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        id: json["_id"],
        influencerId: json["influencerID"],
        type: json["type"],
        place: json["place"],
        image: json['image'] ?? '');
  }
  factory Stylist.empty() {
    return Stylist(
        style: Style.empty(),
        location: '',
        events: [],
        season: [],
        createdAt: DateTime.now(),
        id: "",
        influencerId: "",
        type: "",
        place: "",
        image: '');
  }

  Map<String, dynamic> toJson() => {
        "style": style.toJson(),
        "location": location,
        "events": List<dynamic>.from(events.map((x) => x)),
        "season": List<dynamic>.from(season.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "_id": id,
        "influencerID": influencerId,
        "type": type,
        "place": place,
        "image": image
      };
}

class Location {
  Location({
    this.type,
    this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );
  factory Location.empty() => Location(
        type: "",
        coordinates: [],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class Style {
  Style({
    this.value,
    this.category,
  });

  List<String> value;
  String category;

  factory Style.fromJson(Map<String, dynamic> json) => Style(
        value: List<String>.from(json["value"]?.map((x) => x)),
        category: json["category"],
      );

  factory Style.empty() => Style(
        value: [],
        category: '',
      );

  Map<String, dynamic> toJson() => {
        "value": List<dynamic>.from(value.map((x) => x)),
        "category": category,
      };
}

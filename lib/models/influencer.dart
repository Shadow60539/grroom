import 'dart:convert';

class Influencer {
  final String id;
  final String firstName;
  final String lastName;
  final String igUsername;
  final String igProfileLink;
  final String undertone;
  final Bodyshape bodyShape;
  final String bodySize;
  final String country;
  final String speciality;
  final String image;
  final String gender;
  final String noOfFollower;

  Influencer(
      {this.id,
      this.gender,
      this.firstName,
      this.lastName,
      this.igUsername,
      this.igProfileLink,
      this.bodyShape,
      this.undertone,
      this.bodySize,
      this.country,
      this.speciality,
      this.image,
      this.noOfFollower});

  @override
  String toString() {
    return '${id}${firstName}${lastName}${igUsername}';
  }

  static Influencer fromResp(var resp) {
    var bodyShapeJson = resp["bodyShape"];
    print(bodyShapeJson);
    return Influencer(
        id: resp["_id"] ?? "id",
        gender: resp['gender'] ?? 'Male',
        firstName: resp["firstName"] ?? "",
        lastName: resp["lastName"] ?? "",
        igUsername: resp["igUsername"] ?? "",
        igProfileLink: resp["igProfileLink"] ?? "",
        undertone: resp["undertone"] ?? "",
        bodyShape: bodyshapeFromJson(bodyShapeJson),
        bodySize: resp["bodySize"] ?? "",
        country: resp["country"] ?? "",
        speciality: resp["speciality"] ?? "",
        image: resp["image"] ?? "",
        noOfFollower: resp["noOfFollower"] ?? "");
  }

  factory Influencer.empty() {
    return Influencer(
        id: '',
        gender: 'Male',
        firstName: "",
        lastName: "",
        igUsername: "",
        igProfileLink: "",
        undertone: "",
        bodyShape: Bodyshape(),
        bodySize: "",
        country: "",
        speciality: "",
        image: "",
        noOfFollower: "");
  }
}

Bodyshape bodyshapeFromJson(var str) {
  return Bodyshape(gender: str["gender"], shape: str["shape"]);
}

class Bodyshape {
  Bodyshape({
    this.gender,
    this.shape,
  });

  String gender;
  String shape;

  factory Bodyshape.fromJson(Map<String, dynamic> json) => Bodyshape(
        gender: json["gender"],
        shape: json["shape"],
      );

  Map<String, dynamic> toJson() => {
        "gender": gender,
        "shape": shape,
      };
}

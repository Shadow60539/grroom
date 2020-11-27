class Influencer {
  final String id;
  final String firstName;
  final String lastName;
  final String igUsername;
  final String igProfileLink;
  final String undertone;
  final List<Map<String, String>> bodyShape;
  final String bodySize;
  final String country;
  final String speciality;
  final String image;
  final String noOfFollower;

  Influencer(
      {this.id,
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

  static Influencer fromResp(var resp) {
    return Influencer(
        id: resp["_id"] ?? "id",
        firstName: resp["firstName"] ?? "",
        lastName: resp["lastName"] ?? "",
        igUsername: resp["igUsername"] ?? "",
        igProfileLink: resp["igProfileLink"] ?? "",
        undertone: resp["undertone"] ?? "",
        bodyShape: List<Map<String, String>>.from(resp["bodyShape"].map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, String>(k, v)))),
        bodySize: resp["bodySize"] ?? "",
        country: resp["country"] ?? "",
        speciality: resp["speciality"] ?? "",
        image: resp["image"] ?? "",
        noOfFollower: resp["noOfFollower"] ?? "");
  }

  factory Influencer.empty() {
    return Influencer(
        id: '',
        firstName: "",
        lastName: "",
        igUsername: "",
        igProfileLink: "",
        undertone: "",
        bodyShape: [],
        bodySize: "",
        country: "",
        speciality: "",
        image: "",
        noOfFollower: "");
  }
}

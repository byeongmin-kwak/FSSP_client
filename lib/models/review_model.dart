class ReviewModel {
  final String id;
  final String address;
  final String advantage;
  final String disadvantage;
  final String createdAt;
  final String residenceType;
  final String residenceYear;
  final String residenceFloor;
  final double overallRating;
  final List<String> advantageKeywords;
  final List<String> disadvantageKeywords;
  final double latitude;
  final double longitude;

  ReviewModel({
    required this.id,
    required this.address,
    required this.advantage,
    required this.disadvantage,
    required this.createdAt,
    required this.residenceType,
    required this.residenceYear,
    required this.residenceFloor,
    required this.overallRating,
    required this.advantageKeywords,
    required this.disadvantageKeywords,
    required this.latitude,
    required this.longitude,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json["_id"],
      address: json["address"] ?? '',
      advantage: json["advantage"] ?? '',
      disadvantage: json["disadvantage"] ?? '',
      createdAt: json["createdAt"],
      residenceType: json["residenceType"] ?? '',
      residenceYear: json["residenceYear"] ?? '',
      residenceFloor: json["residenceFloor"] ?? '',
      overallRating: (json["overallRating"] ?? 0.0).toDouble(),
      advantageKeywords: List<String>.from(json["advantageKeywords"] ?? []),
      disadvantageKeywords:
          List<String>.from(json["disadvantageKeywords"] ?? []),
      latitude: json["latitude"] != null
          ? double.parse(json["latitude"].toString())
          : 0.0,
      longitude: json["longitude"] != null
          ? double.parse(json["longitude"].toString())
          : 0.0,
    );
  }
}

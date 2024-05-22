class ReviewModel {
  final String id, address, advantage, disadvantage, createdAt;

  ReviewModel.fromJson(Map<String, dynamic> json)
      : id = json["_id"],
        address = json["address"],
        advantage = json["advantage"],
        disadvantage = json["disadvantage"],
        createdAt = json["createdAt"];
}

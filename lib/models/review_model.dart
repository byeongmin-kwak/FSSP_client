class ReviewModel {
  final String id, address, advantage, disadvantage;

  ReviewModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        address = json["address"],
        advantage = json["advantage"],
        disadvantage = json["disadvantage"];
}

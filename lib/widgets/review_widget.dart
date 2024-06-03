import 'package:flutter/material.dart';
import 'package:FSSP_cilent/models/review_model.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;

  const ReviewWidget({
    super.key,
    required this.review,
  });

  Widget _buildKeywords(List<String> keywords, Color color) {
    return Wrap(
      spacing: 4.0,
      runSpacing: 2.0,
      children: keywords.map((keyword) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Text(
            keyword,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(10),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              offset: const Offset(5, 5),
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.address,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '장점: ${review.advantage}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            _buildKeywords(review.advantageKeywords, Colors.green),
            const SizedBox(height: 10),
            Text(
              '단점: ${review.disadvantage}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            _buildKeywords(review.disadvantageKeywords, Colors.red),
          ],
        ),
      ),
    );
  }
}

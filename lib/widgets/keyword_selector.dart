import 'package:flutter/material.dart';

class KeywordSelector extends StatelessWidget {
  final String title;
  final List<String> keywords;
  final Set<String> selectedKeywords;
  final Function(String, bool) onSelected;

  const KeywordSelector({
    super.key,
    required this.title,
    required this.keywords,
    required this.selectedKeywords,
    required this.onSelected,
  });

  IconData _getIconForKeyword(String keyword) {
    switch (keyword) {
      case '없음':
        return Icons.block;
      case '주차':
        return Icons.local_parking;
      case '대중교통':
        return Icons.directions_bus;
      case '공원산책':
        return Icons.park;
      case '치안':
        return Icons.security;
      case '경비실':
        return Icons.home;
      case '건물관리':
        return Icons.build;
      case '분리수거':
        return Icons.delete;
      case '환기':
        return Icons.air;
      case '방음':
        return Icons.volume_off;
      case '단열':
        return Icons.ac_unit;
      case '결로':
        return Icons.water_drop;
      case '반려동물 키우기':
        return Icons.pets;
      case '방충':
        return Icons.bug_report;
      case '엘리베이터':
        return Icons.elevator;
      case '조용한 동네':
        return Icons.local_hotel;
      case '평지':
        return Icons.directions_walk;
      case '언덕':
        return Icons.terrain;
      case '마트 · 편의점':
        return Icons.store;
      case '벌레':
        return Icons.bug_report;
      case '층간소음':
        return Icons.hearing;
      case '동네소음':
        return Icons.volume_up;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: keywords.map((keyword) {
            final bool isSelected = selectedKeywords.contains(keyword);
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIconForKeyword(keyword),
                    size: 16,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    keyword,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                onSelected(keyword, selected);
              },
              showCheckmark: false,
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey[200],
            );
          }).toList(),
        ),
      ],
    );
  }
}

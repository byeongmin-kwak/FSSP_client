import 'package:intl/intl.dart';

class BuildingModel {
  final String grndFlrCnt, // 지상층수
      ugrndFlrCnt,
      rideUseElvtCnt,
      pmsDay,
      stcnsDay,
      useAprDay,
      platArea;

  BuildingModel({
    required this.grndFlrCnt,
    required this.ugrndFlrCnt,
    required this.rideUseElvtCnt,
    required this.pmsDay,
    required this.stcnsDay,
    required this.useAprDay,
    required this.platArea,
  });

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      grndFlrCnt: json['grndFlrCnt']?.toString() ?? '',
      ugrndFlrCnt: json['ugrndFlrCnt']?.toString() ?? '',
      rideUseElvtCnt: json['rideUseElvtCnt']?.toString() ?? '',
      pmsDay: _formatDate(json['pmsDay']?.toString() ?? ''),
      stcnsDay: _formatDate(json['stcnsDay']?.toString() ?? ''),
      useAprDay: _formatDate(json['useAprDay']?.toString() ?? ''),
      platArea: json['platArea']?.toString() ?? '',
    );
  }

  static String _formatDate(String date) {
    if (date.isEmpty) return '';

    if (RegExp(r'^[0-9]+$').hasMatch(date)) {
      if (date.length == 6) {
        return DateFormat("yyyy년 MM월").format(DateTime(
          int.parse(date.substring(0, 4)),
          int.parse(date.substring(4, 6)),
        ));
      } else if (date.length == 8) {
        return DateFormat("yyyy년 MM월 dd일").format(DateTime(
          int.parse(date.substring(0, 4)),
          int.parse(date.substring(4, 6)),
          int.parse(date.substring(6, 8)),
        ));
      }
    }
    return date;
  }
}

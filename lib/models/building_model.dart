import 'package:intl/intl.dart';

class BuildingModel {
  final String grndFlrCnt, // 지상층수
      ugrndFlrCnt,
      rideUseElvtCnt,
      atchBldArea,
      pmsDay,
      stcnsDay,
      useAprDay,
      platArea;

  BuildingModel({
    required this.grndFlrCnt,
    required this.ugrndFlrCnt,
    required this.rideUseElvtCnt,
    required this.atchBldArea,
    required this.pmsDay,
    required this.stcnsDay,
    required this.useAprDay,
    required this.platArea,
  });

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      grndFlrCnt: json['grndFlrCnt'].toString(),
      ugrndFlrCnt: json['ugrndFlrCnt'].toString(),
      rideUseElvtCnt: json['rideUseElvtCnt'].toString(),
      atchBldArea: json['atchBldArea'].toString(),
      pmsDay: _formatDate(json['pmsDay'].toString()),
      stcnsDay: _formatDate(json['stcnsDay'].toString()),
      useAprDay: _formatDate(json['useAprDay'].toString()),
      platArea: json['platArea'].toString(),
    );
  }

  static String _formatDate(String date) {
    print('Original date string: $date'); // 디버깅을 위해 추가한 부분
    if (date.isEmpty) return '';
    try {
      final parsedDate = DateTime.parse(date);
      print('Parsed date: $parsedDate'); // 디버깅을 위해 추가한 부분
      return DateFormat("yyyy년 MM월 dd일").format(parsedDate);
    } catch (e) {
      return date;
    }
  }
}

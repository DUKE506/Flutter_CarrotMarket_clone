import 'package:intl/intl.dart';

class DataUtills {
  //화폐단위 포맷 변경
  static String moneyFormat(String data) {
    if (data == "무료나눔") {
      return data;
    }
    late String formatData;
    formatData = NumberFormat('###,###,###,###').format(int.parse(data));

    return '${formatData}원';
  }
}

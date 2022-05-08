import 'package:easy_localization/easy_localization.dart';

String getDiscount(int price, int discountPrice) {
  int percentage = (((price - discountPrice) / price) * 100).toInt();
  return percentage.toString() + '%';
}

String convertToRupiah(int value) {
  return NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(value);
}

String convertToDecimalPattern(String country, int value) {
  return NumberFormat.decimalPattern(country).format(value);
}

String convertToDateFormat(String format, String value) {
  return DateFormat(format).format(DateTime.parse(value));
}

String getCompactNumber(String locale, int value) {
  return NumberFormat.compact(locale: locale).format(value);
}
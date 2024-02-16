import 'package:intl/intl.dart';
import 'package:weather_app/utils/constants.dart';

String getFormattedDateTime(num dt, {String pattern = "MMM dd, yyyy"}) {
  return DateFormat(pattern).format(DateTime.fromMillisecondsSinceEpoch(dt.toInt() * 1000));
}

String getIconDownloadUrl(String icon) => '$iconPrefix$icon$iconSuffix';
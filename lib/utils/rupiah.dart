import 'package:intl/intl.dart';

final NumberFormat rupiahFormatter = NumberFormat.decimalPattern("id");

String formatRupiah(String? numberString) {
  if (numberString == null || numberString.isEmpty) return "Rp0";

  final number = int.tryParse(numberString) ?? 0;
  return "Rp${rupiahFormatter.format(number)}";
}

String convertToArabicNumbers(int number, {String locale = 'ar'}) {
  if (locale != 'ar') return number.toString();

  final arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  final numberStr = number.toString();
  final arabicNumber = numberStr.split('').map((digit) {
    return arabicDigits[int.parse(digit)];
  }).join();
  return arabicNumber;
}

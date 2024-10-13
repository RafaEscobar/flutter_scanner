class FilterString {
  static bool isABarCode(String scannedCode) {
    return (RegExp(r'^[0-9]+$').hasMatch(scannedCode) || RegExp(r'^[a-zA-Z0-9]+$').hasMatch(scannedCode));
  }
}
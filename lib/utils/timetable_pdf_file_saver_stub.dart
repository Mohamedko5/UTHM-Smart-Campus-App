import 'dart:typed_data';

import 'package:printing/printing.dart';

Future<void> saveAndOpenTimetablePdf(
  Uint8List pdfBytes,
  String fileName,
) async {
  await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
}

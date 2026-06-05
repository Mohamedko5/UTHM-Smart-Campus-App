import 'dart:io';
import 'dart:typed_data';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

Future<void> saveAndOpenTimetablePdf(
  Uint8List pdfBytes,
  String fileName,
) async {
  final directory = await getTemporaryDirectory();
  final file = File('${directory.path}/$fileName');
  await file.writeAsBytes(pdfBytes, flush: true);

  final result = await OpenFilex.open(file.path);
  if (result.type != ResultType.done) {
    await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
  }
}

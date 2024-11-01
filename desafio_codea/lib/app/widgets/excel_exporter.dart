import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExcelCreator {
  late Excel _excel;

  ExcelCreator() {
    _excel = Excel.createExcel();
  }

  void addSheet(String sheetName, List<List<dynamic>> data) {
    Sheet sheet = _excel[sheetName];

    if (data.isNotEmpty) {
      for (int i = 0; i < data[0].length; i++) {
        sheet.cell(CellIndex.indexByString('${String.fromCharCode(65 + i)}1')).value = data[0][i];
      }
    }

    for (int row = 1; row < data.length; row++) {
      for (int col = 0; col < data[row].length; col++) {
        sheet.cell(CellIndex.indexByString('${String.fromCharCode(65 + col)}${row + 1}')).value = data[row][col];
      }
    }
  }

  Future<void> save(String fileName) async {
    Directory? directory = await getExternalStorageDirectory();
    String filePath = '${directory?.path}/$fileName';

    print('Guardando archivo en: $filePath');

    final outputFile = File(filePath);
    List<int> bytes = _excel.save() ?? [];
    await outputFile.writeAsBytes(bytes);

    Fluttertoast.showToast(
      msg: "Archivo Excel guardado en: $filePath",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );

    print('Archivo Excel guardado en: $filePath');
  }
}

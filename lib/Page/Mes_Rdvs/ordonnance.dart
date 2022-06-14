import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../SplashScreen.dart';


class PdfInvoiceApi {
  static Future<File> generate(
      String ordonnace, String dateApp, String pateintName) async {
    final pdf = Document();
    final imageJpg =
        (await rootBundle.load('assets/images/Logo.png')).buffer.asUint8List();

    pdf.addPage(Page(
        pageFormat: PdfPageFormat.a6,
        build: (Context context) {
          return Column(children: [
            Image(
              MemoryImage(imageJpg),
              height: 50,
              width: 50,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 20),

            Table(
              columnWidths: {
                0: const FlexColumnWidth(3),
                1: const FlexColumnWidth(4),
              },
              border: const TableBorder(
                  top: BorderSide(color: PdfColors.blue, width: 1),
                  bottom: BorderSide(color: PdfColors.blue, width: 1)),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                    decoration: const BoxDecoration(color: PdfColors.grey200),
                    children: [
                      Container(
                           height: 40,
                          child: Row(children: [
                            Text("Patient's Name",
                                style: const TextStyle(fontSize: 10)),
                          ])),
                      Container(
                        child: Text(pateintName,
                            style: const TextStyle(fontSize: 10)),
                      )
                    ]),
              ],
            ),
            ///////////////////////doc
            Table(
              columnWidths: {
                0: const FlexColumnWidth(3),
                1: const FlexColumnWidth(4),
              },
              border: const TableBorder(
                  top: BorderSide(color: PdfColors.blue, width: 1),
                  bottom: BorderSide(color: PdfColors.blue, width: 1)),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  Container(
                      width: 50,
                      height: 40,
                      child: Row(children: [
                        Text("Doctor's Name",
                            style: const TextStyle(fontSize: 10)),
                      ])),
                  Container(
                    child: Text(
                        lastname.toString() + ' ' + firstname.toString(),
                        style: const TextStyle(fontSize: 10)),
                  )
                ]),
              ],
            ),
            ////////////////////date

            Table(
              columnWidths: {
                0: const FlexColumnWidth(3),
                1: const FlexColumnWidth(4),
              },
              border: const TableBorder(
                  top: BorderSide(color: PdfColors.blue, width: 1),
                  bottom: BorderSide(color: PdfColors.blue, width: 1)),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                    decoration: const BoxDecoration(color: PdfColors.grey200),
                    children: [
                      Container(
                          width: 50,
                          height: 40,
                          child: Row(children: [
                            Text('Date', style: const TextStyle(fontSize: 10)),
                          ])),
                      Container(
                        child:
                            Text(dateApp, style: const TextStyle(fontSize: 10)),
                      )
                    ]),
              ],
            ),
            SizedBox(height: 20),
            Text(ordonnace)
          ]);
        }));

    return PdfApi.saveDocument(name: 'ordonnance.pdf', pdf: pdf);
  }

  
}

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}

void ordonnance(String ordonnace, String dateApp, String pateintName) async {
  final pdfFile = await PdfInvoiceApi.generate(ordonnace, dateApp, pateintName);
  PdfApi.openFile(pdfFile);
}

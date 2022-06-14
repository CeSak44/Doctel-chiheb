import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../profil_page.dart';
import '../time_buttons.dart';

class PdfInvoiceApi {
  static Future<File> generate(
      String patientName,
      String patientEmail,
      int? patientPhone,
      String doctorName,
      // String doctorEmail,
      // int? doctorPhone,
      String dateApp) async {
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
                0: const FlexColumnWidth(1),
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
                            Text('Name', style: const TextStyle(fontSize: 10)),
                          ])),
                      Container(
                        child: Text(patientName, //'Fellah Mohammed Nassim'
                            style: const TextStyle(fontSize: 10)),
                      )
                    ]),
                // TableRow(children: [
                //   Container(
                //       height: 40,
                //       child: Row(children: [
                //         Text('email', style: const TextStyle(fontSize: 10)),
                //       ])),
                //   Container(
                //     child: Text(patientEmail,//'nassim@gmail.com'
                //         style: const TextStyle(fontSize: 10)),
                //   )
                // ]),
                // TableRow(
                //     decoration: const BoxDecoration(color: PdfColors.grey200),
                //     children: [
                //       Container(
                //           height: 40,
                //           child: Row(children: [
                //             Text('phone', style: const TextStyle(fontSize: 10)),
                //           ])),
                //       Container(
                //         child: Text(patientPhone.toString(),//'065646593'
                //             style: const TextStyle(fontSize: 10)),
                //       )
                //     ])
              ],
            ),
            ///////////////////////doc
            Table(
              columnWidths: {
                0: const FlexColumnWidth(1),
                1: const FlexColumnWidth(4),
              },
              border: const TableBorder(
                  top: BorderSide(color: PdfColors.blue, width: 1),
                  bottom: BorderSide(color: PdfColors.blue, width: 1)),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  Container(
                      height: 40,
                      child: Row(children: [
                        Text('Doctor', style: const TextStyle(fontSize: 10)),
                      ])),
                  Container(
                    child: Text(doctorName, //'Zelmati Yassine'
                        style: const TextStyle(fontSize: 10)),
                  )
                ]),
                // TableRow(
                //     decoration: const BoxDecoration(color: PdfColors.grey200),
                //     children: [
                //       Container(
                //           height: 40,
                //           child: Row(children: [
                //             Text('email', style: const TextStyle(fontSize: 10)),
                //           ])),
                //       Container(
                //         child: Text(doctorEmail,//'Yassine@gmail.com'
                //             style: const TextStyle(fontSize: 10)),
                //       )
                //     ]),
                // TableRow(children: [
                //   Container(
                //       height: 40,
                //       child: Row(children: [
                //         Text('phone', style: const TextStyle(fontSize: 10)),
                //       ])),
                //   Container(
                //     child: Text(doctorPhone.toString(),//'0554786593'
                //         style: const TextStyle(fontSize: 10)),
                //   )
                // ])
              ],
            ),
            ////////////////////date

            Table(
              columnWidths: {
                0: const FlexColumnWidth(1),
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
                            Text('Date', style: const TextStyle(fontSize: 10)),
                          ])),
                      Container(
                        child: Text(
                            dateApp, //dateConfrimBox(DateTime.now().withTime(timeSlotToDateTime()))
                            style: const TextStyle(fontSize: 10)),
                      )
                    ]),
              ],
            )
          ]);
        }));

    return PdfApi.saveDocument(name: 'my_ticket.pdf', pdf: pdf);
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

void invoice(String patientName, String patientEmail, int? patientPhone,
    String doctorName, String dateApp) async {
  final pdfFile = await PdfInvoiceApi.generate(
      patientName, patientEmail, patientPhone, doctorName, dateApp);
  PdfApi.openFile(pdfFile);
}

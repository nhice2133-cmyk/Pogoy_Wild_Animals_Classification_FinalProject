import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'scan_history_service.dart';

class ReportService {
  Future<void> generateAndPrintReport(List<ScanResult> history) async {
    final doc = pw.Document();
    final font = await PdfGoogleFonts.poppinsRegular();
    final boldFont = await PdfGoogleFonts.poppinsBold();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: font,
          bold: boldFont,
        ),
        build: (pw.Context context) {
          return [
            _buildHeader(context),
            pw.SizedBox(height: 20),
            _buildSummary(history),
            pw.SizedBox(height: 20),
            _buildTable(history),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name:
          'Wild_Animals_Scan_Report_${DateFormat('yyyyMMdd').format(DateTime.now())}',
    );
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Header(
      level: 0,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Wild Animals Scanner Report',
              style:
                  pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.Text(DateFormat.yMMMd().format(DateTime.now()),
              style: const pw.TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  pw.Widget _buildSummary(List<ScanResult> history) {
    int totalScans = history.length;
    double avgConfidence = totalScans > 0
        ? history.map((e) => e.confidence).reduce((a, b) => a + b) / totalScans
        : 0.0;

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Total Scans', '$totalScans'),
          _buildSummaryItem('Avg. Confidence',
              '${(avgConfidence * 100).toStringAsFixed(1)}%'),
        ],
      ),
    );
  }

  pw.Widget _buildSummaryItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(value,
            style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.teal)),
        pw.Text(label,
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
      ],
    );
  }

  pw.Widget _buildTable(List<ScanResult> history) {
    return pw.TableHelper.fromTextArray(
      headers: ['Date', 'Time', 'Animal', 'Confidence'],
      data: history.map((item) {
        return [
          DateFormat.yMMMd().format(item.timestamp),
          DateFormat.jm().format(item.timestamp),
          item.animalName,
          '${(item.confidence * 100).toStringAsFixed(1)}%',
        ];
      }).toList(),
      headerStyle:
          pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.teal),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
            bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
      ),
      cellAlignment: pw.Alignment.centerLeft,
      cellAlignments: {
        3: pw.Alignment.centerRight,
      },
    );
  }
}

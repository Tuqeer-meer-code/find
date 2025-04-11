import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Missing PDFs Checker',
      home: MissingPdfsChecker(),
    );
  }
}

class MissingPdfsChecker extends StatefulWidget {
  @override
  _MissingPdfsCheckerState createState() => _MissingPdfsCheckerState();
}

class _MissingPdfsCheckerState extends State<MissingPdfsChecker> {
  List<String> visitIds = [
    '58749',
    '60003',
    '63198',
    '68735',
    '71521',
    '73724',
    '73225',
    '76478',
    '76491',
    '76927',
    '77971',
    '78180',
    '77551',
    '76743',
    '77683',
    '77409',
    '77337',
    '77538',
    '76292',
    '78839',
    '78883',
    '78391',
    '78989',
    '78623',
    '79498',
    '79921',
    '78958',
    '80044',
    '79978',
    '79883',
    '80018',
    '80437',
    '80974',
    '80607',
    '81571',
    '76991',
    '81564',
    '81383',
    '81940',
    '82874',
    '82813',
    '84385',
    '83721',
    '83162',
    '84422',
    '85221',
    '84302',
    '84833',
    '84949',
    '86480',
    '86594',
    '86143',
    '85824',
    '86375',
    '86341',
    '86380',
    '86135',
    '86777',
    '87109',
    '87617',
    '88282',
    '88181',
    '87759',
    '85968',
    '89326',
    '88752',
    '89753',
    '89785',
    '88962',
    '89165',
    '90792',
    '87829',
    '91457',
    '91556',
    '91864',
    '92388',
    '93343',
    '93208',
    '93921',
    '94568',
    '95171',
    '95010',
    '67007',
    '75292',
    '76601',
    '76242',
    '78218',
    '77444',
    '76157',
    '77943',
    '79238',
    '78888',
    '80301',
    '80216',
    '79607',
    '80224',
    '79585',
    '80060',
    '79906',
    '80187',
    '80751',
    '79336',
    '80508',
    '80403',
    '80848',
    '80782',
    '81221',
    '79895',
    '81191',
    '81225',
    '82632',
    '82383',
    '75621',
    '82843',
    '82417',
    '83124',
    '82842',
    '84351',
    '84042',
    '83656',
    '84445',
    '82657',
    '84313',
    '83454',
    '84483',
    '84707',
    '81728',
    '85107',
    '84362',
    '83143',
    '84843',
    '85145',
    '85061',
    '86073',
    '86420',
    '86057',
    '86640',
    '86485',
    '86293',
    '86133',
    '86665',
    '87291',
    '87241',
    '85896',
    '88240',
    '89538',
    '89350',
    '89566',
    '88971',
    '90908',
    '90602',
    '90293',
    '88300',
    '91430',
    '91878',
    '91617',
    '93131',
    '94012',
    '93351',
    '92987',
    '92923',
    '94287',
    '94289',
    '94523',
    '94527',
    '95242',
    '95395',
    '94878',
    '95215',
    '94952',
    '95432'
  ];
  List<String> missingPdfs = [];
  List<String> pdfFiles = [];

  // Process the comparison
  void checkMissingPdfs() {
    List<String> pdfIds = pdfFiles.map((file) => file.split('.').first).toList();
    missingPdfs = visitIds.where((id) => !pdfIds.contains(id)).toList();
    setState(() {});
  }

  // Pick PDF files
  Future<void> pickPdfFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      pdfFiles = result.files.map((file) => file.name).toList();
      checkMissingPdfs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Missing PDFs Checker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Visit IDs (${visitIds.length}):', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(border: Border.all()),
                    child: SingleChildScrollView(
                      child: Text(visitIds.join('\n')),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: pickPdfFiles,
                    child: Text('Upload PDF Files'),
                  ),
                  SizedBox(height: 8),
                  if (pdfFiles.isNotEmpty) Text('Uploaded PDFs: ${pdfFiles.join(', ')}'),
                  SizedBox(height: 16),
                  Text('Missing PDFs (${missingPdfs.length}):', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  missingPdfs.isEmpty && pdfFiles.isNotEmpty
                      ? Text('All PDFs are present!')
                      : Container(
                          height: 200,
                          child: SingleChildScrollView(
                            child: Text(missingPdfs.map((id) => '$id.pdf').join('\n')),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

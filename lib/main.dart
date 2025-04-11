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
  final TextEditingController _visitIdsController = TextEditingController();
  List<String> missingPdfs = [];
  List<String> visitIds = [];
  List<String> pdfFiles = [];

  // Process the comparison
  void checkMissingPdfs() {
    visitIds = _visitIdsController.text.split('\n').map((id) => id.trim()).where((id) => id.isNotEmpty).toList();
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
      checkMissingPdfs(); // Re-check after uploading files
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
            // Left: Input for Visit IDs
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Paste Visit IDs (one per line):', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  TextField(
                    controller: _visitIdsController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'visit1\nvisit2\nvisit3',
                    ),
                    onChanged: (_) => checkMissingPdfs(),
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
                  Text('Missing PDFs:', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  missingPdfs.isEmpty && visitIds.isNotEmpty && pdfFiles.isNotEmpty
                      ? Text('All PDFs are present!')
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: missingPdfs.length,
                          itemBuilder: (context, index) => Text('${missingPdfs[index]}.pdf'),
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

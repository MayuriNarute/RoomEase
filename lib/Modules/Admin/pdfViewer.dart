import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  String collegeIdentityUrl='';

   PdfViewer({required this.collegeIdentityUrl,super.key});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("College Identity",style: TextStyle(
                  fontWeight: FontWeight.bold,fontSize:20
                ),),
              ),
            ),
            Container(
              height:
              600,
              child: SfPdfViewer.network(
              '${widget.collegeIdentityUrl}'),
            ),

          ],
        ),
      ),
    );
  }
}

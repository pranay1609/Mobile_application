import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

import 'package:global_configuration/global_configuration.dart';
import 'package:hy_application/mastercolor.dart';

class PdfViwerPage extends StatefulWidget {
  final Map data;
  const PdfViwerPage(this.data);

  @override
  State<PdfViwerPage> createState() => _PdfViwerPageState();
}

class _PdfViwerPageState extends State<PdfViwerPage> {
  @override
  bool _isLoading = true;
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(
        "${GlobalConfiguration().getValue('upload_image') + widget.data['upload_pdf']}");

    setState(() => _isLoading = false);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['title']),
        backgroundColor: defaultcolor,
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : PDFViewer(
              tooltip: PDFViewerTooltip(),
              indicatorBackground: defaultcolor,

              minScale: double.infinity,
              pickerIconColor: homeheadercolor,
              pickerButtonColor: defaultcolor,
              document: document,
              zoomSteps: 1,
              //uncomment below line to preload all pages
              lazyLoad: true,
              // uncomment below line to scroll vertically
              scrollDirection: Axis.vertical,

              //uncomment below code to replace bottom navigation with your own
              /* navigationBuilder:
                        (context, page, totalPages, jumpToPage, animateToPage) {
                      return ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.first_page),
                            onPressed: () {
                              jumpToPage()(page: 0);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              animateToPage(page: page - 2);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: () {
                              animateToPage(page: page);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.last_page),
                            onPressed: () {
                              jumpToPage(page: totalPages - 1);
                            },
                          ),
                        ],
                      );
                    }, */
            ),
    );
  }
}

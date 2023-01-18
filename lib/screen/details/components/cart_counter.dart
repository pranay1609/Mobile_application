import 'package:flutter/material.dart';
import 'package:hy_application/mastercolor.dart';
import 'package:hy_application/screen/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';

class CartCounter extends StatefulWidget {
  final Map data;
  CartCounter(this.data);

  @override
  _CartCounterState createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
  int numOfItems = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildOutlineButton(
          buttontitle: "Read More",
          icon: Icons.remove,
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfViwerPage(widget.data)),
            );
          },
        ),
        SizedBox(
          width: 20,
        ),
        buildOutlineButton(
            buttontitle: "Download",
            icon: Icons.add,
            press: () async {
              String url =
                  'https://graduateresearchproject.com/upload/${widget.data['upload_pdf']}';
              if (await launch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }),
      ],
    );
  }

  buildOutlineButton(
      {IconData Icon()?,
      required VoidCallback press,
      required IconData icon,
      required String buttontitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: 130,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(5.0) //                 <--- border radius here
                ),
            border: Border.all(color: defaultcolor)),
        child: TextButton(
            onPressed: press,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                buttontitle,
                style: TextStyle(fontSize: 15),
              ),
            )),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hy_application/mastercolor.dart';

import '../../../constants.dart';
import 'package:global_configuration/global_configuration.dart';

class ProductTitleWithImage extends StatelessWidget {
  final Map data;
  ProductTitleWithImage(this.data);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: kDefaultPaddin),
          Row(
            children: <Widget>[
              SizedBox(width: kDefaultPaddin),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.80,
                child: Expanded(
                  child: Hero(
                    tag: "id",
                    child: Image.network(
                      "${GlobalConfiguration().getValue('upload_image') + data['front_image']}",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data['title'].toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: defaultcolor,
                  fontSize: 22),
            ),
          ),
        ],
      ),
    );
  }
}

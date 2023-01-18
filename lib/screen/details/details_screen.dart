import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../mastercolor.dart';
import '../widgets/bottomnavigator.dart';
import 'components/body.dart';

class DetailsScreen extends StatefulWidget {
  final Map data;
  DetailsScreen(this.data);
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationCustom(),
      // each product have a color
      backgroundColor: homeheadercolor,
      appBar: buildAppBar(context),
      body: Body(widget.data),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(widget.data['title']),
      backgroundColor: defaultcolor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_sharp,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

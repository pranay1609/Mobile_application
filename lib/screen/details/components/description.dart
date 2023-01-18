import 'package:flutter/material.dart';
import 'package:hy_application/mastercolor.dart';
import 'package:hy_application/screen/userprofile.dart';

import '../../../constants.dart';

class Description extends StatelessWidget {
  final Map data;
  Description(this.data);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Graduation : ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              data['graduation'],
              style: TextStyle(color: defaultcolor),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Text(
              'University : ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              data['university'],
              style: TextStyle(color: defaultcolor),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Text(
              'Department : ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              data['university'],
              style: TextStyle(color: defaultcolor),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Text(
              'Email : ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              data['user_email'],
              style: TextStyle(color: defaultcolor),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Text(
              'Professor : ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              data['professor'],
              style: TextStyle(color: defaultcolor),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Text(
              'publisher : ',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfile(data['created_by'])),
                  );
                },
                child: Text(
                  data['user_name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                )),
          ],
        ),
      ],
    );
  }
}

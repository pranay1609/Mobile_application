import 'package:flutter/material.dart';
import 'package:hy_application/mastercolor.dart';

class SelectTopic extends StatefulWidget {
  const SelectTopic({Key? key}) : super(key: key);

  @override
  State<SelectTopic> createState() => _SelectTopicState();
}

class _SelectTopicState extends State<SelectTopic> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Container(
          color: defaultcolor,
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/home',
              );
            },
            child: Text(
              "Apply",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 1,
        toolbarHeight: 150,
        backgroundColor: defaultcolor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome "),
            SizedBox(
              height: 5,
            ),
            Text("Choose the topics "),
          ],
        ),
      ),
      // body: Column(
      //   children: [
      //     InkWell(
      //       onTap: () {
      //         setState(() {
      //           _value = !_value;
      //         });
      //       },
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: CircleAvatar(
      //           backgroundImage: AssetImage("images/flshgs.png"),
      //           radius: 50,
      //           child: Padding(
      //             padding: const EdgeInsets.all(0.0),
      //             child: _value
      //                 ? Icon(
      //                     Icons.check,
      //                     size: 70.0,
      //                     color: Colors.white,
      //                   )
      //                 : SizedBox(
      //                     height: 40,
      //                   ),
      //           ),
      //         ),
      //       ),
      //     ),
      //     Text(
      //       " AI & ML",
      //       style: TextStyle(fontWeight: FontWeight.bold),
      //     ),
      //   ],
      // ),
      body: GridView.builder(
        itemCount: 7,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (orientation == Orientation.portrait) ? 3 : 3),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _value = !_value;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("images/flshgs.png"),
                    radius: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: _value
                          ? Icon(
                              Icons.check,
                              size: 70.0,
                              color: Colors.white,
                            )
                          : SizedBox(
                              height: 40,
                            ),
                    ),
                  ),
                ),
              ),
              Text(
                " AI & ML",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );
  }
}

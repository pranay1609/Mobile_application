import 'package:flutter/material.dart';

import 'cart_counter.dart';

class CounterWithFavBtn extends StatefulWidget {
  final Map data;
  CounterWithFavBtn(this.data);

  @override
  State<CounterWithFavBtn> createState() => _CounterWithFavBtnState();
}

class _CounterWithFavBtnState extends State<CounterWithFavBtn> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CartCounter(widget.data),
      ],
    );
  }
}

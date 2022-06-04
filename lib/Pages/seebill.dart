import 'dart:io';

import 'package:flutter/cupertino.dart';

class SeeBill extends StatelessWidget {
  late String image;
   SeeBill({required String image}){this.image = image;}

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Image(
                image: NetworkImage(image
                    .toString())));
  }
}

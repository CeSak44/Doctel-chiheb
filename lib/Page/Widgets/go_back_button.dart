import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../homepage.dart';


class GoBackButton extends StatelessWidget {
  const GoBackButton({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const defaultPadding = 10.0;
    const primarycolor = Colors.lightBlue;
    return Row(
      children: [
        Container(
          width: 50 ,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.white
          ),
          child: IconButton(onPressed: (){Get.to(HomePgae());}, icon: const Icon(CupertinoIcons.back , size:32 , color: primarycolor ,)),
        ),
        const SizedBox(width: defaultPadding),
        const Text('Return !' , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 25 , color: Colors.white , fontFamily: 'Montserrat'),)
      ],
    );
  }
}
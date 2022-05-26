import 'package:flutter/material.dart';
import 'all_mes_rdvs.dart';
import 'constants.dart';

class AllMesrdv extends StatelessWidget {
  const AllMesrdv({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: rdvAppBar(),
      backgroundColor: bcgcolor,
      body:  BodyAllMesRdvs(),
    );
  }

  AppBar rdvAppBar() {
    return AppBar(
      toolbarHeight: 35,
      backgroundColor: bcgcolor,
      leading: const BackButton(color: Colors.black),
      title:  const Text(
              "Appointments History",
              style: TextStyle(color: Colors.black),
      
            ), 
      centerTitle: true,
   
      elevation: 0,
    );
  }
}

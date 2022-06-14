import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../homepage.dart';
import '../Docter_Profil/profil_page.dart';
import 'constants.dart';
import 'all_mes_rdvs_to_work.dart';

class BodyAllMesRdvs extends StatefulWidget {
  const BodyAllMesRdvs({
    Key? key,
  }) : super(key: key);

  @override
  State<BodyAllMesRdvs> createState() => BoodyAllMesRdvs();
}

List doctors = [];

class BoodyAllMesRdvs extends State<BodyAllMesRdvs> {
  @override
  void initState() {
    super.initState();
  }

  List<int> disabledIndexv2 = [];

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
  
    return const AllMesrdvToWork(); 
  }

  searchpp() async {
    FirebaseFirestore.instance
        .collection('Appointments')
        .where('patientUID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('date', isGreaterThan: Timestamp.fromDate(iday))
        .where('date',
            isLessThan: Timestamp.fromDate(iday.add(Duration(days: 1))))
        // .orderBy('date')
        .snapshots()
        .listen((event) {
      setState(() {
        doctors.clear();

        for (var element in event.docs) {
          doctors.add(element.data());
        }
      });
    });
  }
  ////////////////// TIME STAMP TO DATE TIME FOR AFFICHAGE

  String readTimestampDate(Timestamp timestamp) {
    DateFormat format = DateFormat.yMMMMEEEEd();
    return format.format(DateTime.parse(timestamp.toDate().toString()));
  }

  String readTimestampTime(Timestamp timestamp) {
    DateFormat format = DateFormat('HH:mm');
    return format.format(DateTime.parse(timestamp.toDate().toString())) +
        ' - ' +
        format.format(DateTime.parse(
            timestamp.toDate().add(const Duration(hours: 1)).toString()));
  }

/////////////////////////////////////////////////////////////////// GET doctors for ur appointementS
  CollectionReference doctorsref =
      FirebaseFirestore.instance.collection('Appointments');

  getPApp() async {
    doctorsref
        .where('patientUID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .orderBy('date')
        .snapshots()
        .listen((event) {
      setState(() {
        doctors.clear();

        for (var element in event.docs) {
          doctors.add(element.data());
        }
      });
    });
  }

  String readDateForTicket(Timestamp timestamp) {
    DateFormat format = DateFormat.yMMMMEEEEd();
    return format.format(DateTime.parse(
            timestamp.toDate().add(DateTime.now().timeZoneOffset).toString())) +
        '\n' +
        readTimestampTime(doctors[index]['date']);
  }
}

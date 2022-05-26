import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

class NewBodyMesRdvs extends StatefulWidget {
  const NewBodyMesRdvs({
    Key? key,
  }) : super(key: key);

  @override
  State<NewBodyMesRdvs> createState() => _NewBodyMesRdvs();
}

class _NewBodyMesRdvs extends State<NewBodyMesRdvs> {
  @override
  void initState() {
    getPApp();

    super.initState();
  }

  List<int> disabledIndexv2 = [];
  late var iii;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
      stream: sref,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/isEmpty.png',
                    scale: 3.5,
                  ),
                  Text(
                    "Hurray! You don't have any appoitments!",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  )
                ],
              ),
            );
            ;
          } else {
            return Container(
              color: bcgcolor,
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        color: maincontainer,
                        shadowColor: Colors.black,
                        elevation: 3,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.fromLTRB(11, 15, 10, 0),
                              child: Row(
                                children: <Widget>[
                                  const CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/images/doc4.png'),
                                    radius: 32.5,
                                  ),
                                  SizedBox(width: w * 0.02),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot
                                              .data!.docs[index]['DoctorsName']
                                              .toString(),
                                          style: const TextStyle(
                                              color: txtcolor, fontSize: 20),
                                        ),
                                        SizedBox(height: h * 0.01),
                                        const Text(
                                          'cardiologue',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  224, 255, 255, 255)),
                                        )
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        iii = index;
                                        Timestamp d =
                                            snapshot.data!.docs[index]['date'];

                                        if (d.seconds -
                                                Timestamp.fromDate(
                                                        DateTime.now())
                                                    .seconds -
                                                3600 >
                                            7200) {
                                          _showMaterialDialog();
                                        } else {
                                          customSnackBar(
                                              'Too late to cancel ', Colors.red,
                                              icon: Icons.info_outline);
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Color.fromARGB(255, 144, 10, 0),
                                        size: 30,
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  style: BorderStyle.none,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                color: seccontainer,
                              ),
                              //   margin: EdgeInsets.all(10),
                              height: h * 0.070,
                              width: w * 0.875,
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_month,
                                        color: txtcolor,
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        readTimestampDate(
                                            snapshot.data!.docs[index]['date']),
                                        style: const TextStyle(color: txtcolor),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.schedule,
                                        color: txtcolor,
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        '${readTimestampTime(snapshot.data!.docs[index]['date'])} '
                                        ' - '
                                        ' ${readTimestampTimeAddHour(snapshot.data!.docs[index]['date'])}',
                                        style: const TextStyle(color: txtcolor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
            ;
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                    width: 90, height: 90, child: CircularProgressIndicator()),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Please Wait",
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  ////////////////// TIME STAMP TO DATE TIME FOR AFFICHAGE

  String readTimestampDate(Timestamp timestamp) {
    DateFormat format = DateFormat.yMMMMEEEEd();
    return format.format(DateTime.parse(timestamp.toDate().toString()));
  }

  String readTimestampTime(Timestamp timestamp) {
    DateFormat format = DateFormat('HH:mm');
    return format.format(DateTime.parse(
        timestamp.toDate().subtract(DateTime.now().timeZoneOffset).toString()));
  }

  String readTimestampTimeAddHour(Timestamp timestamp) {
    DateFormat format = DateFormat('HH:mm');
    return format.format(DateTime.parse(timestamp
        .toDate()
        .add(const Duration(hours: 1))
        .subtract(DateTime.now().timeZoneOffset)
        .toString()));
  }

  String readdateforcancel(Timestamp timestamp) {
    DateFormat format = DateFormat('yyyy-MM-dd 00:00:00.000');
    return format.format(DateTime.parse(
        timestamp.toDate().add(DateTime.now().timeZoneOffset).toString()));
  }

  /////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////// GET doctors for ur appointementS
  List doctors = [];
  CollectionReference doctorsref =
      FirebaseFirestore.instance.collection('Appointments');
  var fdsfds = Timestamp.fromDate(DateTime.now().add(Duration(hours: 1)));
  getPApp() async {
    doctorsref
        .where('patientUID',
            isEqualTo: FirebaseAuth
                .instance.currentUser!.uid) //.add(Duration(hours: 1 ))
        .where('date',
            isGreaterThan: Timestamp.fromDate(
                DateTime.now().add(Duration(hours: 1, minutes: 10))))
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

  var sref = FirebaseFirestore.instance
      .collection('Appointments')
      .where('patientUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('date',
          isGreaterThan: Timestamp.fromDate(
              DateTime.now().add(Duration(hours: 1, minutes: 10))))
      .orderBy('date')
      .snapshots();

  _cancelAppointment() async {
    int r = 77;
    switch (readTimestampTime(doctors[iii]['date'])) {
      case '08:00':
        {
          r = 0;
        }
        break;
      case '09:00':
        {
          r = 1;
        }
        break;
      case '10:00':
        {
          r = 2;
        }
        break;
      case '11:00':
        {
          r = 3;
        }
        break;
      case '14:00':
        {
          r = 4;
        }
        break;
      case '15:00':
        {
          r = 5;
        }
        break;
    }

    await FirebaseFirestore.instance
        .collection('Docuser')
        .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2')
        .collection('day-month-year')
        .doc(readdateforcancel(doctors[iii]['date']))
        .get()
        .then((value) async {
      disabledIndexv2 = value['timeindex'].cast<int>();
      disabledIndexv2[r] = 77;
      await FirebaseFirestore.instance
          .collection('Docuser')
          .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2')
          .collection('day-month-year')
          .doc(readdateforcancel(doctors[iii]['date']))
          .update({'timeindex': disabledIndexv2});
    });

    var notref = FirebaseFirestore.instance.collection('Appointments');
    notref
        .where('patientUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('doctorUID', isEqualTo: 'g9VUZSPoX6YyWqjzhnZ0oSd3pBo2')
        .where('date', isEqualTo: doctors[iii]['date'])
        .get()
        .then((value) {
      for (var element in value.docs) {
        notref.doc(element.id).delete();
      }
    });
    var ref = FirebaseFirestore.instance.collection('Patuser');
    await ref
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('ClickDoc')
        .doc('g9VUZSPoX6YyWqjzhnZ0oSd3pBo2') //the doctor clicked uid
        .set({'onceADay': false, 'timeleft': 0});
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Center(child: Text('Are You Sure ?')),
            content: SizedBox(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    horizontalTitleGap: 2,
                    leading: const Icon(Icons.person_outline),
                    title: Text(
                      doctors[iii]['DoctorsName'].toString(),
                    ),
                  ),
                  const Divider(thickness: 2),
                  ListTile(
                    horizontalTitleGap: 2,
                    leading: const Icon(Icons.category),
                    title: Text('Cardiologue'),
                  ),
                  Divider(thickness: 2),
                  ListTile(
                    horizontalTitleGap: 2,
                    leading: const Icon(Icons.calendar_month),
                    title: Text('${readTimestampDate(doctors[iii]['date'])} '
                        '${readTimestampTime(doctors[iii]['date'])} '
                        ' - '
                        ' ${readTimestampTimeAddHour(doctors[iii]['date'])}'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close')),
              TextButton(
                onPressed: () async {
                  try {
                    final result = await InternetAddress.lookup('example.com');
                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                      Navigator.pop(context);
                      _onLoading();

                      _cancelAppointment();
                    }
                  } on SocketException catch (_) {
                    customSnackBar('There is no connection! ', Colors.red,
                        icon: Icons.warning_amber);
                  }
                },
                child: const Text('Delete'),
              )
            ],
          );
        });
  }

  void _onLoading() {
    SnackBar snackBar = SnackBar(
      backgroundColor: Color.fromARGB(255, 215, 19, 19),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            width: 5,
          ),
          Text(
            'Appointment Canceled ',
            style: TextStyle(fontSize: 17),
          ),
          Icon(
            Icons.check_circle_outline,
            color: Colors.white,
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.fromLTRB(120, 0, 120, 0),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              CircularProgressIndicator(),
              Text("Loading"),
            ],
          ),
        );
      },
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  SnackBar customSnackBar(String customText, Color color, {IconData? icon}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    SnackBar snackBar = SnackBar(
      backgroundColor: color,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 4,
          ),
          Text(
            customText + ' ',
            style: TextStyle(fontSize: 17),
          ),
          Icon(
            icon,
            color: Colors.white,
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return snackBar;
  }
}

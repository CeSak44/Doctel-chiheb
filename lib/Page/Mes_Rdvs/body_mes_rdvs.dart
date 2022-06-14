import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

class BodyMesRdvs extends StatefulWidget {
  const BodyMesRdvs({
    Key? key,
  }) : super(key: key);

  @override
  State<BodyMesRdvs> createState() => _BodyMesRdvs();
}

class _BodyMesRdvs extends State<BodyMesRdvs> {
  @override
  void initState() {
    getPApp();
    super.initState();
  }

  List<int> disabledIndexv2 = [];
  int iii = 0;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    if (doctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/isEmpty.png',
              scale: 3.5,
            ),
            const Text(
              "You don't have any upcoming appoitments!",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            )
          ],
        ),
      );
    } else {
      return Container(
        color: bcgcolor,
        child: ListView.builder(
            itemCount: doctors.length,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctors[index]['DoctorsName'].toString(),
                                    style: const TextStyle(
                                        color: txtcolor, fontSize: 20),
                                  ),
                                  SizedBox(height: h * 0.01),
                                  const Text(
                                    'cardiologue',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(224, 255, 255, 255)),
                                  )
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  iii = index;
                                  _showMaterialDialog();
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color:  Color.fromARGB(255, 144, 10, 0),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  color: txtcolor,
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  readTimestampDate(doctors[index]['date']),
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
                                  '${readTimestampTime(doctors[index]['date'])} '
                                  ' - '
                                  ' ${readTimestampTimeAddHour(doctors[index]['date'])}',
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
    }
  }

  ////////////////// TIME STAMP TO DATE TIME FOR AFFICHAGE

  String readTimestampDate(Timestamp timestamp) {
    DateFormat format = DateFormat.yMMMMEEEEd();
    return format.format(DateTime.parse(timestamp.toDate().toString()));
  }

  String readTimestampTime(Timestamp timestamp) {
    DateFormat format = DateFormat('HH:mm');
    return format.format(DateTime.parse(timestamp.toDate().toString()));
  }

  String readTimestampTimeAddHour(Timestamp timestamp) {
    DateFormat format = DateFormat('HH:mm');
    return format.format(DateTime.parse(
        timestamp.toDate().add(const Duration(hours: 1)).toString()));
  }

  String readdateforcancel(Timestamp timestamp) {
    DateFormat format = DateFormat('yyyy-MM-dd 00:00:00.000');
    return format.format(DateTime.parse(timestamp.toDate().toString()));
  }

  /////////////////////////////////////////////////////////////
  int mkjmkgug() {
    int r = 77;
    switch (readTimestampTime(doctors[5]['date'])) {
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
    return r;
  }

/////////////////////////////////////////////////////////////////// GET doctors for ur appointementS
  List doctors = [];
  CollectionReference doctorsref =
      FirebaseFirestore.instance.collection('Appointments');

  getPApp() async {
    doctorsref
        .where('patientUID', isEqualTo: '43vju27PaOZptGuNQvDC')
        .where('date',
            isGreaterThan:
                Timestamp.fromDate(DateTime.now().add(Duration(minutes: 10))))
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
        .doc('yzreO3TrzblximKsxdz2')
        .collection('day-month-year')
        .doc(readdateforcancel(doctors[iii]['date']))
        .get()
        .then((value) async {
      disabledIndexv2 = value['timeindex'].cast<int>();
      disabledIndexv2[r] = 77;
      await FirebaseFirestore.instance
          .collection('Docuser')
          .doc('yzreO3TrzblximKsxdz2')
          .collection('day-month-year')
          .doc(readdateforcancel(doctors[iii]['date']))
          .update({'timeindex': disabledIndexv2});
    });

    var notref = FirebaseFirestore.instance.collection('Appointments');
    notref
        .where('patientUID', isEqualTo: '43vju27PaOZptGuNQvDC')
        .where('doctorUID', isEqualTo: 'yzreO3TrzblximKsxdz2')
        .where('date', isEqualTo: doctors[iii]['date'])
        .get()
        .then((value) {
      for (var element in value.docs) {
        notref.doc(element.id).delete();
      }
    });
  }

  void _showMaterialDialog() {
    SnackBar snackBar = SnackBar(
      backgroundColor: const Color.fromARGB(255, 205, 30, 30),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            width: 5,
          ),
          Text(
            'Appointment cancled ',
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
                  const Divider(thickness: 2),
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
                onPressed: () {
                  _cancelAppointment();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: const Text('Delete'),
              )
            ],
          );
        });
  }
}

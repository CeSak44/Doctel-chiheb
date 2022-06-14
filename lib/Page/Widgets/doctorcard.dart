import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/doctors.dart';
import '../Docter_Profil/profil_page.dart';

int timeleft = 0;

class DoctorCard extends StatefulWidget {
  final Doctor doc;
  const DoctorCard({Key? key, required this.doc}) : super(key: key);

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  get doc => doc;

  @override
  Widget build(BuildContext context) {
    double hight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      // onTap :(){
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => DoctorPage()),
      //   );
      // },
      child: Material(
          child: SizedBox(
        width: width * 0.85,
        height: hight * 0.26,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(children: <Widget>[
            Material(
              elevation: 3,
              shadowColor: const Color.fromARGB(255, 63, 63, 63),
              borderRadius: BorderRadius.circular(19),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            // This is The description Of the Card
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 9.0, right: 3, left: 9, top: 9),
                                  child: Text(
                                    widget.doc.nameofthedoctor,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 7.50, right: 3, left: 9),
                                  child: Text(
                                    widget.doc.categorie,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 7.5, right: 3, left: 9),
                                child: Row(
                                  // This is The Location
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Image(
                                            image: AssetImage(
                                                'assets/images/LocationLogo.png'))),
                                    Text(
                                      widget.doc.place,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 7.5, right: 3, left: 9),
                                child: Row(
                                  //this is the phone number
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Icon(Icons.phone)),
                                    Text(
                                      widget.doc.telephone,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(bottom: 7.0, right: 10, left: 9),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(8)),
                    Column(
                      children: [
                        SizedBox(
                          // this is the button's design
                          height: MediaQuery.of(context).size.height * 0.034,
                          child: ElevatedButton(
                              onPressed: () async {
                                ///////

                                await FirebaseFirestore.instance
                                    .collection('Patuser')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('ClickDoc')
                                    .doc(widget.doc.uid) // clicked doctor
                                    .get()
                                    .then(
                                  (value) {
                                    timeleft = value['timeleft'];
                                  },
                                );
                                Timer(
                                    Duration(
                                        seconds: timeleft -
                                                    Timestamp.fromDate(
                                                            DateTime.now())
                                                        .seconds >
                                                0
                                            ? timeleft -
                                                Timestamp.fromDate(
                                                        DateTime.now())
                                                    .seconds
                                            : 2), () async {
                                  await FirebaseFirestore.instance
                                      .collection('Patuser')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection('ClickDoc')
                                      .doc(widget
                                          .doc.uid) //the doctor clicked uid
                                      .update(
                                          {'onceADay': false, 'timeleft': 0});
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DoctorPage(
                                            first: widget.doc.nameofthedoctor,
                                            last: widget.doc.lastname,
                                            uid: widget.doc.uid,
                                            url: widget.doc.urlpic,
                                            spec: widget.doc.categorie,
                                            phone: widget.doc.telephone,
                                            email: widget.doc.email,
                                            about: widget.doc.about,
                                          )),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5);
                                  }
                                }),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0))),
                              ),
                              child: const Text(
                                "Book Appointment",
                                style: TextStyle(fontFamily: 'Montserrat'),
                              )),
                        ),
                      ],
                    ),
                  ]),
            ),
            FractionalTranslation(
              translation: Offset(width * 0.0055, hight * 0.0003),
              child: Container(
                //This is The Photo of The Card

                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)),
                child: ClipOval(
                  child: widget.doc.urlpic != ""
                      ? Image.network(
                          widget.doc.urlpic!,
                          width:100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.person,
                          size: MediaQuery.of(context).size.height * 0.13,
                          color: Colors.grey.shade400,
                        ),
                ),
              ),
            ),
          ]),
        ),
      )),
    );
  }
}

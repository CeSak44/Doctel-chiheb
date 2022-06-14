// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cote_pat/homepage.dart';
import 'package:flutter/material.dart';
import '../../model/doctors.dart';
import 'doctorcard.dart';

class ListOfDoctors extends StatefulWidget {
  String title, img;

  ListOfDoctors({
    Key? key,
    required this.title,
    required this.img,
  }) : super(key: key);

  @override
  State<ListOfDoctors> createState() => _ListOfDoctorsState();
}

class _ListOfDoctorsState extends State<ListOfDoctors> {
  // ignore: recursive_getters
  // get title => title;
  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    String img = widget.img;
    List? ledncj;
    var docRef = FirebaseFirestore.instance
        .collection("Docuser")
        .where("isAccepted", isEqualTo: true)
        .where("specialité", isEqualTo: title)
        .get();
    // get Listes => Listes;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Center(
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.7,
                  fontFamily: 'Montserrat'),
            ),
          ),
         leading: const BackButton(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
         Image(
              image: NetworkImage(img),
              height: MediaQuery.of(context).size.height * 0.11,
              width: MediaQuery.of(context).size.width * 0.11,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.017)
          ],
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: docRef,
          builder: (context, snapshot) {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.hasData
                    ? snapshot.data!.docs.length
                    : 0, //how many doctors in the list
                itemBuilder: (context, index) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    //the input list of doctors
                    return DoctorCard(
                        doc: Doctor(
                            "Dr. " +
                                "${snapshot.data!.docs[index]['firstname']}",
                            "${snapshot.data!.docs[index]['lastname']}",
                            "${snapshot.data!.docs[index]['email']}",
                            "${snapshot.data!.docs[index]['phone']}",
                            "${snapshot.data!.docs[index]['specialité']}",
                            "${snapshot.data!.docs[index]['wilaya']}",
                            snapshot.data!.docs[index]['picture'],
                            snapshot.data!.docs[index]['owner'],
                            snapshot.data!.docs[index]['about']));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                });
          },
        ));
  }
}

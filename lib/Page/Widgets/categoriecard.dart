import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cote_pat/Page/Widgets/ListCatDoc.dart';
import 'package:cote_pat/Page/Widgets/listOfDoctors.dart';
import 'package:cote_pat/model/doctors.dart';
import 'package:flutter/material.dart';
import 'ListCatDoc.dart';

class CategorieCard extends StatelessWidget {
  final String title;
  final String image;

  CategorieCard({Key? key, required this.title, required this.image})
      : super(key: key);
  late List<Doctor> DocList;
  late Doctor doc1;
  CollectionReference docs = FirebaseFirestore.instance.collection("Docuser");
  Future getListDoc() async {
    try {
      await docs.where("specialité", isEqualTo: title).get().then((value) {
      value.docs.forEach((element) {
        doc1.nameofthedoctor = element.get("firstname");
        doc1.nameofthedoctor = doc1.nameofthedoctor + element.get("lastname");
        doc1.categorie = element.get("specialité");
        doc1.place = "Sidi Bel-Abbes";
        doc1.nameofthedoctor = element.get("phone");
        DocList.add(doc1);
      });
    });}
    catch(e){
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
      child: InkWell(
        onTap: () {
          ListCat(specialite: title);
          ListOfDoctors(Listes: DocList);
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(45.0)),
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.2,
              child: Image(image: AssetImage(image)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
              ),
            )
          ],
        ),
      ),
    );
  }
}

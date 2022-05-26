// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class ListCat {
  String specialite;

  
  ListCat({required this.specialite});
List DocList = [];
  CollectionReference docs = FirebaseFirestore.instance.collection("Docuser");
  getListDoc() async {
    await docs.where("specialité", isEqualTo: specialite).get().then((value) {
      value.docs.forEach((element) {
        DocList.add(element.data());
      });
    });
  }
}

import 'package:cote_pat/homepage.dart';
import 'package:flutter/material.dart';
import 'DoctorGridCard.dart';

class ListOfDoctors extends StatefulWidget {
  List Listes;

  ListOfDoctors({Key? key, required this.Listes}) : super(key: key);

  @override
  State<ListOfDoctors> createState() => _ListOfDoctorsState();
}

class _ListOfDoctorsState extends State<ListOfDoctors> {
  String nom = 'Dr xxxxx';
  String categorie = '(Nom de la catégorie)';
  String disponibilite = 'Indisponible';
  String location = ' Sidi Bel-Abbes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          categorie,
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22.7,
              fontFamily: 'Montserrat'),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: MediaQuery.of(context).size.width * 0.1,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePgae()),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Image.asset(
            'assets/images/cardiogram.png',
            height: MediaQuery.of(context).size.height * 0.11,
            width: MediaQuery.of(context).size.width * 0.11,
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.017)
        ],
      ),
      body: Container(
        color: Colors.white,
        child: GridView(
          children: [
            Doctor(nom, location, disponibilite),
            Doctor(nom, location, disponibilite),
            Doctor(nom, location, disponibilite),
            Doctor(nom, location, disponibilite),
            Doctor(nom, location, disponibilite),
            Doctor(nom, location, disponibilite),
            Doctor(nom, location, disponibilite),
          ],
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.7,
            childAspectRatio: 11 / 16,
            mainAxisSpacing: MediaQuery.of(context).size.height * 0.005,
          ),
        ),
      ),
    );
  }
}

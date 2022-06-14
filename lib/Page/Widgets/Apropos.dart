import 'package:flutter/material.dart';

class Apropos extends StatefulWidget {
  const Apropos({Key? key}) : super(key: key);

  @override
  State<Apropos> createState() => _AproposState();
}

class _AproposState extends State<Apropos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: Text("A propos", style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(44, 0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //   height: MediaQuery.of(context).size.height * 0.04,
                //   width:  MediaQuery.of(context).size.width * 0.04,
                height: 150,
                width: 150,
                child: Image.asset("assets/images/logosplash.png"),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                        "Cette application a été developper par des etudiants de l'école Supérieure en Informatique Sidi Bel Abbes pour faciliter les réservations des rendez-vous chez des medcins qui sont déja inscrit dans l'application. "),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                        "Le patient va s'incrire ensuite choisir le medcin qui va le consulter et faire une reservation d'un rendez-vous par : choisir une date et l'heure et cliquer sur 'Make an Appointment' "),
                    SizedBox(
                      height: 25,
                    ),
                    Text("Notre Equipe",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: 25,
                    ),
                    DataTable(columns: [
                      DataColumn(
                          label: Text("NOM",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                      DataColumn(
                          label: Text("PRENOM",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                    ], rows: [
                      DataRow(cells: [
                        DataCell(Text("FELLAH")),
                        DataCell(Text("Mohammed Nassim")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("TITOUAH")),
                        DataCell(Text("Yacine")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("BOUZEBOUDJA")),
                        DataCell(Text("Bahaa Eddine Moatassem beallah")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("FERHATI")),
                        DataCell(Text("Khalil")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("SAKHRAOUI")),
                        DataCell(Text("Chiheb Eddine")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("ZERROUGUI")),
                        DataCell(Text("Amjed")),
                      ]),
                    ])
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

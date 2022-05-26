import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cote_pat/Page/Docter_Profil/profil_page.dart';
import 'package:flutter/material.dart';
import 'Page/Widgets/Header_widget.dart';
import 'Page/Widgets/categoriecard.dart';
import 'Page/Widgets/doctorcard.dart';
import 'Page/Widgets/drawer_widget.dart';
import 'Page/Widgets/mytitle.dart';
import 'Page/profile_page.dart';
import 'model/doctors.dart';
import 'package:hexcolor/hexcolor.dart';

class HomePgae extends StatefulWidget {
  int selectedindex = 1;
  @override
  _HomePgaeState createState() => _HomePgaeState();
}

int index = 0;

List<String> cat = [
  'Pulmonology',
  'Radiologist',
  'Psychologist',
  'Cardiologist',
  'dentist'
];
List<String> img = [
  'img/lungs.png',
  'img/mri.png',
  'img/brain.png',
  'img/pulse.png',
  'img/cavity.png',
];
GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
List<Widget> items = [
  const Image(image: AssetImage('assets/images/accueil.png')),
  const Image(image: AssetImage('assets/images/rendez-vous.png')),
  const Image(
    image: AssetImage('assets/images/profil-de-lutilisateur.png'),
  )
];
List<Widget> mypages = [ProfilePage(), home(), Text("data")];

class _HomePgaeState extends State<HomePgae> {
  int selectedindex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
            ]),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {
              _key.currentState!.openDrawer();
            }),
        elevation: 0,
        shadowColor: Colors.white,
        backgroundColor: HexColor("#397EF5"),
        actions: [
          IconButton(
              onPressed: (() {} // search input here

                  ),
              icon: const Icon(Icons.search))
        ],
        title: const Text(
          "Welcome",
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
      ),
      backgroundColor: Colors.grey.shade50,
      drawer: const drawer_widget(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            selectedindex = index;
          });

          print(selectedindex);
        },
        currentIndex: selectedindex,
        elevation: 20,
        selectedItemColor: HexColor("#397EF5"),
        unselectedItemColor: Colors.black54,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Montserrat',
        ),
        selectedFontSize: MediaQuery.of(context).size.width * 0.03,
        unselectedFontSize: MediaQuery.of(context).size.width * 0.0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list_alt,
              ),
              label: 'Appointments'),
        ],
      ),
      body: mypages.elementAt(selectedindex),
    );
  }
}

class home extends StatelessWidget {
  // ignore: non_constant_identifier_names
  
  // ignore: non_constant_identifier_names

  CollectionReference doctorsRef =
      FirebaseFirestore.instance.collection("Docuser");
//  getListDocH() async {
//    List<Doctor> DocList = [];
//       var Doc1;
//     await doctorsRef.where("isAccepted", isEqualTo: true).get().then((value) {
//       value.docs.forEach((element) {
//         Doc1.nameofthedoctor = element.get("firstname""lastname");
//         Doc1.categorie = element.get("specialité");
//         Doc1.place = "Sidi Bel-Abbes";
//         Doc1.telephone = element.get("phone");
//         DocList.add(Doc1);
//       });
//     });
//   }

  home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;

    return ListView(
      children: [
        SizedBox(
          height: h * 0.23,
          child: HeaderWidget(h * 0.23, false, Icons.notification_add),
        ),
        Padding(
          padding: const EdgeInsets.all(7.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const MyTitle(title: 'Categories', fontsize: 25),
            const Padding(padding: EdgeInsets.only(top: 8.0)),
            SizedBox(
              height: h * 0.11,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cat.length,
                  itemBuilder: (context, index) {
                    return CategorieCard(
                      title: cat[index],
                      image: img[index],
                    );
                  }),
            ),
            const MyTitle(title: 'Top Doctors', fontsize: 25),
          ]),
        ),
        Expanded(
            child: FutureBuilder<QuerySnapshot>(
          future: doctorsRef.get(),
          builder: (context, snapshot) {
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount:
                    snapshot.data!.docs.length, //how many doctors in the list
                itemBuilder: (context, index) {
                  //the input list of doctors
                  return DoctorCard(
                      doc: Doctor(
                          "Dr. " 
                          // + DocList[index].nameofthedoctor,
                          // DocList[index].categorie,
                          // DocList[index].place,
                          // DocList[index].telephone)
                          "${snapshot.data!.docs[index]['firstname']}"
                          " ${snapshot.data!.docs[index]['lastname']}",
                      "${snapshot.data!.docs[index]['specialité']}",
                      "Sidi Bel-Abbes'",
                      "${snapshot.data!.docs[index]['phone']}")
                      );
                });
          },
        ))
      ],
    );
  }
}

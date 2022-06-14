import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'Page/Mes_Rdvs/mes_rdvs.dart';
import 'Page/SplashScreen.dart';
import 'Page/Widgets/Header_widget.dart';
import 'Page/Widgets/categoriecard.dart';
import 'Page/Widgets/doctorcard.dart';
import 'Page/Widgets/drawer_widget.dart';
import 'Page/Widgets/mytitle.dart';
import 'Page/Widgets/listOfDoctors.dart';

import 'Page/Widgets/search_page.dart';
import 'Page/profile_page.dart';
import 'model/doctors.dart';

import 'package:hexcolor/hexcolor.dart';

class HomePgae extends StatefulWidget {
  int selectedindex = 1;
  @override
  _HomePgaeState createState() => _HomePgaeState();
}

int index = 0;
List categories = [];

List<String> img = [
  'assets/images/lungs.png',
  'assets/images/mri.png',
  'assets/images/brain.png',
  'assets/images/pulse.png',
  'assets/images/cavity.png',
];
GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
List<Widget> items = [
  const Image(image: AssetImage('assets/images/accueil.png')),
  const Image(image: AssetImage('assets/images/rendez-vous.png')),
  const Image(
    image: AssetImage('assets/images/profil-de-lutilisateur.png'),
  )
];
List<Widget> mypages = [ProfilePage(), home(), const Mesrdv()];

class _HomePgaeState extends State<HomePgae> {


  @override
  void initState() {
  }

  int selectedindex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
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
              onPressed: (() {
                 Get.to(const SearchPage());
              } // search input here

                  ),
              icon: const Icon(Icons.search))
        ],
        title: const Center(
          child: Text(
            "Welcome",
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade50,
      drawer: drawer_widget(),
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
  var doctorsRef = FirebaseFirestore.instance
      .collection("Docuser")
      .where("isAccepted", isEqualTo: true);
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
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategorieCard(
                      title: categories[index]['spec'],
                      image: categories[index]['specpicture'],
                    );
                  }),
            ),
            const MyTitle(title: 'Top Doctors', fontsize: 25),
          ]),
        ),
        FutureBuilder<QuerySnapshot>(
          future: doctorsRef.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
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
                          "Dr. " +
                                "${snapshot.data!.docs[index]['firstname']}"+" "+"${snapshot.data!.docs[index]['lastname']}",
                            "${snapshot.data!.docs[index]['lastname']}",
                            "${snapshot.data!.docs[index]['email']}",
                            "${snapshot.data!.docs[index]['phone']}",
                            "${snapshot.data!.docs[index]['specialité']}",
                            "${snapshot.data!.docs[index]['wilaya']}",
                            snapshot.data!.docs[index]['picture'],
                            snapshot.data!.docs[index]['owner'],
                            snapshot.data!.docs[index]['about']));
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
      ],
    );
  }
}

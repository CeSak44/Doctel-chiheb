import 'package:cote_pat/Page/Docter_Profil/profil_page.dart';
import 'package:flutter/material.dart';
import '../../model/doctors.dart';


class DoctorCard extends StatefulWidget {
  Doctor doc;
  DoctorCard({Key? key, required this.doc}) : super(key: key);

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  get doc => this.doc;

  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        onTap: () {
              DoctorPage(doc: doc);
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 8.0),
          child: Material(
            elevation: 2,
            shadowColor: const Color.fromARGB(255, 63, 63, 63),
            borderRadius: BorderRadius.circular(19),
            child: Center(
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
                                      bottom: 9.0, right: 3, left: 9),
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
                              EdgeInsets.only(bottom: 7.0, right: 3, left: 9),
                        ),
                        Container(
                          //This is The Photo of The Card
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          child: const CircleAvatar(
                            radius: 49,
                            backgroundImage:
                                AssetImage("assets/images/doc3.png"),
                          ),
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
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5);
                                }),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0))),
                              ),
                              child: Text(
                                "Book Appointment",
                                style: TextStyle(fontFamily: 'Montserrat'),
                              )),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

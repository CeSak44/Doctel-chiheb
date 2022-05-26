import 'package:cote_pat/Page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Doctor extends StatelessWidget {
  late String nom;
  late String location;
  late String disponibilite;

  Doctor(String nom, String location, String disponibilite) {
    this.nom = nom;
    this.disponibilite = disponibilite;
    this.location = location;
  }

  @override
  Widget build(BuildContext context) {
    double heightt = MediaQuery.of(context).size.height;

    return Card(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/doctor.png',
                height: heightt * 0.12,
              ),
              SizedBox(
                height: heightt * 0.007,
              ),
              Text(
                nom,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    fontFamily: 'Montserrat'),
              ),
              SizedBox(
                height: heightt * 0.007,
              ),
              Text(
                disponibilite,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.047,
                    fontFamily: 'Montserrat',
                    color: Colors.red),
              ),
              SizedBox(
                height: heightt * 0.009,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/LocationLogo.png'),
                  Text(
                    location,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: MediaQuery.of(context).size.width * 0.041,
                        color: Colors.blueGrey),
                  ),
                ],
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                  child: Text(
                    'Voir profile',
                    style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'Montserrat',
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        decoration: TextDecoration.underline),
                  ))
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.blueGrey, offset: Offset.zero, blurRadius: 3.5),
            ],
            borderRadius: BorderRadius.circular(15),
          ),
        ));
  }
}

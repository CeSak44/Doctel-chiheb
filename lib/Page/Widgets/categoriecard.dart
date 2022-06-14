import 'package:cote_pat/Page/Docter_Profil/profil_page.dart';
import 'package:cote_pat/Page/Widgets/listOfDoctors.dart';
import 'package:flutter/material.dart';
//import 'Page/Widgets/listOfDoctors.dart';

class CategorieCard extends StatelessWidget {
  final String title;
  final String image;

  const CategorieCard({Key? key, required this.title, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListOfDoctors(
                      title: title,img: image,
                    )),
          );
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50.0)),
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.2,
              child: ClipOval(child: Image(image: NetworkImage(image))),
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

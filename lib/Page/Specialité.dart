import 'package:flutter/material.dart';


class Specialite extends StatefulWidget {
  Specialite({Key? key}) : super(key: key);
  @override
  State<Specialite> createState() => _SpecialiteState();
}

class _SpecialiteState extends State<Specialite> {
  List<String> items =["cardiologue","pédiatre","généraliste","radiologue","physiatre"];
  String? value;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17,vertical: 2),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(       
          value: value,
          isExpanded: true,
          items: items
                  .map((item) => DropdownMenuItem<String>(
            value: item,
            child:Text(
             item,
             style:TextStyle(fontWeight: FontWeight.normal,fontSize: 15),
               ) ,
          )).toList(),
          onChanged: (item)=>setState(()=>value = item),
          
        ),
      ),
      decoration:
       BoxDecoration(
        border: Border.all(color: Colors.black12,width: 2),
        borderRadius: BorderRadius.circular(25),
      ),
    );
  
  } 
}
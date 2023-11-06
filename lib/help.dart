
import 'dart:io';
import 'package:flutter/material.dart';


class Helppage extends StatefulWidget {


  @override
  _HelpState createState() => new _HelpState();

}

class _HelpState extends State<Helppage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text("Gollanma"),

        ),
      body:
      Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Amazon TM www.amazon.ae websaýtyndan söwda etmäge kömek edýar.Tehniki näsazlyk ýüze çyksa şu belgä jaň ediň : +99365939482",style: TextStyle(fontSize: 18,height: 1.5),),
            IconButton(
              iconSize: 72,
              icon: const Icon(Icons.help_center),
              onPressed: () {
                // ...
              },
            ),
Text("Gollanma"),

            Text("www.amazon.ae websaýtyndan haryt saýlanandan soň sahypanyň aşak kysmyndan satyn al düwmesine basyň! Mobil belgiňizi ýazyp dowam et düwmesine basmaly.",style: TextStyle(fontSize: 16,height: 1.2),),

          ],

        ),

      )
      ,

    );

    //throw UnimplementedError();
  }


}
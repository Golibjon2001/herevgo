import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/detail_page.dart';
import 'package:herewego/pages/hom_pages.dart';
import 'package:herewego/pages/siginin_page.dart';
import 'package:herewego/pages/siginup_page.dart';
import 'package:herewego/server/prefs_server.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  Widget _startPage(){
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
        builder:(BuildContext context,snapshot){
        if(snapshot.hasData){
          Prefs.saveUserId(snapshot.data!.uid);
          return Hom_Page();
        }else{
          Prefs.removeUserId();
          return Sigin_In();
        }
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:_startPage(),
      routes: {
        Hom_Page.id:(context)=>Hom_Page(),
        Sigin_In.id:(context)=>Sigin_In(),
        Sigin_Up.id:(context)=>Sigin_Up(),
        Detail_Page.id:(context)=>Detail_Page(),
      },
    );
  }
}


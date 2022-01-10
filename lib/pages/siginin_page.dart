import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/hom_pages.dart';
import 'package:herewego/pages/siginup_page.dart';
import 'package:herewego/server/auth_server.dart';
import 'package:herewego/server/prefs_server.dart';
import 'package:herewego/server/utls_server.dart';
class Sigin_In extends StatefulWidget {
  static final String id="sigin_page";
  const Sigin_In({Key? key}) : super(key: key);

  @override
  _Sigin_InState createState() => _Sigin_InState();
}

class _Sigin_InState extends State<Sigin_In> {
  var isLoading=false;
  var emailcontroler=TextEditingController();
  var passwordcontroler=TextEditingController();

  void _doLoginIn(){
    String email=emailcontroler.text.toString().trim();
    String password=passwordcontroler.text.toString().trim();

    if(email.isEmpty||password.isEmpty) return;
    setState(() {
      isLoading=true;
    });

    AuthServer.siginInUser(context, email, password,).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser!),
    });

  }

  _getFirebaseUser(FirebaseUser firebaseUser)async{
    setState(() {
      isLoading=false;
    });
    if(firebaseUser!=null){

      await Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, Hom_Page.id);
    }else{
      Utils.fireToast('This is Center Short Toast');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15,right: 15),
            margin:EdgeInsets.only(left: 15,right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller:emailcontroler,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  obscureText:true,
                  controller:passwordcontroler,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 45,
                  width: double.infinity,
                  color: Colors.red,
                  child: FlatButton(
                    onPressed: (){
                      _doLoginIn();
                    },
                    child: Text("Sigin In",style: TextStyle(color: Colors.white),),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 45,
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, Sigin_Up.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Don't have an account?"),
                        SizedBox(width: 10,),
                        Text("Sigin Up"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading ?
         Center(
           child: CircularProgressIndicator(),
         ): SizedBox.shrink(),
        ],
      ) ,
    );
  }
}

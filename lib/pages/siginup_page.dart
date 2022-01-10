import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/siginin_page.dart';
import 'package:herewego/server/auth_server.dart';
import 'package:herewego/server/prefs_server.dart';
import 'package:herewego/server/utls_server.dart';
import 'hom_pages.dart';
class Sigin_Up extends StatefulWidget {
  static final String id="siginup";
  const Sigin_Up({Key? key}) : super(key: key);

  @override
  _Sigin_UpState createState() => _Sigin_UpState();
}

class _Sigin_UpState extends State<Sigin_Up> {
  var isLoading=false;
  var namecontroler=TextEditingController();
  var emailcontroler=TextEditingController();
  var passwordcontroler=TextEditingController();

  void _dologinUp(){
    String name=namecontroler.text.toString().trim();
    String email=emailcontroler.text.toString().trim();
    String password=passwordcontroler.text.toString().trim();
    if(email.isEmpty||password.isEmpty||name.isEmpty) return;
    setState(() {
      isLoading=true;
    });

    AuthServer.siginUpUser(context, email, password,name).then((firebaseUser) => {
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
                  controller: namecontroler,
                  decoration: InputDecoration(
                    hintText: 'Fullname',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 10,),
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
                      _dologinUp();
                    },
                    child: Text("Sigin Up",style: TextStyle(color: Colors.white),),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 45,
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, Sigin_In.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Already have an account?"),
                        SizedBox(width: 10,),
                        Text("Sigin Up"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading?
          Center(
            child: CircularProgressIndicator(),
          ):SizedBox.shrink(),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:herewego/model/post_model.dart';
import 'package:herewego/server/prefs_server.dart';
import 'package:herewego/server/rtdb_servis.dart';
import 'package:herewego/server/stor_serves.dart';
import 'package:image_picker/image_picker.dart';
class Detail_Page extends StatefulWidget {
  static final String id="detailpage";
  const Detail_Page({Key? key}) : super(key: key);

  @override
  _Detail_PageState createState() => _Detail_PageState();
}

class _Detail_PageState extends State<Detail_Page> {
  File? _image;
  var isLoading=false;
  final pisker= ImagePicker();

  var firstnamecontroler=TextEditingController();
  var lastnamecontroler=TextEditingController();
  var contentcontroler=TextEditingController();
  var datacontroler=TextEditingController();


  addPost() async{
    String firstName=firstnamecontroler.text.toString().trim();
    String lastName=lastnamecontroler.text.toString().trim();
    String content=contentcontroler.text.toString().trim();
    String data=datacontroler.text.toString().trim();
    if(firstName.isEmpty||lastName.isEmpty||content.isEmpty||data.isEmpty) return;
    if(_image==null) return;
    _apiUploadImage(firstName,lastName,content,data);
  }

  void _apiUploadImage(String firstName,String lastName,String content,String data){
    setState(() {
      isLoading=true;
    });
    StorServes.uploadImage(_image!).then((img_url) => {
    _apiAddPost(firstName,lastName,content,data,img_url!),
    });
  }

  _apiAddPost(String firstName,String lastName,String content,String data,String img_url )async{
    var id= await Prefs.loadUserId();
    RTDBServes.addPost(Post(id,firstName,lastName, content, data,img_url)).then((response) => {
      _respAddPost(),
    });
  }

  _respAddPost(){
    setState(() {
      isLoading=false;
    });
    Navigator.of(context).pop({'data':'done'});
  }

  Future _getImage() async{
    final piskedFile= await pisker.getImage(source:ImageSource.gallery);
    setState(() {
      if(piskedFile!=null){
         _image=File(piskedFile.path);
      }else{
        print('No image selected');
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor:Colors.red,
        title:Text("Add Post"),
        centerTitle:true,
      ),
      body:Stack(
        children: [
          SingleChildScrollView(
            child:Container(
              height:MediaQuery.of(context).size.height,
              padding:EdgeInsets.only(left:15,right: 15),
              child:Column(
                children: [
                  SizedBox(height: 15,),
                  GestureDetector(
                    onTap:()=>_getImage(),
                    child:Container(
                      height:100,
                      width:100,
                      child:_image!=null ?
                      Image.file(_image!,fit:BoxFit.cover,):
                      Image.asset('assets/images/insta2.png',fit:BoxFit.cover,),
                    ),
                  ),
                  SizedBox(height:10,),
                  TextField(
                    controller:firstnamecontroler,
                    decoration:InputDecoration(
                      hintText:"Firstname",
                    ),
                  ),
                  SizedBox(height:10,),
                  TextField(
                    controller:lastnamecontroler,
                    decoration:InputDecoration(
                      hintText:"Lastname",
                    ),
                  ),
                  SizedBox(height:10,),
                  TextField(
                    controller:contentcontroler,
                    decoration:InputDecoration(
                      hintText:"Content",
                    ),
                  ),
                  SizedBox(height:10,),
                  TextField(
                    controller:datacontroler,
                    decoration:InputDecoration(
                      hintText:"Date",
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height:45,
                    width:double.infinity,
                    color:Colors.red,
                    child:FlatButton(
                      onPressed:(){
                        addPost();
                      },
                      child:Text("Add",style:TextStyle(color:Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading?
              Center(
                child:CircularProgressIndicator(),
              ):SizedBox.shrink(),
        ],
      ),
    );
  }
}


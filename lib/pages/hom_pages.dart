import 'package:flutter/material.dart';
import 'package:herewego/model/post_model.dart';
import 'package:herewego/pages/detail_page.dart';
import 'package:herewego/server/auth_server.dart';
import 'package:herewego/server/prefs_server.dart';
import 'package:herewego/server/rtdb_servis.dart';
class Hom_Page extends StatefulWidget {
  static final String id="hom_pages";
  const Hom_Page({Key? key}) : super(key: key);

  @override
  _Hom_PageState createState() => _Hom_PageState();
}

class _Hom_PageState extends State<Hom_Page> {
  List<Post> itms=[];
  var isLoading=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPost();
  }

  Future _doDetail()async{
    Map result=await Navigator.of(context).push(new MaterialPageRoute(
        builder:(BuildContext context){
          return new Detail_Page();
        }
    ));
    if(result!=null&& result.containsKey('data')){
      print(result['data']);
      _apiGetPost();
    }
  }
  _apiGetPost() async{
    setState(() {
      isLoading=true;
    });
    var id= await Prefs.loadUserId();
    RTDBServes.getPost(id).then((posts) =>{
      _respPost(posts),
    isLoading=false,
    });
  }
  _respPost(List<Post> posts){
    setState(() {
      itms=posts;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("All Post"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed:(){
                AuthServer.siginOutUser(context);
              },
              icon:Icon(Icons.exit_to_app,color:Colors.white),
          ),
        ],
      ),
      body:Stack(
        children: [
          ListView.builder(
              itemCount:itms.length,
              itemBuilder:(ctx,i){
                return _itmOflist(itms[i]);
              }
          ),
          isLoading?
          Center(
            child:CircularProgressIndicator(),
          ):SizedBox.shrink(),
        ],
      ),
      floatingActionButton:FloatingActionButton(
        onPressed:(){
         _doDetail();
        },
        child:Icon(Icons.add),
        backgroundColor:Colors.red,
      ),
    );
  }
  Widget _itmOflist(Post post){
    return SingleChildScrollView(
      child:Container(
       padding:EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Container(
              height:200,
              width:double.infinity,
              child:post.img_url!=null?
              Image.network(post.img_url,fit:BoxFit.cover,):
                  Image.asset('assets/images/defold.png'),
            ),
            SizedBox(height:10,),
            Row(
              children: [
                Text(post.lastName,style:TextStyle(color:Colors.black,fontSize: 20),),
                SizedBox(width: 10,),
                Text(post.firstName,style:TextStyle(color:Colors.black,fontSize: 20),),
              ],
            ),
            SizedBox(height: 10,),
            Text(post.data,style:TextStyle(color:Colors.black,fontSize:15),),
            SizedBox(height: 10,),
            Text(post.content,style:TextStyle(color:Colors.black,fontSize:15),),
          ],
        ),
      ),
    );
  }
}

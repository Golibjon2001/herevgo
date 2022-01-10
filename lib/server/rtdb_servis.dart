
import 'package:firebase_database/firebase_database.dart';
import 'package:herewego/model/post_model.dart';

class RTDBServes{
 static final _database=FirebaseDatabase.instance.reference();

 static Future<Stream<Event>> addPost(Post post)async{
   _database.child('post').push().set(post.toJson());
   return _database.onChildAdded;
 }

 static Future<List<Post>> getPost(String id)async{
   List <Post> itms=[];
   Query _query=_database.reference().child('post').orderByChild('userId').equalTo(id);
   var _shapshot=await _query.once();
   var result=_shapshot.value.values as Iterable;

   for(var item in result){
     itms.add(Post.fromJson(Map<String,dynamic>.from(item)));
   }
   return itms;
   }
 }


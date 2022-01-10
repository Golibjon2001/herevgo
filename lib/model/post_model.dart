class Post{
  String userId;
  String firstName;
  String lastName;
  String content;
  String data;
  String img_url;

  Post(this.userId,this.firstName,this.lastName,this.content,this.data,this.img_url);

  Post.fromJson( Map<String,dynamic>cast)
        :userId=cast['userId'],
        firstName=cast['firstName'],
        lastName=cast['lastName'],
        content=cast['content'],
        img_url=cast['img_url'],
        data=cast['data'];

  Map<String,dynamic> toJson()=>{
    'userId':userId,
    'firstName':firstName,
    'lastName':lastName,
    'content':content,
    'img_url':img_url,
    'data':data,
  };
}
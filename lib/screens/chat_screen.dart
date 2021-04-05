import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth =FirebaseAuth.instance;
 // User loggedInUser;
  String messageText;

  void initState(){
    super.initState();
      getCurrentUSer();
    }

  void getCurrentUSer() async{
    try{
    final user= await _auth.currentUser;
    if(user!=null) {
      loggedInUser = user;
     // print(loggedInUser.email);
    }
    }
    catch(e){
      print(e);
    }
  }

  // void messagesStream() async{
  //   await for (var snapshot in _firestore.collection('messages').snapshots()){
  //     for(var message in snapshot.docs){
  //       print(message.data);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
              //  messagesStream();
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
           MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      //messageText+loggedInUser.email
                      messageTextController.clear();
                       _firestore.collection('messages').add({
                         'text':messageText,
                         'sender': loggedInUser.email,
                         'timestamp': new DateTime.now(),
                       });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
      //stream: _firestore.collection('messages').snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              )
          );
        }

        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles= [];
        for(var message in messages){
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];

          final currentUser = loggedInUser.email;

          final messageBubble=MessageBubble(
              text: messageText,
              sender: messageSender,
             isMe: currentUser==messageSender,
          );

          messageBubbles.add(messageBubble);
        }
        //return Column(
        return Expanded(
          child: ListView(
            reverse: true,  // so that we always see the end of the of the chat and not the top
            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender,this.text, this.isMe});
  String text;
  String sender;
  bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children:[
          Text(
              sender,
          style:TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          )
          ),
       Material(
        color: isMe? Colors.lightBlueAccent : Colors.white,
         // borderRadius: BorderRadius.circular(30.0),
          borderRadius:  isMe? BorderRadius.only(
            topLeft: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0)
          )
            : BorderRadius.only(
             bottomLeft: Radius.circular(30.0),
             bottomRight: Radius.circular(30.0),
            topRight: Radius.circular(30.0)
          ),
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
        child: Text(
          '$text',
           style: TextStyle(
             fontSize: 15.0,
             color: isMe?  Colors.white : Colors.black54,
           ),
        ),
      ),
      ),
      ],
      ),
    );
  }
}
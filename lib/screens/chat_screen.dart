import 'package:flutter/material.dart';
import 'package:flash_chatting_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'registration_screen.dart';
import 'login_screen.dart';

final _firestore = FirebaseFirestore.instance;
User loggedinuser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String messagetext;
  final messagetextcontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinuser = user;
      }
    } catch (e) {
      print(e);
    }
  }

// void messagesstream() async{
//  await for(var snapshot in _firestore.collection('messages').snapshots()){
//
//    for (var msg  in snapshot.docs){
//    msg.data();
//  }
//  }
// }
// void getmessages() async{
// final messages =   await _firestore.collection('messages').getDocuments();
//  for (var msg  in messages.documents){
//    msg.data();
//  }
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
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            messagesstream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messagetextcontroller,
                      onChanged: (value) {
                        messagetext = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messagetextcontroller.clear();
                      _firestore.collection('messages').add({
                        'text': messagetext,
                        'sender': loggedinuser.email,
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

class messagesstream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<messagebubble> messageWidgets = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];
          final currentuser = loggedinuser.email;

          final messageBubble = messagebubble(
            text: messageText,
            sender: messageSender,
            isme: currentuser == messageSender,
          );
          messageWidgets.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class messagebubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isme;
  messagebubble({this.sender, this.text, this.isme});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12.0,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isme
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            color: isme ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isme ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:WhatsApp/unique_user.dart';
import './message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final UniqueUser user;
  ChatScreen({this.user});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _messages = [Message(message: 'hello')];
  String auth;
  String _selection;
  final _key = GlobalKey<FormState>();
  final String currentUser = FirebaseAuth.instance.currentUser.uid;
  final DatabaseReference db = FirebaseDatabase().reference();

  @override
  void initState() {
    auth = FirebaseAuth.instance.currentUser.uid;
    _messages.add(
      Message(
        message: 'hi',
        time: DateTime.now(),
        senderUid: widget.user.uid.toString(),
        reciverUid: auth.toString(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        leadingWidth: 10.0,
        backgroundColor: Color(0XFF075E54),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // IconButton(
            //   icon: Icon(Icons.arrow_back_sharp),
            //   onPressed: () {
            //     log('pop');
            //     Navigator.pop(context);
            //   },
            // ),
            // SizedBox(
            //   width: 5.0,
            // ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.fromLTRB(10.0, 7.0, 0.0, 7.0),
                child: CircleAvatar(
                  minRadius: 5.0,
                  maxRadius: 17.0,
                  backgroundImage: null,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              width: 5.0,
            ),
            Column(
              children: [
                Text(widget.user.userName),
                Text(
                  widget.user.name,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.videocam_rounded), onPressed: () {}),
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
          // IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _selection = value;
                if (_selection == '6') {
                  //this is not working
                  //TODO
                  PopupMenuButton<String>(
                    onSelected: (String value) {
                      setState(() {
                        _selection = value;
                      });
                    },

                    // child: IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          child: Text('Report'),
                          value: '61',
                        ),
                        const PopupMenuItem<String>(
                          child: Text('Block'),
                          value: '62',
                        ),
                        const PopupMenuItem<String>(
                          child: Text('Clear chat'),
                          value: '63',
                        ),
                        const PopupMenuItem<String>(
                          child: Text('Export chat'),
                          value: '64',
                        ),
                        const PopupMenuItem<String>(
                          child: Text('Add shortcut'),
                          value: '65',
                        ),
                      ];
                    },
                  );
                }
              });
            },

            // child: IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  child: Text('View contact'),
                  value: '1',
                ),
                const PopupMenuItem<String>(
                  child: Text('Media, links, and docs'),
                  value: '2',
                ),
                const PopupMenuItem<String>(
                  child: Text('Search'),
                  value: '3',
                ),
                const PopupMenuItem<String>(
                  child: Text('Mute notifications'),
                  value: '4',
                ),
                const PopupMenuItem<String>(
                  child: Text('Wallpaper'),
                  value: '5',
                ),
                const PopupMenuItem<String>(
                  child: Text('more'),
                  value: '6',
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        height:
            MediaQuery.of(context).size.height - AppBar().preferredSize.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                child: Expanded(
                  child: Container(
                      child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      StreamBuilder(
                        stream: FirebaseDatabase.instance
                            .reference()
                            .child('Messages')
                            .orderByChild('time')
                            .onValue,
                        builder: (context, snap) {
                          log(snap.toString());
                          if (!snap.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            // Map data = snap.data.snapshot.value;
                            // data.forEach((index, data) {
                            //   _messages.add(Message(
                            //     message: data.message,
                            //     reciverUid: data.reciverUid,
                            //     senderUid: data.senderUid,
                            //     time: data.time,
                            //   ));
                            // });
                            return ListView.builder(
                              itemCount: _messages.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.all(5.0),
                                  child: Text(_messages[index].message),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  )),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width * 0.165,
                              margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35.0),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              child: Form(
                                key: _key,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.sentiment_satisfied_alt_rounded,
                                        color: Colors.black54,
                                      ),
                                      onPressed: () {},
                                    ),
                                    Expanded(
                                      // height: MediaQuery.of(context).size.height * 0.08,
                                      // width: MediaQuery.of(context).size.width * 0.630,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          focusedBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          //border: InputBorder.none,
                                          hintText: 'Type a message',
                                        ),
                                      ),
                                    ),
                                    Transform.rotate(
                                      angle: 3.14 / 0.56,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.attach_file,
                                          color: Colors.black45,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.black45,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor:
                                  Color.fromRGBO(0, 135, 122, 0.89),
                              maxRadius: MediaQuery.of(context).size.width *
                                  0.05599999,
                              child: IconButton(
                                iconSize:
                                    MediaQuery.of(context).size.width * 0.065,
                                icon: Icon(
                                  Icons.mic,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

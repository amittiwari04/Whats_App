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
  double _inputHeight = 50;
  void _checkInputSize() async {
    int count = _text.text.split('\n').length;
    if (count == 0 && _inputHeight == 50) {
      return;
    }
    if (count <= 5) {
      var newHeight = count == 0 ? 50.0 : 28.0 + (count + 18.0);
      setState(() {
        _inputHeight = newHeight;
      });
    }
  }

  _buildMessage(Message message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
              right: 5.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 15.0,
      ),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Colors.lightGreen[200] : Colors.white,
        borderRadius: isMe
            ? BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0),
              )
            : BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Wrap(
            children: [
              Text(
                message.message,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // SizedBox(
              //   height: 5.0,
              // ),
              // Text(
              //   message.time.toIso8601String(),
              //   style: TextStyle(
              //     color: Colors.grey,
              //     fontSize: 16.0,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );

    return msg;
  }

  TextEditingController _text = TextEditingController();
  List<Message> _messages = [];
  String auth;
  String _selection;
  final _key = GlobalKey<FormState>();
  final String currentUser = FirebaseAuth.instance.currentUser.uid;
  final DatabaseReference db = FirebaseDatabase().reference();

  getData() async {
    FirebaseDatabase.instance
        .reference()
        .child('ChatRooms')
        .child(currentUser)
        .child(widget.user.uid)
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map;
      if (data != null) {
        _messages = [];
        data.forEach((key, value) {
          _messages.add(
            Message(
              message: value['message'],
              senderUid: value['senderUid'],
              reciverUid: value['reciverUid'],
              time: DateTime.tryParse(value['time'].toString()),
            ),
          );
        });
        setState(() {
          _messages.sort(
            (Message a, Message b) => a.time.compareTo(b.time),
          );
        });
      }
    });
  }

  @override
  void initState() {
    auth = FirebaseAuth.instance.currentUser.uid;
    getData();
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
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.grey,
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height,
          child: Column(
            children: [
              // SizedBox(
              //   height: 20,
              // ),
              SafeArea(
                child: Container(
                  // color: Colors.pink[400],
                  // color: Colors.black,
                  height: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      90,
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final bool isMe =
                          currentUser == _messages[index].senderUid;
                      return _buildMessage(_messages[index], isMe);
                    },
                  ),
                ),
              ),
              Expanded(
                // flex: 2,
                child: Container(
                    // color: Colors.purple,

                    ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  // color: Colors.blue,
                  height: 50,
                  // height: 80,
                  // margin: EdgeInsets.all(2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? MediaQuery.of(context).size.height * 0.059
                              : 47,
                          margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            // mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                // color: Colors.yellow,
                                // height: 80,
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
                                        // height: _inputHeight,
                                        //  height: maxLine,
                                        // height: MediaQuery.of(context).size.height * 0.08,
                                        // width: MediaQuery.of(context).size.width * 0.630,
                                        child: TextFormField(
                                          textInputAction:
                                              TextInputAction.newline,
                                          keyboardType: TextInputType.multiline,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                          validator: (val) {
                                            // if(!val.trim().isEmpty){

                                            // }
                                            return null;
                                          },
                                          maxLines: 12,
                                          onChanged: (val) {
                                            _text.text = val.trim();
                                            // _checkInputSize();
                                            setState(() {});
                                          },
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
                                        child: _text.text == ''
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.attach_file,
                                                  color: Colors.black45,
                                                ),
                                                onPressed: () {},
                                              )
                                            : null,
                                      ),
                                      _text.text == ''
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.camera_alt_rounded,
                                                color: Colors.black45,
                                              ),
                                              onPressed: () {},
                                            )
                                          : Transform.rotate(
                                              angle: 3.14 / 0.56,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.attach_file,
                                                  color: Colors.black45,
                                                ),
                                                onPressed: () {},
                                              )),
                                    ],
                                  ),
                                ),
                              ),
                              _text.text != ''
                                  ? CircleAvatar(
                                      // minRadius: 38,
                                      backgroundColor:
                                          Color.fromRGBO(0, 135, 122, 0.89),
                                      maxRadius: MediaQuery.of(context)
                                                  .orientation ==
                                              Orientation.portrait
                                          ? MediaQuery.of(context).size.width *
                                              0.0559999
                                          : 40,
                                      child: IconButton(
                                        iconSize: MediaQuery.of(context)
                                                    .orientation ==
                                                Orientation.portrait
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.065
                                            : 35,
                                        icon: Icon(
                                          Icons.send,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          if (_text.text != null) {
                                            FirebaseDatabase.instance
                                                .reference()
                                                .child('ChatRooms')
                                                .child(currentUser)
                                                .child(widget.user.uid)
                                                .push()
                                                .update({
                                              'senderUid': currentUser,
                                              'reciverUid': widget.user.uid,
                                              'message': _text.text,
                                              'time': DateTime.now()
                                                  .millisecondsSinceEpoch
                                            }).then((val) {
                                              setState(() {
                                                _text.clear();
                                              });
                                            });

                                            FirebaseDatabase.instance
                                                .reference()
                                                .child('ChatRooms')
                                                .child(widget.user.uid)
                                                .child(currentUser)
                                                .push()
                                                .update({
                                              'senderUid': currentUser,
                                              'reciverUid': widget.user.uid,
                                              'message': _text.text,
                                              'time': DateTime.now()
                                                  .millisecondsSinceEpoch
                                            });
                                          }
                                        },
                                      ),
                                    )
                                  : CircleAvatar(
                                      // minRadius: 38,
                                      backgroundColor:
                                          Color.fromRGBO(0, 135, 122, 0.89),
                                      maxRadius: MediaQuery.of(context)
                                                  .orientation ==
                                              Orientation.portrait
                                          ? MediaQuery.of(context).size.width *
                                              0.0559999
                                          : 40,
                                      child: IconButton(
                                        iconSize: MediaQuery.of(context)
                                                    .orientation ==
                                                Orientation.portrait
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.065
                                            : 35,
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
              // Expanded(
              //   flex: 1,
              //   child: Container(
              //     // color: Colors.purple,
              //   ),
              // ),
              SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

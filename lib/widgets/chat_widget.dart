// import 'package:WhatsApp/HomeScreen/home_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// import '../login_screen.dart';
// import '../message.dart';

// class ChatWidget extends StatefulWidget {
//   @override
//   _ChatWidgetState createState() => _ChatWidgetState();
// }

// class _ChatWidgetState extends State<ChatWidget> {

//   getData() async {
//     FirebaseDatabase.instance
//         .reference()
//         .child('ChatRooms')
//         .child(currentUser)
//         .child(widget.user.uid)
//         .onValue
//         .listen((event) {
//       final data = event.snapshot.value as Map;
//       if (data != null) {
//         _messages = [];
//         data.forEach((key, value) {
//           _messages.add(
//             Message(
//               message: value['message'],
//               senderUid: value['senderUid'],
//               reciverUid: value['reciverUid'],
//               time: DateTime.tryParse(value['time'].toString()),
//             ),
//           );
//         });
//         setState(() {
//           _messages.sort(
//             (Message a, Message b) => a.time.compareTo(b.time),
//           );
//         });
//       }
//     });
//   }


//   Future<void> getCurrentUser() async {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       Future.delayed(Duration(seconds: 3)).then((value) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (BuildContext context) => LoginScreen(),
//           ),
//         );
//       });
//       return;
//     }

//     if (user != null) {
//       Future.delayed(Duration(seconds: 3)).then((value) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (BuildContext context) => HomeScreen(),
//           ),
//         );
//       });
//     }
//   }

//   TextEditingController _text = TextEditingController();
//   List<Message> _messages = [];
//   String auth;
//   String _selection;
//   final _key = GlobalKey<FormState>();
//   final String currentUser = FirebaseAuth.instance.currentUser.uid;
//   final DatabaseReference db = FirebaseDatabase().reference();

//   @override
//   void initState() {
//     auth = FirebaseAuth.instance.currentUser.uid;
//     getData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height:
//           MediaQuery.of(context).size.height - AppBar().preferredSize.height,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             // color: Colors.black26,
//             // height: MediaQuery.of(context).size.height -
//             //     AppBar().preferredSize.height -
//             //     90,
//             width: MediaQuery.of(context).size.width,
//             child: SafeArea(
//               child: Expanded(
//                 // height: 60.0,
//                 child: Container(
//                   // mainAxisSize: MainAxisSize.max,
//                   child: ListView.builder(
//                     itemCount: _messages.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Container(
//                         margin: EdgeInsets.all(5.0),
//                         child: Container(
//                           margin: EdgeInsets.all(5.0),
//                           child: Text(_messages[index].message),
//                         ),
//                       );
//                     },
//                   ),
//                   // StreamBuilder(
//                   //   stream: FirebaseDatabase.instance
//                   //       .reference()
//                   //       .child('ChatRooms')
//                   //       .child(currentUser)
//                   //       .child(widget.user.uid)
//                   //       .orderByChild('time')
//                   //       .onValue,
//                   //   builder: (context, snap) {

//                   //     log(snap.toString());
//                   //     if (!snap.hasData) {
//                   //       return Center(
//                   //         child: CircularProgressIndicator(),
//                   //       );
//                   //     } else {
//                   //       // Map data = snap.data.snapshot.value;
//                   //       // data.forEach((index, data) {
//                   //       //   _messages.add(Message(
//                   //       //     message: data.message,
//                   //       //     reciverUid: data.reciverUid,
//                   //       //     senderUid: data.senderUid,
//                   //       //     time: data.time,
//                   //       //   ));
//                   //       // });
//                   //       return ListView.builder(
//                   //         itemCount: _messages.length,
//                   //         itemBuilder: (BuildContext context, int index) {
//                   //           return Container(
//                   //             margin: EdgeInsets.all(5.0),
//                   //             child: Container(
//                   //               margin: EdgeInsets.all(5.0),
//                   //               child: Text(_messages[index].message),
//                   //             ),
//                   //           );
//                   //         },
//                   //       );
//                   //     }
//                   //   },
//                   // ),
//                 ),
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               // height: 80,
//               // margin: EdgeInsets.all(2.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Container(
//                       height: MediaQuery.of(context).orientation ==
//                               Orientation.portrait
//                           ? MediaQuery.of(context).size.height * 0.059
//                           : 47,
//                       margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
//                       width: MediaQuery.of(context).size.width,
//                       child: Row(
//                         // mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Container(
//                             // color: Colors.yellow,
//                             // height: 80,
//                             width: MediaQuery.of(context).size.width -
//                                 MediaQuery.of(context).size.width * 0.165,
//                             margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 2.0),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(35.0),
//                               border: Border.all(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             child: Form(
//                               key: _key,
//                               child: Row(
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(
//                                       Icons.sentiment_satisfied_alt_rounded,
//                                       color: Colors.black54,
//                                     ),
//                                     onPressed: () {},
//                                   ),
//                                   Expanded(
//                                     // height: MediaQuery.of(context).size.height * 0.08,
//                                     // width: MediaQuery.of(context).size.width * 0.630,
//                                     child: TextFormField(
//                                       validator: (val) {
//                                         // if(!val.trim().isEmpty){

//                                         // }
//                                         return null;
//                                       },
//                                       onChanged: (val) {
//                                         _text.text = val.trim();
//                                         setState(() {});
//                                       },
//                                       decoration: InputDecoration(
//                                         focusedBorder: InputBorder.none,
//                                         disabledBorder: InputBorder.none,
//                                         enabledBorder: InputBorder.none,
//                                         //border: InputBorder.none,
//                                         hintText: 'Type a message',
//                                       ),
//                                     ),
//                                   ),
//                                   Transform.rotate(
//                                     angle: 3.14 / 0.56,
//                                     child: _text.text == ''
//                                         ? IconButton(
//                                             icon: Icon(
//                                               Icons.attach_file,
//                                               color: Colors.black45,
//                                             ),
//                                             onPressed: () {},
//                                           )
//                                         : null,
//                                   ),
//                                   _text.text == ''
//                                       ? IconButton(
//                                           icon: Icon(
//                                             Icons.camera_alt_rounded,
//                                             color: Colors.black45,
//                                           ),
//                                           onPressed: () {},
//                                         )
//                                       : Transform.rotate(
//                                           angle: 3.14 / 0.56,
//                                           child: IconButton(
//                                             icon: Icon(
//                                               Icons.attach_file,
//                                               color: Colors.black45,
//                                             ),
//                                             onPressed: () {},
//                                           )),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           _text.text != ''
//                               ? CircleAvatar(
//                                   // minRadius: 38,
//                                   backgroundColor:
//                                       Color.fromRGBO(0, 135, 122, 0.89),
//                                   maxRadius:
//                                       MediaQuery.of(context).orientation ==
//                                               Orientation.portrait
//                                           ? MediaQuery.of(context).size.width *
//                                               0.0559999
//                                           : 40,
//                                   child: IconButton(
//                                     iconSize: MediaQuery.of(context)
//                                                 .orientation ==
//                                             Orientation.portrait
//                                         ? MediaQuery.of(context).size.width *
//                                             0.065
//                                         : 35,
//                                     icon: Icon(
//                                       Icons.send,
//                                       color: Colors.white,
//                                     ),
//                                     onPressed: () async {
//                                       if (_text.text != null) {
//                                         await FirebaseDatabase.instance
//                                             .reference()
//                                             .child('ChatRooms')
//                                             .child(currentUser)
//                                             .child(widget.user.uid)
//                                             .push()
//                                             .update({
//                                           'senderUid': currentUser,
//                                           'reciverUid': widget.user.uid,
//                                           'message': _text.text,
//                                           'time':
//                                               DateTime.now().toIso8601String(),
//                                         });

//                                         await FirebaseDatabase.instance
//                                             .reference()
//                                             .child('ChatRooms')
//                                             .child(widget.user.uid)
//                                             .child(currentUser)
//                                             .push()
//                                             .update({
//                                           'senderUid': currentUser,
//                                           'reciverUid': widget.user.uid,
//                                           'message': _text.text,
//                                           'time':
//                                               DateTime.now().toIso8601String(),
//                                         });

//                                         setState(() {
//                                           _text.clear();
//                                         });
//                                       }
//                                     },
//                                   ),
//                                 )
//                               : CircleAvatar(
//                                   // minRadius: 38,
//                                   backgroundColor:
//                                       Color.fromRGBO(0, 135, 122, 0.89),
//                                   maxRadius:
//                                       MediaQuery.of(context).orientation ==
//                                               Orientation.portrait
//                                           ? MediaQuery.of(context).size.width *
//                                               0.0559999
//                                           : 40,
//                                   child: IconButton(
//                                     iconSize: MediaQuery.of(context)
//                                                 .orientation ==
//                                             Orientation.portrait
//                                         ? MediaQuery.of(context).size.width *
//                                             0.065
//                                         : 35,
//                                     icon: Icon(
//                                       Icons.mic,
//                                       color: Colors.white,
//                                     ),
//                                     onPressed: () {},
//                                   ),
//                                 ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

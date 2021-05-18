import 'package:WhatsApp/chat_screen.dart';
import 'package:WhatsApp/login_screen.dart';
import 'package:WhatsApp/unique_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../database_service.dart';
import '../chat_screen.dart';

import 'dart:developer';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(
      context,
      (route) => route.isFirst,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  String _selection;
  TextEditingController controller = TextEditingController();

  // bool search = false;
  List<UniqueUser> _users = [];

  Future<void> _setUpUsers() async {
    List<UniqueUser> users = await DatabaseService.getUser();
    setState(() {
      _users = users;
    });
  }

  @override
  void initState() {
    _setUpUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0XFF075E54),
          title: Text(
            ' WhatsApp',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                iconSize: 29,
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ),
            // IconButton(
            //   icon: Icon(Icons.more_vert),
            //   onPressed: () async {
            // await FirebaseAuth.instance.signOut();
            // Navigator.popUntil(
            //   context,
            //   (route) => route.isFirst,
            // );
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => LoginScreen(),
            //   ),
            // );

            //   },
            // ),
            PopupMenuButton<String>(
              onSelected: (String value) {
                setState(() {
                  _selection = value;
                  if (_selection == '7') {
                    logout();
                  }
                });
              },

              // child: IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    child: Text('New group'),
                    value: '1',
                  ),
                  const PopupMenuItem<String>(
                    child: Text('New broadcast'),
                    value: '2',
                  ),
                  const PopupMenuItem<String>(
                    child: Text('WhatsApp Web'),
                    value: '3',
                  ),
                  const PopupMenuItem<String>(
                    child: Text('Starred messages'),
                    value: '4',
                  ),
                  const PopupMenuItem<String>(
                    child: Text('Payments'),
                    value: '5',
                  ),
                  const PopupMenuItem<String>(
                    child: Text('Settings'),
                    value: '6',
                  ),
                  const PopupMenuItem<String>(
                    child: Text('Logout'),
                    value: '7',
                  ),
                ];
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('CHATS'),
              ),
              Tab(
                child: Text('STATUS'),
              ),
              Tab(
                child: Text('CALLS'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Text('CHATS'),
            RefreshIndicator(
              onRefresh: () => _setUpUsers(),
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (BuildContext context, int index) {
                  log('hello');
                  UniqueUser user = _users[index];
                  return GestureDetector(
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            maxRadius: 28.0,
                            backgroundImage: null,
                          ),
                          title: Text(user.userName ?? 'no username'),
                          subtitle: Text(user.name ?? 'no name'),
                        ),
                        Divider(),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            user: user,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Text('STATUS'),
            Text('CALLS'),
          ],
        ),
      ),
    );
  }
}

import 'package:WhatsApp/HomeScreen/home_screen.dart';
import 'package:WhatsApp/unique_user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserNameScreen extends StatefulWidget {
  final String phone;
  final String uid;
  UserNameScreen(this.phone,this.uid);
  @override
  _UserNameScreenState createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {


  bool alreadyDefined=false;
  final _key = GlobalKey<FormState>();
  String userName;
  String name;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();

  
  Future<bool> checkUserName(String name) async {
    
    final data= await  FirebaseDatabase.instance.reference().child('User').child(widget.uid).orderByChild('userName').equalTo(name).once();
    if(data.value!=null){
      return true;
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              TextFormField(
                validator: (String val) {
                  if (val.isEmpty) {
                    return '*Please enter your name';
                  }
                  
                  return null;
                },
                
                onChanged: (val) {
                  name = val;
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  //border: InputBorder.none,
                  hintText: 'Enter your name',
                ),
                controller: _nameController,
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (String val) {
                  if (val.isEmpty || val.length == 0) {
                    return '*Please enter user_name';
                  }
                  if(alreadyDefined){
                    return 'This username is already taken.';
                  }
                  return null;
                },
                onChanged: (val) {
                  userName = val;
                },
                onFieldSubmitted: (String value){
                  checkUserName(value).then((exists){
                    alreadyDefined=exists;
                    
                  });
                 
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  //border: InputBorder.none,
                  hintText: 'Enter unique username',
                ),
                controller: _userNameController,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.green,
                ),
                margin: EdgeInsets.all(10),
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    if (_key.currentState.validate()) {
                      UniqueUser(userName: userName, name: name);
                      await FirebaseDatabase()
                          .reference()
                          .child('User')
                          .child(widget.uid)
                          .update({
                        'phoneNumber': widget.phone,
                        'userName': userName,
                        'name': name,
                      });
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

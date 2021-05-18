import 'package:WhatsApp/unique_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  static Future<List<UniqueUser>> getUser() async {
    DataSnapshot userSnapshot = await FirebaseDatabase.instance
        .reference()
        .child('User')
        .orderByChild('userName')
        .once();

    List<UniqueUser> user = [];

    Map<dynamic, dynamic> values = userSnapshot.value;

    values.forEach((key, value) {
      user.add(UniqueUser(
        uid: key,
        name: value['name'],
        userName: value['userName'],
      ));
    });

    user.removeWhere(
      (element) => FirebaseAuth.instance.currentUser.uid == element.uid,
    );

    return user;
  }

  
}

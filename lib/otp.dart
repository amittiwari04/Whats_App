import 'dart:developer';

import 'package:WhatsApp/HomeScreen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  OtpScreen(this.phone);
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificaitonCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
          'OTP Verification',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 40,
            ),
            child: Center(
              child: Text(
                'Verify  +91-${widget.phone}',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: PinPut(
              fieldsCount: 6,
              textStyle: TextStyle(
                fontSize: 25.0,
                color: Colors.white,
              ),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async {
                try {
                  log('test');
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                    verificationId: _verificaitonCode,
                    smsCode: pin,
                  ))
                      .then((value) async {
                    if (value.user != null) {
                      //print('pass to home');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                        (route) => route.isFirst,
                      );
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Invalid OTP'),
                  ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${widget.phone}',
      verificationCompleted: (PhoneAuthCredential credential) {
        FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            log('user logged in');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
              (route) => route.isFirst,
            );
          }
        }).catchError((e) {
          log(e.toString());
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(e.message),
        ));
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        setState(() {
          print('hiiiiiiiiiiiiiiiiiiiiih');
          //  print(verificationID);
          _verificaitonCode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          print(verificationID);
          _verificaitonCode = verificationID;
        });
      },
      timeout: Duration(seconds: 60),
    );
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }
}

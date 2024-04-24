import 'package:flutter/material.dart';
import 'package:ss/Modules/Owners/OwnersLandingPage.dart';
import 'package:ss/Modules/Students/studentsLanding.dart';

class Success extends StatefulWidget {
  String role = '';
  Success({required this.role, super.key});

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((value) {
      if (widget.role == "Student") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => StudentsLanding(),
            ),
            (route) => false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
          content: Text(
              "Registered and Logged In Successfully"),
          backgroundColor: Colors.green,
        ));
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => OwnersLanding(),
            ),
            (route) => false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
          content: Text(
              "Registered and Logged In Successfully"),
          backgroundColor: Colors.green,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset("assets/successgif.gif"),
          SizedBox(height: 15,),
          Text("Registration Successful",style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),),
        ],
      ),
    );
  }
}

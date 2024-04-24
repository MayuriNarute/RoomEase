

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ss/Modules/Admin/studentsVerification.dart';
import 'package:ss/Modules/Owners/OwnersLandingPage.dart';
import 'package:ss/Modules/Students/studentsLanding.dart';

import 'Authentication/Presentation/registerScreen.dart';
import 'firebase_options.dart';
import 'ownerOrStudent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RoomEase',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
   MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String role = '';
  String isLoggedIn = '';
  Future<void> fetchRole() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    if (_auth.currentUser != null && _auth.currentUser!.uid.isNotEmpty) {
      final CollectionReference ref =
          FirebaseFirestore.instance.collection("Users");
      QuerySnapshot snapshot =
          await ref.where("userId", isEqualTo: _auth.currentUser!.uid).get();
      if (snapshot.docs.isNotEmpty) {
        String role = await snapshot.docs.first["role"];
        setState(() {
          isLoggedIn = _auth.currentUser!.uid;
          this.role = role;
        });
        print(isLoggedIn);
      } else {
        print("user is not present in collection");
      }
    }
  }

  Future<void> callFun() async {
    await fetchRole();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRole();
  }

  @override
  Widget build(BuildContext context) {
    return this.role == "Admin" && this.isLoggedIn != ''
        ? StudentsVerification()
        : this.role == "Owner" && this.isLoggedIn != ''
            ? OwnersLanding()
            : this.role == "Student" && this.isLoggedIn != ''
                ? StudentsLanding()
                : Scaffold(
                    body: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "RoomEase",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 35),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Image.asset("assets/hostell.jpg"),
                          SizedBox(
                            height: 25,
                          ),
Text("Lookig for a PG in your Region..?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey),),
                          SizedBox(height: 15,),
                          Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: Container(
                              width: 250,
                              height: 50,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.black),
                                    foregroundColor:
                                        MaterialStatePropertyAll(Colors.white)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChooseOwnerOrStudent(),
                                      ));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Get Started"),
                                    Icon(Icons.arrow_forward)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
  }

}

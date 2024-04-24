import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ss/Authentication/Presentation/login.dart';
import 'package:ss/Modules/Students/studentsLanding.dart';
import 'package:ss/Modules/collegeProfile.dart';

import '../../Modules/Owners/OwnersLandingPage.dart';
import 'Success.dart';

class RegisterScreen extends StatefulWidget {
  String selectedRole = '';
  RegisterScreen({required this.selectedRole, super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  bool isPicked = false;
  Future<void> _pickPdf() async {
    setState(() {
      isPicked = false;
    });
    print("object");
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
        isPicked = true;
      });
    }
  }

  bool isUploading = false;
  File? _pdfFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  TextEditingController collegeName = TextEditingController();

  Future<void> _uploadFile() async {
    setState(() {
      isUploading = true;
    });
    if (_pdfFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please pick the file")));
      setState(() {
        isUploading = false;
      });
      return;
    }

    try {
      print("now adding the url");
      User? user = _auth.currentUser;
      String downloadUrl = '';
      if (user != null) {
        String userId = user.uid;
        Reference storageRef =
            _storage.ref().child('users/$userId/college_identity.pdf');

        await storageRef.putFile(_pdfFile!).then((p0) async{
          await storageRef.getDownloadURL().then((value) {
             downloadUrl = value;
            print("downlaod url is ${downloadUrl}");
          });
        }).then((value) async {
          final CollectionReference db =
              FirebaseFirestore.instance.collection("Users");
          QuerySnapshot snapshot = await db
              .where("userId", isEqualTo: "${_auth.currentUser!.uid}")
              .get();
          if (snapshot.docs.isNotEmpty) {
            print("got the doc");
            print("id it sdlfn ${downloadUrl}");
            await snapshot.docs.first.reference.update({
              "isVerified": false,
              "collegeIdentityUrl": downloadUrl,
            });
            print("userId told that is not verified");
          }else{
            print("not document found for uploading the url");
          }
          setState(() {
            isUploading = false;
          });
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => NextPage()),
          // );
        });
        // File uploaded successfully, navigate to next page
      }
    } catch (e) {
      // Handle upload error
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "RoomEase",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                  ),
                ),
                SizedBox(height: 15,),


                // ===========login form===========
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 150,
                        child: TextField(
                          controller: firstName,
                          decoration: InputDecoration(
                              label: Text("First Name"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: TextField(
                          controller: lastName,
                          decoration: InputDecoration(
                              label: Text("Last Name"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextField(
                    controller: emailAddress,
                    decoration: InputDecoration(
                        label: Text("Email Address"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                        label: Text("Password"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                if(widget.selectedRole=='Student')
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextField(
                    controller: collegeName,
                    decoration: InputDecoration(
                        label: Text("College Name"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),

                SizedBox(
                  height: 15,
                ),
                if (widget.selectedRole == "Student")
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            // color: Colors.grey,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey, width: 1.2)),
                        width: MediaQuery.of(context).size.width - 100,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Upload College Identity",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              if (isPicked == false)
                                InkWell(
                                    onTap: () {
                                      _pickPdf();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.upload_file),
                                    )),
                              if (isPicked == true)
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 30,
                                ),
                            ],
                          )),
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.black),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white)),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final FirebaseAuth _auth = FirebaseAuth.instance;
                            await _auth
                                .createUserWithEmailAndPassword(
                                    email: emailAddress.text.trim(),
                                    password: password.text.trim())
                                .then((value) async {
                              print(
                                  "user Created now adding the details in collections");
                              if (widget.selectedRole == "Owner") {
                                final CollectionReference ownersCollection =
                                    FirebaseFirestore.instance
                                        .collection("Owners");
                                final CollectionReference usersCollection =
                                    FirebaseFirestore.instance
                                        .collection("Users");

                                Map<String, dynamic> ownerData = {
                                  "userId": value.user!.uid,
                                  "FirstName": "${firstName.text.trim()}",
                                  "lastName": "${lastName.text.trim()}",
                                  "emailAddress": "${emailAddress.text.trim()}",
                                  "role": "${widget.selectedRole}",
                                };
                                //adding to owners collection
                                await ownersCollection.doc().set(ownerData);
                                //adding to usersCollection
                                await usersCollection.doc().set({
                                  "userId": value.user!.uid,
                                  "role": "${widget.selectedRole}",
                                });
                                setState(() {
                                  isLoading = false;
                                });

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Success(role: widget.selectedRole,),
                                    ),
                                    (route) => false);
                                print("data added");
                              } else if (widget.selectedRole == "Student") {
                                setState(() {
                                  isLoading = true;
                                });
                                final CollectionReference studentsCollection =
                                    FirebaseFirestore.instance
                                        .collection("Students");
                                final CollectionReference usersCollection =
                                    FirebaseFirestore.instance
                                        .collection("Users");
                                Map<String, dynamic> ownerData = {
                                  "userId": value.user!.uid,
                                  "FirstName": "${firstName.text.trim()}",
                                  "lastName": "${lastName.text.trim()}",
                                  "emailAddress": "${emailAddress.text.trim()}",
                                  "role": "${widget.selectedRole}",
                                  "isRequested":"No",
                                };
                                //adding to owners collection
                                await studentsCollection.doc().set(ownerData);
                                //adding to usersCollection
                                await usersCollection.doc().set({
                                  "userId": value.user!.uid,
                                  "role": "${widget.selectedRole}",
                                  "isVerified": false,
                                  "isProfileFilled": false,
                                });
                                print("student data data added");
                                await _uploadFile();
                                setState(() {
                                  isLoading = false;
                                });
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(SnackBar(
                                //   content: Text(
                                //       "Registered and Logged In Successfully"),
                                //   backgroundColor: Colors.green,
                                // ));
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Success(role: widget.selectedRole,)),
                                    (route) => false);
                              }
                            });
                          }  catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("Error")));
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: Text("Register")),
                    if (isLoading == true)
                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          CircularProgressIndicator()
                        ],
                      )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    child: Row(
                  children: [
                    Text("Already have a account?"),
                    SizedBox(
                      width: 15,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                            (route) => false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'dart:ui';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:ss/Modules/Students/studentsLanding.dart';
//
// import '../ownerOrStudent.dart';
//
// class CollegeProfilePage extends StatefulWidget {
//   @override
//   _CollegeProfilePageState createState() => _CollegeProfilePageState();
// }
//
// class _CollegeProfilePageState extends State<CollegeProfilePage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   String _userName = '';
//   String _userDetails = '';
//   File? _pdfFile;
//   TextEditingController fullname = TextEditingController();
//   TextEditingController collegEName = TextEditingController();
//   bool isUploading = false;
//   Future<void> _uploadFile() async {
//     setState(() {
//       isUploading = true;
//     });
//     if (_pdfFile == null) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Please pick the file")));
//       setState(() {
//         isUploading = false;
//       });
//       return;
//     }
//
//     try {
//       User? user = _auth.currentUser;
//       String downloadUrl = '';
//       if (user != null) {
//         String userId = user.uid;
//         Reference storageRef =
//             _storage.ref().child('users/$userId/college_identity.pdf');
//
//         await storageRef.putFile(_pdfFile!).then((p0) {
//           storageRef.getDownloadURL().then((value) {
//             downloadUrl = value;
//             print("downlaod url is ${downloadUrl}");
//           });
//         }).then((value) async {
//           final CollectionReference db =
//               FirebaseFirestore.instance.collection("Users");
//           QuerySnapshot snapshot = await db
//               .where("userId", isEqualTo: "${_auth.currentUser!.uid}")
//               .get();
//           if (snapshot.docs.isNotEmpty) {
//             print("got the doc");
//             print("id it sdlfn ${downloadUrl}");
//             await snapshot.docs.first.reference.update({
//               "isVerified": false,
//               "identityVerification": downloadUrl,
//             });
//             print("userId told that is not verified");
//           }
//           setState(() {
//             isUploading = false;
//           });
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => NextPage()),
//           );
//         });
//         // File uploaded successfully, navigate to next page
//       }
//     } catch (e) {
//       // Handle upload error
//       print('Error uploading file: $e');
//     }
//   }
//
//   Future<void> _pickPdf() async {
//     print("object");
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
//
//     if (result != null) {
//       setState(() {
//         _pdfFile = File(result.files.single.path!);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection("Users")
//             .where("userId", isEqualTo: "${_auth.currentUser!.uid}")
//             .snapshots(),
//         builder: (context, snapshot) {
//           var data = snapshot.data;
//           if (data!.docs.first['isProfileFilled'] == false) {
//             return Scaffold(
//               body: SafeArea(
//                 child: Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     // crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Center(
//                         child: Text(
//                           "Welcome",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 18),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 25,
//                       ),
//                       Center(
//                         child: Text(
//                           "Please Complete your student Profile",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Container(
//                         width: 250,
//                         child: TextField(
//                           decoration: InputDecoration(
//                               labelText: 'Full Name',
//                               border: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.grey, width: 0.2),
//                                   borderRadius: BorderRadius.circular(15))),
//                           onChanged: (value) {
//                             setState(() {
//                               _userName = value;
//                             });
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 16.0),
//                       Container(
//                         width: 250,
//                         child: TextField(
//                           decoration: InputDecoration(
//                               labelText: 'College Name',
//                               border: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.grey, width: 0.2),
//                                   borderRadius: BorderRadius.circular(15))),
//                           onChanged: (value) {
//                             setState(() {
//                               _userDetails = value;
//                             });
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 16.0),
//                       Container(
//                         width: 250,
//                         height: 50,
//                         child: ElevatedButton(
//                           style: ButtonStyle(
//                               foregroundColor:
//                                   MaterialStatePropertyAll(Colors.white),
//                               backgroundColor:
//                                   MaterialStatePropertyAll(Colors.black)),
//                           onPressed: () {
//                             _pickPdf();
//                           },
//                           child: isUploading
//                               ? CircularProgressIndicator()
//                               : Text('Upload College Identity'),
//                         ),
//                       ),
//                       SizedBox(height: 16.0),
//                       ElevatedButton(
//                         style: ButtonStyle(
//                             foregroundColor:
//                                 MaterialStatePropertyAll(Colors.green),
//                             backgroundColor:
//                                 MaterialStatePropertyAll(Colors.black)),
//                         onPressed: () {
//                           _uploadFile();
//                           print(_auth.currentUser!.uid);
//                         },
//                         child: Text('Proceed'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return NextPage();
//           }
//         });
//   }
// }
//
// class NextPage extends StatefulWidget {
//   @override
//   State<NextPage> createState() => _NextPageState();
// }
//
// class _NextPageState extends State<NextPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection("Users")
//             .where("userId", isEqualTo: "${_auth.currentUser!.uid}")
//             .snapshots(),
//         builder: (context, snapshot) {
//           var data = snapshot.data;
//           if (data!.docs.first['isVerified'] == false) {
//             return Scaffold(
//               body: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Center(
//                     child: Text(
//                       'You are not yet verified.',
//                       style: TextStyle(fontSize: 18, color: Colors.red),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                     "Our team will revert back to you soon",
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   ElevatedButton(
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStatePropertyAll(Colors.black),
//                           foregroundColor:
//                               MaterialStatePropertyAll(Colors.white)),
//                       onPressed: () async {
//                         final FirebaseAuth _auth = FirebaseAuth.instance;
//                         await _auth.signOut().then((value) {
//                           Navigator.pushAndRemoveUntil(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ChooseOwnerOrStudent(),
//                               ),
//                               (route) => false);
//                         });
//                       },
//                       child: Text("Logout"))
//                 ],
//               ),
//             );
//           } else {
//             return StudentsLanding();
//           }
//         });
//   }
// }

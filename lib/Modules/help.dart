import 'package:flutter/material.dart';
class HelpContent {
  final String question;
  final String answer;

  HelpContent({
    required this.question,
    required this.answer,
  });
}
class HelpScreen extends StatelessWidget {
  final List<HelpContent> helpContents = [
    HelpContent(
      question: 'How can I retrieve details about a hostel property I own in the app?',
      answer: 'To retrieve details about your hostel property, log in to the app, navigate to the "My Hostels" section, select the desired locations through dropdo, and view information such as property name, location, amenities, and occupancy status',
    ),


    // Add more help contents as needed
  ];
  double Fontdouble =20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:20,),
                Text(
                  textAlign: TextAlign.left,
                  "Help",
                  style: TextStyle(
                    fontSize:Fontdouble,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 25,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height:500,
                  child: ListView.builder(
                    itemCount: helpContents.length,
                    itemBuilder: (context, index) {
                      return HelpExpansionTile(helpContent: helpContents[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HelpExpansionTile extends StatelessWidget {
  final HelpContent helpContent;

  HelpExpansionTile({required this.helpContent});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ExpansionTile(

        title: Text(
          helpContent.question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              helpContent.answer,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
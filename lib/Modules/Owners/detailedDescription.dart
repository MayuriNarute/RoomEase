import 'package:flutter/material.dart';

class PgDetailedView extends StatefulWidget {
  List<dynamic> urls = [];
  List<dynamic> amenities = [];
  List<dynamic> rooms = [];
  String name = '';
  String des = '';
  PgDetailedView(
      {required this.name,
      required this.des,
      required this.amenities,
      required this.rooms,
      required this.urls,
      super.key});

  @override
  State<PgDetailedView> createState() => _PgDetailedViewState();
}

class _PgDetailedViewState extends State<PgDetailedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.name}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                    child: Container(
                        width: MediaQuery.of(context).size.width - 50,
                        child: Divider(
                          thickness: 2,
                        ))),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.shade100),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(50),
                        // color: Colors.black
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.urls.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: Container(
                                  width: 200,
                                  height: 550,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.network(
                                          fit: BoxFit.fill,
                                          "${widget.urls[index]}")),
                                )),
                                SizedBox(
                                  width: 15,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("${widget.des}"),
                ],
              ),
            ),
            Center(
                child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Divider(
                      thickness: 2,
                    ))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amenities",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  // SizedBox(height: 20,),
                  Container(
                    height: 50,
                    child: ListView.builder(
                      itemCount: widget.amenities.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        String image = '';
                        if (widget.amenities[index] == "Washing Machine") {
                          image = "assets/laundry.png";
                        } else if (widget.amenities[index] == "Parking") {
                          image = "assets/parked-car.png";
                        } else if (widget.amenities[index] == "Mess") {
                          image = "assets/dinner.png";
                        } else if (widget.amenities[index] == "Solar Water") {
                          image = "assets/heater.png";
                        }
                        return Row(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Image.asset(width: 40, image),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "${widget.amenities[index]}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Center(
                child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Divider(
                      thickness: 2,
                    ))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rooms Available",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  // SizedBox(height: 20,),
                  Container(
                    height: 100,
                    child: ListView.builder(
                      itemCount: widget.rooms.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Type:- ${widget.rooms[index]["roomType"]}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      "Price:- ${widget.rooms[index]["price"]}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      "Occupants:- ${widget.rooms[index]["occupants"]}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Center(
                child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Divider(
                      thickness: 2,
                    ))),
          ],
        ),
      ),
    );
  }
}

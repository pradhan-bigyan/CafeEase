import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:kyafeease/pages/buttomnav.dart';
import 'package:kyafeease/pages/login.dart';
import 'package:kyafeease/widgets/widget_support.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({Key? key}) : super(key: key);

  @override
  _StartingPageState createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  void checkAuthentication() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 246, 245, 247),
              Color.fromARGB(255, 180, 69, 69),
              Color.fromARGB(255, 237, 240, 243),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
          children: [
            SizedBox(height: 40),
             Text(
          "Welcome to CafeEase☕️",
          style: AppWidget.HeaderTextFieldStyle(),
        ),
            
            FadeInRight(
              duration: Duration(milliseconds: 1500),
              child: Image.asset(
                'images/coffee.gif', // Path to the asset GIF
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10,),
            Text(
          "Customer Reviews: ",
          style: AppWidget.semiboldTextFieldStyle(),
        ),
            Expanded(
              child: StreamBuilder(
                
                stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Text('No reviews yet.'));
                  }

                  return ListView(
                    scrollDirection: Axis.vertical,
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      String userName = data['userName'];
                      String profileUrl = data['profileUrl'];
                      double rating = data['rating'];
                      Timestamp timestamp = data['timestamp'];
                      String reviewText = data['reviewText']; // Assuming this field exists in your database
                      String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(timestamp.toDate());

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(profileUrl),
                                ),
                                title: Text(userName),
                                subtitle: Text(formattedDate),
                              ),
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < rating ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                  );
                                }),
                              ),
                              SizedBox(height: 10),
                              Text(
                                reviewText,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            FadeInUp(
              duration: Duration(milliseconds: 1000),
              delay: Duration(milliseconds: 500),
              child: Container(
                padding: EdgeInsets.only(left: 50, top: 40, right: 20, bottom: 50),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffFFC3A6).withOpacity(0.5),
                      offset: Offset(0, -5),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      delay: Duration(milliseconds: 1000),
                      from: 50,
                      child: Text(
                        'Discover the best \norganic नेपाली tea.🔥',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      delay: Duration(milliseconds: 1000),
                      from: 60,
                      child: Text(
                        'Straight from cafeease',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      delay: Duration(milliseconds: 1000),
                      from: 70,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                           checkAuthentication();
                          },
                          child: Text(
                            'EXPLORE NOW ☕️',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

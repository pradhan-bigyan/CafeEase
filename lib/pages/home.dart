import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:kyafeease/pages/details.dart";
import "package:kyafeease/pages/order.dart";
import "package:kyafeease/services/database.dart";
import "package:kyafeease/widgets/widget_support.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool tea = false, coffee = false, cake = false, drink = false;
  User? user = FirebaseAuth.instance.currentUser;
  String userName = "User";
  Stream? cafeitemStream;
  ontheload()async{ 
    fetchUserDetails();
   cafeitemStream = await DatabaseMethods().getCafeitem("Coffee");
setState(() {
  
});
  }
  
  @override
  void initState() {
   ontheload();
    super.initState();
  }
   Future<void> fetchUserDetails() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['Name'] ?? 'User';
  
        });
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }
  Widget allItemsvertically(){
    return StreamBuilder(stream: cafeitemStream, builder: (context, AsyncSnapshot snapshot){
      return snapshot.hasData? ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: snapshot.data.docs.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index){
          DocumentSnapshot ds = snapshot.data.docs[index];
          return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> Details(detail: ds["Detail"], name:ds["Name"], price: ds["Price"], image: ds["Image"],)));
                  },
                  child:Container(
            padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        ds["Image"],
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    Column(children: [
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: Text(ds["Name"], style: AppWidget.semiboldTextFieldStyle(),)),
                        SizedBox(height: 5.0,),
                          Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: Text("ताजा ताजा  ", style: AppWidget.lightTextFieldStyle(),)),
                        SizedBox(height: 5.0,),
                          Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: Text("रु"+ds["Price"], style: AppWidget.semiboldTextFieldStyle(),))
                    ],)
                  ],
                ),
              ),
            ),
          ),
                );

      }):CircularProgressIndicator();

    });
  }
  
  Widget allItems(){
    return StreamBuilder(stream: cafeitemStream, builder: (context, AsyncSnapshot snapshot){
      return snapshot.hasData? ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: snapshot.data.docs.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index){
          DocumentSnapshot ds = snapshot.data.docs[index];
          return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> Details(detail: ds["Detail"], name:ds["Name"], price: ds["Price"], image: ds["Image"],)));
                  },
                  child: Container(
                    margin: EdgeInsets.all(3),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                ds["Image"],
                                height: 175,
                                width: 175,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              ds["Name"],
                              style: AppWidget.semiboldTextFieldStyle(),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "ताजा ताजा ",
                              style: AppWidget.lightTextFieldStyle(),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "रु"+ds["Price"],
                              style: AppWidget.semiboldTextFieldStyle(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );

      }):CircularProgressIndicator();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
                margin: EdgeInsets.only(
          top: 50.0,
          left: 10.0,
                ),
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hello"+" "+userName, style: AppWidget.boldTextFieldStyle()),
                Container(
                  margin: EdgeInsets.only(right: 20.0),
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: GestureDetector(
                    onTap: (){
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderPage()),
                      );
                    },
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: Color.fromARGB(255, 195, 142, 159),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Text("स्वादिस्ट food", style: AppWidget.HeaderTextFieldStyle()),
            Text("Delicious and have great food",
                style: AppWidget.lightTextFieldStyle()),
            SizedBox(
              height: 20.0,
            ),
            Container(margin: EdgeInsets.only(right: 20.0), child: showItem()),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 300,
              child: allItems()),
            SizedBox(
              height: 50.0,
            ),
          allItemsvertically(),
          ],
                ),
              ),
        ));
  }

  Widget showItem() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      GestureDetector(
        onTap: () async{
          coffee = true;
          tea = false;
          cake = false;
          drink = false;
          cafeitemStream = await DatabaseMethods().getCafeitem("Coffee");
          setState(() {});
        },
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
                color: coffee ? Color.fromARGB(255, 180, 69, 69) : Colors.white,
                borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.all(8),
            child: Image.asset(
              "images/coffeelogo.png",
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () async{
          coffee = false;
          tea = true;
          cake = false;
          drink = false;
          cafeitemStream = await DatabaseMethods().getCafeitem("Tea");
          setState(() {});
        },
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
                color: tea ? Color.fromARGB(255, 180, 69, 69) : Colors.white,
                borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.all(8),
            child: Image.asset(
              "images/chiyalogo.png",
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () async{
          coffee = false;
          tea = false;
          cake = true;
          drink = false;
           cafeitemStream = await DatabaseMethods().getCafeitem("Cake");
          setState(() {});
        },
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
                color: cake ? Color.fromARGB(255, 180, 69, 69) : Colors.white,
                borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.all(8),
            child: Image.asset(
              "images/pastrylogo.png",
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () async{
          coffee = false;
          tea = false;
          cake = false;
          drink = true;
           cafeitemStream = await DatabaseMethods().getCafeitem("Drinks");
          setState(() {});
        },
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
                color: drink ? Color.fromARGB(255, 180, 69, 69) : Colors.white,
                borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.all(8),
            child: Image.asset(
              "images/drink.png",
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ]);
  }
}

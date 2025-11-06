import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:kyafeease/pages/home.dart';
import 'package:kyafeease/pages/order.dart';
import 'package:kyafeease/pages/profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late OrderPage order;
  late Profile profile;
// wallet to be implemented
// late Wallet profile;

  @override
  void initState() {
    homepage=Home();
    order=OrderPage();
    profile=Profile();
    pages=[homepage,order,profile];
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        color: Color.fromARGB(255, 180, 69, 69),

        animationDuration: Duration(milliseconds: 500),
        onTap: (int index){
         setState(() {
           currentTabIndex = index;
         }); 
        },
        items: [
        Icon(
          Icons.home_outlined,
          color: Colors.black,
        ),
         Icon(
          Icons.shopping_bag_outlined,
           color: Colors.black,
        ),
         Icon(
          Icons.person_2_outlined,
          color: Colors.black,
        )
      ]),
      body: pages[currentTabIndex]
    );
  }
}

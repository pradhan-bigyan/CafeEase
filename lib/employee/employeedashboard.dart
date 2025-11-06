import 'package:flutter/material.dart';
import 'package:kyafeease/employee/completed_orders.dart';
import 'package:kyafeease/employee/employee_vieworders.dart';
import 'package:kyafeease/widgets/widget_support.dart';

class Employeedashboard extends StatefulWidget {
  const Employeedashboard({super.key});

  @override
  State<Employeedashboard> createState() => _EmployeedashboardState();
}

class _EmployeedashboardState extends State<Employeedashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Employee Dashboard",
                  style: AppWidget.HeaderTextFieldStyle(),
                ),
              ),
              SizedBox(height: 50.0,),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeOrdersPage()));
                },
                child: Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 180, 69, 69),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Image.asset("images/pastrylogo.png", height: 100, width: 100, fit: BoxFit.cover,),
                          ),
                          SizedBox(width: 30.0,),
                          Text(
                            "View Orders",
                            style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.0,),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedOrdersPage()));
                },
                child: Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 180, 69, 69),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Image.asset("images/pastrylogo.png", height: 100, width: 100, fit: BoxFit.cover,),
                          ),
                          SizedBox(width: 30.0,),
                          Text(
                            "Completed Orders",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.0,),
              GestureDetector(
                onTap: () {
                  // Implement the logout logic here
                  Navigator.of(context).pop();
                },
                child: Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 180, 69, 69),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.logout, size: 100, color: Colors.white),
                          ),
                          SizedBox(width: 30.0,),
                          Text(
                            "Logout",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

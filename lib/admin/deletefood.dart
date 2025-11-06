import 'package:flutter/material.dart';
import 'package:kyafeease/services/database.dart';
import 'package:kyafeease/widgets/widget_support.dart';

class Deletefood extends StatefulWidget {
  const Deletefood({super.key});

  @override
  State<Deletefood> createState() => _ModifyFoodState();
}

class _ModifyFoodState extends State<Deletefood> {
  TextEditingController namecontroller = TextEditingController();

  deleteItem() async {
    String itemName = namecontroller.text;

    if (itemName.isNotEmpty) {
      bool itemDeleted = await DatabaseMethods().deleteFoodItem(itemName);

      if (itemDeleted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color.fromARGB(255, 180, 69, 69),
          content: Text(
            "Food Item has been deleted Successfully",
            style: TextStyle(fontSize: 18.0),
          ),
        ));
        namecontroller.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color.fromARGB(255, 180, 69, 69),
          content: Text(
            "Failed to delete Food Item. Please check the item name.",
            style: TextStyle(fontSize: 18.0),
          ),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: const Color.fromARGB(255, 180, 69, 69),
        content: Text(
          "Item name cannot be empty.",
          style: TextStyle(fontSize: 18.0),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: const Color.fromARGB(255, 180, 69, 69),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Modify Food Item",
          style: AppWidget.HeaderTextFieldStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Item Name",
                style: AppWidget.semiboldTextFieldStyle(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 237, 225, 225),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter item name",
                      hintStyle: AppWidget.lightTextFieldStyle()),
                ),
              ),
              SizedBox(height: 40.0,),
              GestureDetector(
                onTap: () {
                  deleteItem();
                },
                child: Center(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      width: 150,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 180, 69, 69),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Delete",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

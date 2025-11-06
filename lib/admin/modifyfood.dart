import 'package:flutter/material.dart';
import 'package:kyafeease/services/database.dart';
import 'package:kyafeease/widgets/widget_support.dart';

class ModifyFood extends StatefulWidget {
  const ModifyFood({super.key});

  @override
  State<ModifyFood> createState() => _ModifyFoodState();
}

class _ModifyFoodState extends State<ModifyFood> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController newNameController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController newDetailController = TextEditingController();
  final List<String> items = ['Coffee', 'Tea', 'Cake', 'Drinks'];
  String? newCategory;

  updateItem() async {
    String itemName = namecontroller.text;
    String? newName = newNameController.text.isNotEmpty ? newNameController.text : null;
    String? newPrice = newPriceController.text.isNotEmpty ? newPriceController.text : null;
    String? newDetail = newDetailController.text.isNotEmpty ? newDetailController.text : null;

    if (itemName.isNotEmpty) {
      bool itemUpdated = await DatabaseMethods().updateFoodItem(
        itemName,
        newName,
        newPrice,
        newDetail,
        newCategory,
      );

      if (itemUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color.fromARGB(255, 180, 69, 69),
          content: Text(
            "Food Item has been updated Successfully",
            style: TextStyle(fontSize: 18.0),
          ),
        ));
        namecontroller.clear();
        newNameController.clear();
        newPriceController.clear();
        newDetailController.clear();
        setState(() {
          newCategory = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color.fromARGB(255, 180, 69, 69),
          content: Text(
            "Failed to update Food Item. Please check the item name.",
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
                "Current Item Name",
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
                      hintText: "Enter current item name",
                      hintStyle: AppWidget.lightTextFieldStyle()),
                ),
              ),
              SizedBox(height: 30.0,),
              Text(
                "New Item Name",
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
                  controller: newNameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter new item name",
                      hintStyle: AppWidget.lightTextFieldStyle()),
                ),
              ),
              SizedBox(height: 30.0,),
              Text(
                "New Item Price",
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
                  controller: newPriceController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter new item price रु ",
                      hintStyle: AppWidget.lightTextFieldStyle()),
                ),
              ),
              SizedBox(height: 30.0,),
              Text(
                "New Item Detail",
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
                  maxLines: 6,
                  controller: newDetailController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter new detail of the item",
                      hintStyle: AppWidget.lightTextFieldStyle()),
                ),
              ),
              SizedBox(height: 20.0,),
              Text(
                "New Category",
                style: AppWidget.semiboldTextFieldStyle(),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                color: Color.fromARGB(255, 237, 225, 225),borderRadius: BorderRadius.circular(10)
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                          value: item,
                                child: Text(
                              item,
                              style:
                                  TextStyle(fontSize: 18.0, color: const Color.fromARGB(255, 180, 69, 69)),
                            )))
                        .toList(),
                    onChanged: ((value) => setState(() {
                      newCategory = value;
                    })),
                    dropdownColor: Colors.white,
                    hint: Text("Select new category"),
                    iconSize: 36,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: const Color.fromARGB(255, 180, 69, 69),
                    ),
                    value: newCategory,
                  ),
                ),
              ),
              SizedBox(height: 40.0,),
              GestureDetector(
                onTap: () {
                  updateItem();
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
                          "Update",
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

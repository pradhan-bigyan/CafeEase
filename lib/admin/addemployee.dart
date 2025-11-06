import 'package:flutter/material.dart';
import 'package:kyafeease/services/database.dart';
import 'package:kyafeease/widgets/widget_support.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  TextEditingController nameController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  addEmployee() async {
    if (nameController.text.isNotEmpty &&
        salaryController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      Map<String, dynamic> employeeData = {
        "Name": nameController.text.trim(),
        "Salary": salaryController.text.trim(),
        "Email": emailController.text.trim(),
        "Password": passwordController.text.trim(),  // Ideally, you would hash passwords before storing them
      };

      try {
        await DatabaseMethods().addEmployee(employeeData);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color.fromARGB(255, 180, 69, 69),
          content: Text(
            "Employee has been added Successfully",
            style: TextStyle(fontSize: 18.0),
          ),
        ));

        nameController.clear();
        salaryController.clear();
        emailController.clear();
        passwordController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Failed to add employee: $e",
            style: TextStyle(fontSize: 18.0),
          ),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Please fill all fields",
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
          "Add Employee",
          style: AppWidget.HeaderTextFieldStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Employee Name",
                style: AppWidget.semiboldTextFieldStyle(),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 237, 225, 225),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter employee name",
                      hintStyle: AppWidget.lightTextFieldStyle()),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Employee Salary",
                style: AppWidget.semiboldTextFieldStyle(),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 237, 225, 225),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: salaryController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter employee salary",
                      hintStyle: AppWidget.lightTextFieldStyle()),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Employee Email",
                style: AppWidget.semiboldTextFieldStyle(),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 237, 225, 225),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter employee email",
                      hintStyle: AppWidget.lightTextFieldStyle()),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Employee Password",
                style: AppWidget.semiboldTextFieldStyle(),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 237, 225, 225),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter employee password",
                      hintStyle: AppWidget.lightTextFieldStyle()),
                ),
              ),
              SizedBox(height: 40.0),
              GestureDetector(
                onTap: () {
                  addEmployee();
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
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
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

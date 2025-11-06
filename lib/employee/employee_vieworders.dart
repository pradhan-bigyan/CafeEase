import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyafeease/employee/order_details_page.dart';
import 'package:kyafeease/widgets/widget_support.dart';


class EmployeeOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Orders",
          style: AppWidget.HeaderTextFieldStyle(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return Center(
              child: Text(
                'No orders found',
                style: AppWidget.semiboldTextFieldStyle(),
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              var cartItems = order['cartItems'] as List<dynamic>;
              var tokenNumber = order['tokenNumber'];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailsPage(order: order),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Token Number: $tokenNumber',
                        style: AppWidget.semiboldTextFieldStyle(),
                      ),
                      Column(
                        children: cartItems.map((item) {
                          return ListTile(
                            leading: Image.network(
                              item['Image'],
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              item['Name'],
                              style: AppWidget.semiboldTextFieldStyle(),
                            ),
                            subtitle: Text(
                              "Quantity: ${item['Quantity']}\nTotal: रु ${item['Total']}",
                              style: AppWidget.lightTextFieldStyle(),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

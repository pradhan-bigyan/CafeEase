import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyafeease/widgets/widget_support.dart';

class OrderDetailsPage extends StatelessWidget {
  final DocumentSnapshot order;

  OrderDetailsPage({required this.order});

  @override
  Widget build(BuildContext context) {
    var cartItems = order['cartItems'] as List<dynamic>;
    var tokenNumber = order['tokenNumber'];
    var status = order['status'];
    var timestamp = (order['timestamp'] as Timestamp).toDate();
    var userId = order['userId'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Order Details",
          style: AppWidget.HeaderTextFieldStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Token Number: $tokenNumber',
              style: AppWidget.semiboldTextFieldStyle(),
            ),
            Text(
              'User ID: $userId',
              style: AppWidget.lightTextFieldStyle(),
            ),
            Text(
              'Status: $status',
              style: AppWidget.lightTextFieldStyle(),
            ),
            Text(
              'Order Time: ${timestamp.toLocal()}',
              style: AppWidget.lightTextFieldStyle(),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
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
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('completedOrders')
                      .doc(order.id)
                      .set(order.data() as Map<String, dynamic>);
                  
                  await FirebaseFirestore.instance
                      .collection('orders')
                      .doc(order.id)
                      .delete();
                  
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Mark as Completed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

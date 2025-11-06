import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyafeease/services/google_sheets_service.dart';
import 'package:kyafeease/widgets/widget_support.dart';


class CompletedOrdersPage extends StatelessWidget {
  final GoogleSheetsService sheetsService = GoogleSheetsService(
    spreadsheetId: '1cWbyuz15CGnvtXcZ6yIjTJPN14r4NsOGAfPV4Uc8Omc',
    range: 'Sheet1!A1', // Adjust range according to your sheet
    credentialsFile: 'assets/credentials.json',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Completed Orders",
          style: AppWidget.HeaderTextFieldStyle(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('completedOrders').snapshots(),
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
                'No completed orders found',
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
              var status = order['status'];

              Color statusColor = status == 'paid' ? Colors.green : Colors.redAccent;

              return Container(
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
                    Text(
                      'Status: $status',
                      style: AppWidget.lightTextFieldStyle().copyWith(color: statusColor),
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
                    if (status == 'unpaid') ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance.collection('completedOrders').doc(order.id).update({
                                'status': 'paid',
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Paid',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Add your functionality for "SENT" button here
                              await sheetsService.appendOrderData([
                                [
                                  DateTime.now().toString(),
                                  cartItems.map((item) => item['Name']).join(', '),
                                  cartItems.map((item) => item['Total']).join(', '),
                                  status,
                                ],
                              ]);
                              
                              await FirebaseFirestore.instance.collection('completedOrders').doc(order.id).delete();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'SENT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Add your functionality for "SENT" button here
                            await sheetsService.appendOrderData([
                              [
                                DateTime.now().toIso8601String(),
                                cartItems.map((item) => item['Name']).join(', '),
                                cartItems.map((item) => item['Total']).join(', '),
                                status,
                              ],
                            ]);
                            // Optional: Remove the order from the Firestore collection
                            await FirebaseFirestore.instance.collection('completedOrders').doc(order.id).delete();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'SENT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
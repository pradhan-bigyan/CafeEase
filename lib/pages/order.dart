import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:kyafeease/pages/buttomnav.dart';
import 'package:kyafeease/services/database.dart';
import 'package:kyafeease/widgets/widget_support.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String? _tokenNumber;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text('No user signed in'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNav()),
            );
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: const Color.fromARGB(255, 180, 69, 69),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Check Out",
          style: AppWidget.HeaderTextFieldStyle(),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: DatabaseMethods().getCartItems(user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Map<String, dynamic>> cartItems = snapshot.data!;
if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Your order list is empty',
                    style: AppWidget.semiboldTextFieldStyle(),
                  ),
                  if (_tokenNumber != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Token Number: $_tokenNumber',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            );
          }

          double totalPrice = cartItems.fold(
              0, (sum, item) => sum + double.parse(item['Total']));

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: cartItems.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var cartItem = cartItems[index];
                    return Container(
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
                                  cartItem['Image'],
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 20.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem['Name'],
                                      style: AppWidget.semiboldTextFieldStyle(),
                                    ),
                                    SizedBox(height: 5.0),
                                    Text(
                                      "Quantity: ${cartItem['Quantity']}",
                                      style: AppWidget.lightTextFieldStyle(),
                                    ),
                                    SizedBox(height: 5.0),
                                    Text(
                                      "रु ${cartItem['Total']}",
                                      style: AppWidget.semiboldTextFieldStyle(),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  DatabaseMethods().deleteCartItem(cartItem['Name'], user.uid);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price:',
                          style: AppWidget.semiboldTextFieldStyle(),
                        ),
                        Text(
                          'रु ${totalPrice.toStringAsFixed(2)}',
                          style: AppWidget.boldTextFieldStyle(),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            payWithKhaltiInApp(context, totalPrice, user.uid, cartItems);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 180, 69, 69),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Pay with Khalti',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            payWithCash(context, totalPrice, user.uid, cartItems);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 180, 69, 69),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Pay with Cash',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void payWithKhaltiInApp(BuildContext context, double totalPrice, String userId, List<Map<String, dynamic>> cartItems) {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: (totalPrice * 100).toInt(), // Convert to paisa
        productIdentity: 'Your Product ID',
        productName: 'Your Product Name',
        mobileReadOnly: false,
      ),
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: (PaymentSuccessModel success) {
        int tokenNumber = Random().nextInt(100) + 1;
        // Save the order details to the database
        DatabaseMethods().saveOrder(userId, cartItems, tokenNumber, 'paid');

        // Delete items from cart
        DatabaseMethods().deleteCartItems(userId);

        // Update token number state
        setState(() {
          _tokenNumber = tokenNumber.toString();
        });

        // Show payment success dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Payment Successful'),
              content: Text('Reference ID: ${success.idx}\nToken Number: $tokenNumber'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, tokenNumber);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
      onFailure: (PaymentFailureModel failure) {
        debugPrint(failure.toString());
      },
      onCancel: () {
        debugPrint('Payment cancelled');
      },
    );
  }

  void payWithCash(BuildContext context, double totalPrice, String userId, List<Map<String, dynamic>> cartItems) {
    int tokenNumber = Random().nextInt(100) + 1;
    // Save the order details to the database
    DatabaseMethods().saveOrder(userId, cartItems, tokenNumber, 'unpaid');

    // Delete items from cart
    DatabaseMethods().deleteCartItems(userId);

    // Update token number state
    setState(() {
      _tokenNumber = tokenNumber.toString();
    });

    // Show payment success dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Order Placed'),
          content: Text('Your order has been placed.\nToken Number: $tokenNumber'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, tokenNumber);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

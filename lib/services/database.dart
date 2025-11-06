import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addFoodItem(Map<String, dynamic> userinfomap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userinfomap);
  }

  Future<bool> deleteFoodItem(String itemName) async {
    try {
      List<String> collections = [
        'Cake',
        'Coffee',
        'Tea',
        'Drinks'
      ]; // Add your collections here
      bool itemDeleted = false;

      for (String collectionName in collections) {
        var collection = FirebaseFirestore.instance.collection(collectionName);
        var snapshot =
            await collection.where('Name', isEqualTo: itemName).get();

        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            await collection.doc(doc.id).delete();
          }
          itemDeleted = true;
        }
      }

      return itemDeleted;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateFoodItem(String itemName, String? newName,
      String? newPrice, String? newDetail, String? newCategory) async {
    try {
      List<String> collections = [
        'Cake',
        'Coffee',
        'Tea',
        'Drinks'
      ]; // Add your collections here
      bool itemUpdated = false;

      for (String collectionName in collections) {
        var collection = FirebaseFirestore.instance.collection(collectionName);
        var snapshot =
            await collection.where('Name', isEqualTo: itemName).get();

        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            Map<String, dynamic> updatedData = {};
            if (newName != null && newName.isNotEmpty)
              updatedData['Name'] = newName;
            if (newPrice != null && newPrice.isNotEmpty)
              updatedData['Price'] = newPrice;
            if (newDetail != null && newDetail.isNotEmpty)
              updatedData['Detail'] = newDetail;
            if (newCategory != null) updatedData['Category'] = newCategory;

            await collection.doc(doc.id).update(updatedData);
          }
          itemUpdated = true;
        }
      }

      return itemUpdated;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> addEmployee(Map<String, dynamic> employeeData) async {
    try {
      await FirebaseFirestore.instance
          .collection('Employees')
          .add(employeeData);
    } catch (e) {
      print("Error adding employee: $e");
      throw e;
    }
  }

  Future<bool> deleteEmployee(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Employees')
          .where('Email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Delete the employee document
        await FirebaseFirestore.instance
            .collection('Employees')
            .doc(querySnapshot.docs.first.id)
            .delete();

        return true; // Employee deleted successfully
      } else {
        return false; // Employee not found
      }
    } catch (e) {
      print("Error deleting employee: $e");
      return false; // Failed to delete employee
    }
  }

  Future<Stream<QuerySnapshot>> getCafeitem(String name) async {
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }


  addUserDetail(Map<String, dynamic> userInfomap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfomap);
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFoodToCart(Map<String, dynamic> foodData, String userId) async {
    try {
      DocumentReference userDocRef = _firestore.collection('users').doc(userId);
      CollectionReference cartCollectionRef = userDocRef.collection('cart');
      
      await cartCollectionRef.add(foodData);
      print("Food item added to cart successfully.");
    } catch (e) {
      print("Error adding food item to cart: $e");
    }
  }
  Stream<List<Map<String, dynamic>>> getCartItems(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
    Future<void> deleteCartItems(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } catch (e) {
      print("Error deleting cart items: $e");
    }
  }
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> deleteCartItem(String itemName, String userId) async {
    try {
      await usersCollection
          .doc(userId)
          .collection('cart')
          .where('Name', isEqualTo: itemName)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
    } catch (e) {
      print("Error deleting cart item: $e");
    }
  }
    Future<void> saveOrder(String userId, List<Map<String, dynamic>> cartItems, int tokenNumber, String status) async {
    await FirebaseFirestore.instance.collection('orders').add({
      'userId': userId,
      'cartItems': cartItems,
      'tokenNumber': tokenNumber,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

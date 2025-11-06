import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kyafeease/pages/addreview.dart';
import 'package:kyafeease/pages/buttomnav.dart';
import 'package:kyafeease/pages/login.dart';
import 'package:random_string/random_string.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profile, name, email;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool isLoading = true;
  bool isEditing = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userProfile = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userProfile.exists) {
        setState(() {
          nameController.text = userProfile['Name'] ?? '';
          emailController.text = userProfile['Email'] ?? '';
          profile = userProfile['ProfileUrl'];
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = File(image.path);
      setState(() {
        uploadItem();
      });
    }
  }

  Future<void> uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("profilePictures").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

      var downloadUrl = await (await task).ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'ProfileUrl': downloadUrl});
      setState(() {
        profile = downloadUrl;
      });
    }
  }

  Future<void> saveProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String name = nameController.text;
    String email = emailController.text;

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields.')),
      );
      return;
    }

    // Upload image if a new one is selected
    if (selectedImage != null) {
      String fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('profilePictures')
          .child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putFile(selectedImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      profile = await taskSnapshot.ref.getDownloadURL();
    }

    // Save data to Firestore
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .set({
        'Name': name,
        'Email': email,
        'ProfileUrl': profile,
      }, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile saved successfully!')),
      );
      setState(() {
        isEditing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    }

    // Clear selected image after saving
    setState(() {
      selectedImage = null;
    });
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
     Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (route) => false,
    );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  Future<void> deleteAccount() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .delete();
      await currentUser.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deleted successfully.')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting account: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          isEditing ? "Save Profile" : "Profile",
          style: TextStyle(
            color: Color.fromARGB(255, 180, 69, 69),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            color: Color.fromARGB(255, 180, 69, 69),
            onPressed: () {
              setState(() {
                if (isEditing) {
                  saveProfile();
                } else {
                  isEditing = true;
                }
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: getImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: selectedImage != null
                            ? FileImage(selectedImage!)
                            : (profile != null
                                ? NetworkImage(profile!)
                                : AssetImage('images/coffee.jpg')) as ImageProvider,
                        child: profile == null
                            ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                    SizedBox(height: 20),
                    buildInfoCard(Icons.person, "Name", 
                      isEditing ? TextField(
                        controller: nameController,
                        decoration: InputDecoration(hintText: 'Enter your name'),
                      ) : Text(nameController.text.isNotEmpty ? nameController.text : "User Name"),
                      isEditing
                    ),
                    buildInfoCard(Icons.email, "Email", 
                      isEditing ? TextField(
                        controller: emailController,
                        decoration: InputDecoration(hintText: 'Enter your email'),
                      ) : Text(emailController.text.isNotEmpty ? emailController.text : "user@example.com"),
                      isEditing
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddReviewPage()),
                        );
                      },
                      child: buildInfoCard(
                        Icons.rate_review,
                        "Add Review",
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddReviewPage()),
                            );
                          },
                          child: Text('Write a Review'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 180, 69, 69),
                          ),
                        ),
                        false,
                      ),
                    ),
                      SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                       deleteAccount();
                      },
                      child: buildInfoCard(
                        Icons.delete_outline,
                        "Delete Account",
                        ElevatedButton(
                          onPressed: () {
                           deleteAccount();
                          },
                          child: Text('Delete account'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 180, 69, 69),
                          ),
                        ),
                        false,
                      ),
                    ),
                      SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                       signOut();
                      },
                      child: buildInfoCard(
                        Icons.exit_to_app_outlined,
                        "Sign Out",
                        ElevatedButton(
                          onPressed: () {
                           signOut();
                          },
                          child: Text('Signout '),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 180, 69, 69),
                          ),
                        ),
                        false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildInfoCard(IconData icon, String title, Widget content, bool isEditable) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              SizedBox(width: 20.0),
              Expanded(
                child: isEditable
                    ? content
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
                          ),
                          content is Text ? content : Container()
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

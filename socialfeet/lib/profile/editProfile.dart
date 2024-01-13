import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:socialfeet/profile/editSports.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');

  String? currentUsername;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      Query query = usersRef.orderByChild('email').equalTo(currentUser.email);
      DatabaseEvent event = await query.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value is Map) {
        Map<dynamic, dynamic> usersMap = snapshot.value as Map<dynamic, dynamic>;
        Map<dynamic, dynamic> userData = usersMap.values.first;
        setState(() {
          currentUsername = userData['username'];
          nameController.text = userData['fullname'] ?? '';
          emailController.text = userData['email'] ?? '';
          locationController.text = userData['location'] ?? '';
          aboutMeController.text = userData['aboutMe'] ?? '';
        });
      }
    }
  }

  _saveProfileChanges() async {
    if (currentUsername == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unable to update profile. Username is not available.'),
      ));
      return;
    }

    Map<String, dynamic> updatedData = {};
    if (nameController.text.isNotEmpty) {
      updatedData['fullname'] = nameController.text;
    }
    if (emailController.text.isNotEmpty) {
      updatedData['email'] = emailController.text;
    }
    if (locationController.text.isNotEmpty) {
      updatedData['location'] = locationController.text;
    }
    if (aboutMeController.text.isNotEmpty) {
      updatedData['aboutMe'] = aboutMeController.text;
    }

    if (updatedData.isNotEmpty) {
      await usersRef.child(currentUsername!).update(updatedData);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile updated successfully!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.21, -0.98),
            end: Alignment(0.21, 0.98),
            colors: [Color(0x4C36DDA6), Color(0x4C8846DF)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
            _buildProfilePicture(),
            _buildTextField("Name Surname", nameController),
            _buildTextField("Email", emailController),
            _buildTextField("Location", locationController),
            _buildTextField("About Me", aboutMeController, maxLines: 5),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfileChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    ));
  }
Widget _buildProfilePicture() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          _showImageOptions(context);
        },
        child: CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage('https://via.placeholder.com/155x95'),
        ),
      ),
      SizedBox(width: 20), // Spacer
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditSportsScreen(),
          ));
        },
        child: Text('Edit Sports'),
      ),
    ],
  );
}
 
 Widget _buildTextField(String labelText, TextEditingController controller,
    {bool isPassword = false, int maxLines = 1}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      obscureText: isPassword,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true, 
        fillColor: Colors.white, 
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    ),
  );
}

 void _showImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement logic for changing the image
                  Navigator.pop(context);
                },
                child: Text('Change Image'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement logic for removing the image
                  Navigator.pop(context);
                },
                child: Text('Remove Image'),
              ),
            ],
          ),
        );
      },
    );
  }
}

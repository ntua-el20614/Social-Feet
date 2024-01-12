import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildProfilePicture(),
            _buildTextField("Name Surname", nameController),
            _buildTextField("Email / Phone", emailPhoneController),
            _buildTextField("Password", passwordController, isPassword: true),
            _buildTextField("Date of Birth", dobController),
            _buildTextField("Location", locationController),
            _buildTextField("About Me", aboutMeController, maxLines: 3),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement logic to save the edited profile
                // You can access the entered values using controllers:
                // nameController.text, emailPhoneController.text, ...
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
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
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: () {
        _showImageOptions(context);
      },
      child: CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage('URL_TO_USER_PROFILE_IMAGE'),
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
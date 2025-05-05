import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_beza_gallery/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  String? phone;
  String? email;
  String? name;

  findUserDetail(){
    try {
      final user = _auth.currentUser;
      if (user != null){
        final userDoc = _firestore.collection('users').doc(user.uid);
        userDoc.get().then((doc) {
          if (doc.exists) {
            setState(() {
              phone = doc.get('phone');
              email = doc.get('email');
              name = doc.get('name');
            });
          }
        });

      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    findUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             BuildProfileHeader(username: name),
             BuildProfileCard(
              title: 'Email',
              subtitle: email,
              icon: Icons.email,
            ),
            BuildProfileCard(
              title: 'Phone',
              subtitle: phone,
              icon: Icons.phone,
              onTap: () => _showChangePhoneDialog(context),
            ),
            BuildProfileCard(
              title: 'Password',
              subtitle: '********',
              icon: Iconsax.password_check,
              onTap: () => _showChangePasswordDialog(context),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _buildLogoutDialog(context),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.red, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Log out',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
void _showChangePasswordDialog(BuildContext context) {
  // Create controllers for the password fields
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      // Use StatefulBuilder to manage local state for the dialog
      bool isLoading = false;
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Change Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Current Password",
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "New Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        final String currentPassword = currentPasswordController.text.trim();
                        final String newPassword = newPasswordController.text.trim();

                        // Validate that both fields are not empty
                        if (currentPassword.isEmpty || newPassword.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill in both fields')),
                          );
                          return;
                        }

                        // Set loading state to true
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null && user.email != null) {
                            // Reauthenticate the user with the current password
                            final credential = EmailAuthProvider.credential(
                              email: user.email!,
                              password: currentPassword,
                            );
                            await user.reauthenticateWithCredential(credential);

                            // Update the password
                            await user.updatePassword(newPassword);

                            // Show a success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Password updated successfully')),
                            );

                            // Close the dialog
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          // Display error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        } finally {
                          // Reset the loading state (if the widget is still mounted)
                          if (mounted) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },
                child: const Text("Change"),
              ),
            ],
          );
        },
      );
    },
  ).then((_) {
    // Dispose controllers after the dialog is closed (ensuring the frame is complete)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentPasswordController.dispose();
      newPasswordController.dispose();
    });
  });
}


  void _showChangePhoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Change Phone Number",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          content:Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400, width: 1.2), 
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // Align items properly
                  children: [
                    const Text("+251 "),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Enter phone number",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Handle phone number change logic
                bool updatedphone = await updateUserDetail(phone: _phoneController.text.trim());
                if(updatedphone){
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _buildLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  // Optionally, you can also clear any local data or preferences if needed.
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool("isLoggedIn", false);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => InitialScreen()),
                  (route) => false
                  );
                } catch (e) {
                  print("Error logging out: $e");
                }
              },
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );
  }
}

Future<bool> updateUserDetail({ String? phone, String? password }) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userData = FirebaseFirestore.instance.collection('users').doc(user.uid);
    try {
      await userData.update({
        'phone': "0$phone",
      });
      return true;
    } catch (error) {
      print("Error updating user detail: $error");
      return false;
    }
  }
  return false;
}


class BuildProfileCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;

  const BuildProfileCard({
    Key? key,
    this.title,
    this.subtitle,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ListTile(
            leading: Icon(icon),
            title: Text(title ?? ''),
            subtitle: Text(subtitle ?? ''),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }
}

class BuildProfileHeader extends StatelessWidget {
  final String? username;
  const BuildProfileHeader({Key? key, this.username}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Column(
        children: [
          const Center(
            child: Text(
              'PROFILE',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 10),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/images/pblogo.png"),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              username ?? '',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
    }
}

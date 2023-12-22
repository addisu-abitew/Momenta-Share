import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momenta_share/models/UserModel.dart';
import 'package:momenta_share/providers/UserProvider.dart';
import 'package:momenta_share/services/FirestoreMethods.dart';
import 'package:momenta_share/utils/pickImage.dart';
import 'package:provider/provider.dart';

class ProfileEditorDialog extends StatefulWidget {
  final String username;
  final String bio;
  final String photoUrl;
  const ProfileEditorDialog({
    super.key,
    required this.username,
    required this.bio,
    required this.photoUrl,
  });

  @override
  State<ProfileEditorDialog> createState() => _ProfileEditorDialogState();
}

class _ProfileEditorDialogState extends State<ProfileEditorDialog> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  Uint8List? image;

  @override
  void initState() {
    usernameController.text = widget.username;
    bioController.text = widget.bio;
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width > 600 ? 600 : MediaQuery.of(context).size.width;
    final UserModel user = Provider.of<UserProvider>(context).user!;
    return AlertDialog(
            title: const Text('Edit Profile'),
            titleTextStyle: TextStyle(fontSize: width*0.05, fontFamily: 'Kalnia'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: width*0.1,
                      backgroundImage: image != null ? MemoryImage(image!) : NetworkImage(widget.photoUrl) as ImageProvider,
                    ),
                    Positioned(
                      bottom: -width*0.025,
                      right: -width*0.025,
                      child: IconButton(
                        onPressed: () async {
                          Uint8List? pickedImage = await pickImage(ImageSource.gallery);
                          if (pickedImage != null) {
                            image = pickedImage;
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.add_a_photo, color: Colors.white)
                      ),
                    )
                  ],
                ),
                SizedBox(height: width*0.05),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(fontSize: width*0.05),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: width*0.025),
                TextField(
                  controller: bioController,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    labelStyle: TextStyle(fontSize: width*0.05),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                  foregroundColor: MaterialStatePropertyAll(Colors.white)
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: const Text('Cancel')
              ),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                  foregroundColor: MaterialStatePropertyAll(Colors.white)
                ),
                onPressed: () {
                  FirestoreMethods.editProfile(user: user, username: usernameController.text, bio: bioController.text, photo: image);
                  Navigator.of(context).pop();
                }, 
                child: const Text('Save')
              ),
            ],
          );
  }
}
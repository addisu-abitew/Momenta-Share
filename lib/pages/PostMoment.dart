import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momenta_share/models/UserModel.dart';
import 'package:momenta_share/providers/UserProvider.dart';
import 'package:momenta_share/services/FirestoreMethods.dart';
import 'package:momenta_share/utils/pickImage.dart';
import 'package:momenta_share/widgets/CustomButton.dart';
import 'package:provider/provider.dart';

class PostMoment extends StatefulWidget {
  const PostMoment({super.key});

  @override
  State<PostMoment> createState() => _PostMomentState();
}

class _PostMomentState extends State<PostMoment> {
  TextEditingController captionController = TextEditingController();
  Uint8List? _pickedImage;
  bool isLoading = false;

  chooseImage() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Choose Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                _pickedImage = await pickImage(ImageSource.camera);
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Gallery'),
              onTap: () async {
                _pickedImage = await pickImage(ImageSource.gallery);
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: const Text('Cancel')
          )
        ],
      )
    );
    
  }

  postMoment() async {
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please choose an image')));
      return;
    }
    setState(() {
      isLoading = true;
    });
    UserModel? user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please login first')));
      return;
    } else {
      String? error = await FirestoreMethods.uploadPost(
        image: _pickedImage!, 
        uid: user.uid, 
        username: user.username, 
        userPhotoUrl: user.photoUrl, 
        caption: captionController.text,
      );
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post uploaded successfully')));
        captionController.clear();
        _pickedImage = null;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width > 600 ? 600 : MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset('assets/images/momenta_logo.png', width: width*0.1075),
              SizedBox(width: width*0.025),
              Text('MomentaShare', style: TextStyle(fontFamily: 'OleoScript', fontSize: width*0.0875))
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, width*0.005),
            child: Container(
              color: Colors.grey,
              height: width*0.005,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isLoading ? LinearProgressIndicator() : SizedBox(height: 0),
                  SizedBox(height: width*0.1),
                  GestureDetector(
                    onTap: chooseImage,
                    child: Container(
                      height: width*0.6,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: _pickedImage == null ? AssetImage('assets/images/image_placeholder.png') : MemoryImage(_pickedImage!) as ImageProvider,
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(Colors.white, BlendMode.darken)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: width*0.075,
                        backgroundImage: Provider.of<UserProvider>(context).user == null ? AssetImage('assets/images/profile_icon.jpg') : NetworkImage( Provider.of<UserProvider>(context).user!.photoUrl) as ImageProvider,
                      ),
                      SizedBox(width: width*0.025),
                      TextField(
                        controller: captionController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'Write caption here...',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                          constraints: BoxConstraints(maxWidth: width*0.725)
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomButton(label: 'Post', onPressed: postMoment, isLoading: isLoading)
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
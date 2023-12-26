import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momenta_share/providers/UserProvider.dart';
// import 'package:momenta_share/pages/HomeScreen.dart';
import 'package:momenta_share/services/AuthMethods.dart';
import 'package:momenta_share/utils/pickImage.dart';
import 'package:momenta_share/widgets/CustomButton.dart';
import 'package:momenta_share/widgets/CustomTextField.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  Uint8List? image;
  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List? _image = await pickImage(ImageSource.gallery);
    if (_image != null) {
      image = _image;
      setState(() {});
    }
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String? res = await AuthMethods.signUp(
      username: usernameController.text, 
      email: emailController.text, 
      password: passwordController.text, 
      bio: bioController.text, 
      photo: image
    );
    if (res == null) {
      Navigator.of(context).pop();
      Provider.of<UserProvider>(context).refreshUser();
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width > 600 ? 600 : MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: width*0.05),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: width*0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/momenta_logo.png', height: width*0.2, fit: BoxFit.contain),
                    Text("MomentaShare", style: TextStyle(fontFamily: 'OleoScript', fontSize: width*0.1, color: Colors.white)),
                  ],
                ),
                SizedBox(height: width*0.05),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: width*0.2,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: width*0.19,
                        backgroundImage: image != null ? MemoryImage(image!) : AssetImage('assets/images/profile_icon.jpg') as ImageProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: selectImage, 
                        icon: Icon(
                          Icons.add_a_photo, 
                          color: Colors.white, 
                          size: width*0.1
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: width*0.05),
                CustomTextField(label: 'Username', keyboardType: TextInputType.text, isObsecured: false, controller: usernameController),
                SizedBox(height: width*0.05),
                CustomTextField(label: 'Email', keyboardType: TextInputType.emailAddress, isObsecured: false, controller: emailController),
                SizedBox(height: width*0.05),
                CustomTextField(label: 'Password', keyboardType: TextInputType.text, isObsecured: true, controller: passwordController),
                SizedBox(height: width*0.05),
                CustomTextField(label: 'Bio', keyboardType: TextInputType.text, isObsecured: false, controller: bioController),
                SizedBox(height: width*0.05),
                CustomButton(label: 'Register', onPressed: signUpUser, isLoading: isLoading),
                SizedBox(height: width*0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have an account?", style: TextStyle(fontSize: 20),),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Sign In', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
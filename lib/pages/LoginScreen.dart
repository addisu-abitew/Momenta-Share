import 'package:flutter/material.dart';
import 'package:momenta_share/pages/SignUpScreen.dart';
import 'package:momenta_share/services/AuthMethods.dart';
import 'package:momenta_share/widgets/CustomButton.dart';
import 'package:momenta_share/widgets/CustomTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String? error = await AuthMethods.signIn(email: emailController.text, password: passwordController.text);
    if (error == null) {
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
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
                SizedBox(height: MediaQuery.sizeOf(context).width*0.2),
                Image.asset('assets/images/momenta_logo.png', height: width*0.4, fit: BoxFit.contain),
                Text("MomentaShare", style: TextStyle(fontFamily: 'OleoScript', fontSize: width*0.125, color: Colors.white)),
                SizedBox(height: width*0.1),
                CustomTextField(label: 'Email', keyboardType: TextInputType.emailAddress, isObsecured: false, controller: emailController),
                SizedBox(height: width*0.05),
                CustomTextField(label: 'Password', keyboardType: TextInputType.text, isObsecured: true, controller: passwordController),
                SizedBox(height: width*0.1),
                CustomButton(label: 'Login', onPressed: loginUser, isLoading: isLoading),
                SizedBox(height: width*0.15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: TextStyle(fontSize: width*0.05),),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpScreen())), 
                      child: Text('Sign Up', style: TextStyle(fontSize: width*0.05, fontWeight: FontWeight.bold, color: Colors.white)),
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
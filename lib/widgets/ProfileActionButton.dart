// import 'package:flutter/material.dart';
// import 'package:momenta_share/models/UserModel.dart';
// import 'package:momenta_share/providers/UserProvider.dart';
// import 'package:momenta_share/services/AuthMethods.dart';
// import 'package:momenta_share/services/FirestoreMethods.dart';
// import 'package:provider/provider.dart';

// class ProfileActionButton extends StatelessWidget {
//   final ProfileAction action;
//   final UserModel? user;
//   ProfileActionButton({super.key, required this.action, this.user});

//   final actionValues = {
//     ProfileAction.logout: {
//       'bgcolor': Colors.red.withOpacity(0.25),
//       'color': Colors.red,
//       'text': 'Log out',
//     },
//     ProfileAction.follow: {
//       'bgcolor': Colors.blue,
//       'color': Colors.black,
//       'text': 'Follow',
//     },
//     ProfileAction.unfollow: {
//       'bgcolor': Colors.blue.withOpacity(0.25),
//       'color': Colors.black,
//       'text': 'Unfollow',
//     },
//   };

//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width > 600 ? 600 : MediaQuery.of(context).size.width;
//     return 
//   }
// }

// enum ProfileAction {
//   logout,
//   follow,
//   unfollow,
// }
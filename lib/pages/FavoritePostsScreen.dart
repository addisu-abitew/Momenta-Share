import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:momenta_share/models/PostModel.dart';
import 'package:momenta_share/models/UserModel.dart';
import 'package:momenta_share/providers/UserProvider.dart';
import 'package:momenta_share/widgets/PostCard.dart';
import 'package:provider/provider.dart';

class FavoritePostsScreen extends StatefulWidget {
  const FavoritePostsScreen({super.key});

  @override
  State<FavoritePostsScreen> createState() => _FavoritePostsScreenState();
}

class _FavoritePostsScreenState extends State<FavoritePostsScreen> {
  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).user;
    final double width = MediaQuery.of(context).size.width > 600 ? 600 : MediaQuery.of(context).size.width;
    return Scaffold(
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').where('likes', arrayContains: user?.uid).orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return PostCard(
                  post: PostModel.fromMap(snapshot.data!.docs[index].data()),
                );
              },
            );
          } else {
            return const Center(child: Text('No posts'));
          }
        },
      )
    );
  }
}
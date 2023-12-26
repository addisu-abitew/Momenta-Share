import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:momenta_share/models/PostModel.dart';
import 'package:momenta_share/widgets/CustomAppBar.dart';
import 'package:momenta_share/widgets/PostCard.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width > 600 ? 600 : MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text('MomentaShare', style: TextStyle(fontFamily: 'OleoScript', fontSize: width*0.0875))
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').orderBy('createdAt', descending: true).snapshots(),
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:momenta_share/models/CommentModel.dart';
import 'package:momenta_share/providers/UserProvider.dart';
import 'package:momenta_share/services/FirestoreMethods.dart';
import 'package:momenta_share/widgets/CommentCard.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  final List<String> comments;
  const CommentScreen({super.key, required this.comments, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Comments'),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 2),
            child: Container(
              color: Colors.grey,
              height: 2,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').orderBy('createdAt', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return CommentCard(
                          comment: CommentModel.fromMap(snapshot.data!.docs[index].data())
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No comments'));
                  }
                },
              
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(onPressed: isLoading ? () {} : () async {
                    setState(() => isLoading = true);
                    final String? error = await FirestoreMethods.commentPost(comment: commentController.text, userId: user.uid, postId: widget.postId, createdAt: DateTime.now(), username: user.username, userPhotoUrl: user.photoUrl, likes: <String>[]);
                    if (error == null) {
                      commentController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                    }
                    setState(() => isLoading = false);
                  }, icon: isLoading ? CircularProgressIndicator() : const Icon(Icons.send, size: 40)),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
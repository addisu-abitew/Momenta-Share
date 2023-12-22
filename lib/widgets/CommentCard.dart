import 'package:flutter/material.dart';
import 'package:momenta_share/models/CommentModel.dart';
import 'package:momenta_share/providers/UserProvider.dart';
import 'package:momenta_share/services/FirestoreMethods.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentCard extends StatefulWidget {
  final CommentModel comment;
  const CommentCard({super.key, required this.comment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
  final user = Provider.of<UserProvider>(context, listen: false).user!;
    final now = DateTime.now();
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(widget.comment.userPhotoUrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(widget.comment.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Text('${widget.comment.likes.length} likes', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text(timeago.format(now.subtract(now.difference(widget.comment.createdAt))), style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 5),
                Text(widget.comment.comment),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              FirestoreMethods.likeComment(commentId: widget.comment.id, postId: widget.comment.postId, userId: user.uid, likes: widget.comment.likes);
            }, 
            icon: widget.comment.likes.contains(user.uid) ? Icon(Icons.favorite, color: Colors.amber) : Icon(Icons.favorite_border)
          )
        ],
      ),
    );
  }
}
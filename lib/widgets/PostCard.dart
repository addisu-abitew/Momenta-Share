import 'package:flutter/material.dart';
import 'package:momenta_share/models/PostModel.dart';
import 'package:momenta_share/pages/CommentScreen.dart';
import 'package:momenta_share/providers/UserProvider.dart';
import 'package:momenta_share/services/FirestoreMethods.dart';
import 'package:momenta_share/widgets/LikeAnimation.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  TextEditingController commentController = TextEditingController();

  showDeleteDialog() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text('Cancel')
            ),
            TextButton(
              onPressed: () async {
                String? error = await FirestoreMethods.deletePost(postId: widget.post.postId, uid: widget.post.uid);
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                } else {
                  Navigator.of(context).pop();
                }
              }, 
              child: const Text('Delete')
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final double width = MediaQuery.sizeOf(context).width > 600 ? 600 : MediaQuery.sizeOf(context).width;
    final uid = Provider.of<UserProvider>(context, listen: false).user?.uid;

    if (uid == null) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.all(width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: width * 0.05,
                backgroundImage: NetworkImage(widget.post.userPhotoUrl),
              ),
              SizedBox(width: width * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.post.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(timeago.format(now.subtract(now.difference(widget.post.createdAt))), style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const Spacer(),
              if (widget.post.uid == uid)
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (context) => AlertDialog(
                        title: const Text('Post Actions'),
                        titleTextStyle: TextStyle(fontSize: 20, fontFamily: 'Kalnia'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                                foregroundColor: MaterialStatePropertyAll(Colors.white)
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentScreen(comments: widget.post.comments, postId: widget.post.postId)));
                              },
                              child: const Text('View Comments')
                            ),
                            TextButton(
                              style: ButtonStyle(
                                padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                                foregroundColor: MaterialStatePropertyAll(Colors.white)
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDeleteDialog();
                              }, 
                              child: const Text('Delete')
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(), 
                            child: const Text('Cancel', style: TextStyle(fontSize: 12),)
                          ),
                        ],
                      )
                    );
                  },
                  icon: const Icon(Icons.more_vert, size: 35)
                ),
            ],
          ),
          SizedBox(height: width * 0.02),
          Text('${widget.post.likes.length} likes', style: const TextStyle(fontWeight: FontWeight.bold)),
          if (widget.post.caption.isNotEmpty) 
            SizedBox(height: width * 0.02),
            Text(widget.post.caption), 
          GestureDetector(
            onDoubleTap: () async {
              setState(() {
                isLikeAnimating = true;
              });
              if (!widget.post.likes.contains(uid)) {
                String? error = await FirestoreMethods.likePost(post: widget.post, uid: uid);
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                }
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: width * 0.025),
                  height: width * 0.6,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width * 0.02),
                    image: DecorationImage(
                      image: NetworkImage(widget.post.imageUrl),
                      fit: BoxFit.fill,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.darken)
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: isLikeAnimating ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    child: widget.post.likes.contains(uid) ? Icon(Icons.favorite, color: Colors.red, size: width * 0.2) : const SizedBox(),
                    onEnd: () => setState(() => isLikeAnimating = false),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () async {
                  String? error = await FirestoreMethods.likePost(post: widget.post, uid: uid);
                  if (error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                  }
                  setState(() {
                    isLikeAnimating = true;
                  });
                },
                style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.white)
                ),
                icon: LikeAnimation(
                  isAnimating: isLikeAnimating, 
                  isSmallIcon: true,
                  child: widget.post.likes.contains(Provider.of<UserProvider>(context).user!.uid) ? const Icon(Icons.favorite, color: Colors.red,) : const Icon(Icons.favorite_border), 
                  onEnd: () => setState(() => isLikeAnimating = false), 
                ),
                label: const Text('Like')
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentScreen(comments: widget.post.comments, postId: widget.post.postId)));
                },
                style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.white)
                ),
                icon: const Icon(Icons.comment), 
                label: const Text('Comments')
              ),
              TextButton.icon(
                onPressed: () {},
                style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.white)
                ),
                icon: const Icon(Icons.share), 
                label: const Text('Share')
              ),
            ],
          ),
        ],
      ),
    );
  }
}
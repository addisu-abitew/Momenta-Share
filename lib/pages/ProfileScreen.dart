import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:momenta_share/models/PostModel.dart';
import 'package:momenta_share/models/UserModel.dart';
import 'package:momenta_share/providers/UserProvider.dart';
import 'package:momenta_share/services/AuthMethods.dart';
import 'package:momenta_share/services/FirestoreMethods.dart';
import 'package:momenta_share/widgets/CustomAppBar.dart';
import 'package:momenta_share/widgets/PostCard.dart';
import 'package:momenta_share/widgets/ProfileEditorDialog.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? user;
  const ProfileScreen({super.key, this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel? displayedUser = widget.user ?? Provider.of<UserProvider>(context).user;
    final double width = MediaQuery.of(context).size.width > 600 ? 600 : MediaQuery.of(context).size.width;

    if (displayedUser == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: Scaffold(
        appBar: widget.user==null
            ? CustomAppBar(titleWidget: Text('MomentaShare', style: TextStyle(fontFamily: 'OleoScript', fontSize: width*0.0875)))
            : AppBar(
              title: Text("User Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: width*0.05)),
              centerTitle: true,
            ),
        body: Container(
          padding: EdgeInsets.all(width*0.0125),
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(displayedUser.uid).snapshots(),
                builder: (context, snapshot) {
                  bool followed = snapshot.hasData && snapshot.data!['followers'].contains(Provider.of<UserProvider>(context).user!.uid);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    UserModel user = UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
                    return Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: width*0.1,
                              backgroundImage: NetworkImage(user.photoUrl),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(user.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: width*0.05)),
                                  SizedBox(height: width*0.0125),
                                  Text(user.bio),
                                ],
                              ),
                            ),
                            if (widget.user == null)
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context, 
                                    builder: (context) => ProfileEditorDialog(username: user.username, bio: user.bio, photoUrl: user.photoUrl)
                                  );
                                },
                                icon: const Icon(Icons.edit)
                              )
                          ],
                        ),
                        SizedBox(height: width*0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(user.posts.length.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: width*0.05)),
                                Text('Posts', style: TextStyle(fontSize: width*0.05)),
                              ],
                            ),
                            Column(
                              children: [
                                Text(user.followers.length.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: width*0.05)),
                                Text('Followers', style: TextStyle(fontSize: width*0.05)),
                              ],
                            ),
                            Column(
                              children: [
                                Text(user.following.length.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: width*0.05)),
                                Text('Following', style: TextStyle(fontSize: width*0.05)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: width*0.0125),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: widget.user == null 
                                ? Colors.red.withOpacity(0.2)
                                : !followed
                                    ? Colors.blue
                                    : Colors.blue.withOpacity(0.2),
                            border: Border.all(color: widget.user == null 
                                ? Colors.red
                                : Colors.blue),
                            borderRadius: BorderRadius.circular(width*0.025)
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.transparent),
                              foregroundColor: MaterialStateProperty.all(
                                widget.user == null 
                                  ? Colors.red
                                  : followed
                                      ? Colors.blue
                                      : Colors.white
                              ),
                              padding: MaterialStateProperty.all(EdgeInsets.all(width*0.025)),
                            ),
                            onPressed: () async {
                              if (widget.user == null) {
                                AuthMethods.signOut();
                              } else {
                                await FirestoreMethods.followUser(displayedUser.uid);
                                setState(() {});
                              }
                            },
                            child: Text(
                              widget.user == null 
                                ? 'Log out'
                                : followed
                                    ? 'Unfollow'
                                    : 'Follow',
                              style: TextStyle(fontSize: width*0.05),
                            )
                          )
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: Text('No data'));
                  }
                }
              ),
              SizedBox(height: width*0.05),
              Text('Recent Posts', style: TextStyle(fontSize: width*0.075, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: displayedUser.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      List<PostModel> posts = [];
                      snapshot.data!.docs.forEach((doc) {
                        posts.add(PostModel.fromMap(doc.data() as Map<String, dynamic>));
                      });
                      return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          return PostCard(post: posts[index]);
                        },
                      );
                    } else {
                      return const Center(child: Text('No posts'));
                    }
                  }
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
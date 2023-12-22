import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:momenta_share/models/PostModel.dart';
import 'package:momenta_share/models/UserModel.dart';
import 'package:momenta_share/providers/UserProvider.dart';
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
    final UserModel? user = widget.user ?? Provider.of<UserProvider>(context).user;
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
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
        body: Container(
          padding: EdgeInsets.all(width*0.0125),
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
                builder: (context, snapshot) {
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
                  stream: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: user.uid).snapshots(),
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
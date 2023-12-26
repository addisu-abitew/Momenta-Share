import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:momenta_share/models/UserModel.dart';
import 'package:momenta_share/pages/ProfileScreen.dart';
import 'package:momenta_share/providers/UserProvider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchTerm = '';
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              contentPadding: EdgeInsets.all(0),
              prefixIcon: Icon(Icons.search),
              hintText: 'Search users',
            ),
            onFieldSubmitted: (value) {
              setState(() {
                searchTerm = value;
              });
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text('Search results for: $searchTerm'),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('username', isGreaterThanOrEqualTo: searchTerm)
                  .where('username', isLessThanOrEqualTo: '${searchTerm}z')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No users found'));
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data!.docs[index]['uid'] ==
                          Provider.of<UserProvider>(context).user!.uid) {
                        return const SizedBox(height: 0);
                      }
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              snapshot.data!.docs[index]['photoUrl']),
                        ),
                        title: Text(snapshot.data!.docs[index]['username']),
                        subtitle: Text(snapshot.data!.docs[index]['bio'], style: TextStyle(color: Colors.white.withOpacity(0.75))),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(user: UserModel.fromMap(snapshot.data!.docs[index].data()))));
                        },
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
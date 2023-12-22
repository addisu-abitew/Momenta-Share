import 'package:flutter/material.dart';
import 'package:momenta_share/pages/FavoritePostsScreen.dart';
import 'package:momenta_share/pages/FeedScreen.dart';
import 'package:momenta_share/pages/PostMoment.dart';
import 'package:momenta_share/pages/ProfileScreen.dart';
import 'package:momenta_share/pages/SearchScreen.dart';
import 'package:momenta_share/providers/UserProvider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 2;
  PageController pageController = PageController(initialPage: 2);

  changePage(int index) {
    setState(() {
      currentIndex = index;
    });
    pageController.jumpToPage(index);
  }
  
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).refreshUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: changePage,
          children: const [
            FeedScreen(),
            SearchScreen(),
            PostMoment(),
            FavoritePostsScreen(),
            ProfileScreen()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: changePage,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        )
      ),
    );
  }
}
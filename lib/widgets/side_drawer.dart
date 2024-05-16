import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orthoscan2/providers/auth.dart';
import 'package:orthoscan2/screens/feedback_screen.dart';
import 'package:orthoscan2/screens/historyandprogress_screen.dart';
import 'package:orthoscan2/screens/home_screen.dart';
import 'package:orthoscan2/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currUser = FirebaseAuth.instance.currentUser;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(0),
        bottomRight: Radius.circular(0),
      )),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: 0.3,
                  child: Image.network(
                    "https://i.pinimg.com/736x/c7/2d/b7/c72db792b13ec2b08cf1101d0307fb23.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 10,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(currUser!.uid)
                          .snapshots(),
                      builder: (context, userSnapshot) {
                        // print(currUser.uid);
                        final userData = userSnapshot.data;
                        if (userSnapshot.connectionState ==
                                ConnectionState.waiting ||
                            userData == null) {
                          // print(userData!.data());
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                    userData["userImageUrl"],
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   height: 7,
                            // ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                userData["username"],
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      // color: Theme.of(context).colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.bold,
                                      // shadows: [
                                      //   Shadow(
                                      //     blurRadius: 5,
                                      //     color: Colors.black.withOpacity(0.3),
                                      //     offset: const Offset(0,2),
                                      //   ),
                                      // ],
                                    ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                userData["email"],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      // shadows: [
                                      //   Shadow(
                                      //     blurRadius: 1.5,
                                      //     color: Colors.black.withOpacity(0.3),
                                      //     offset: const Offset(0,1.5),
                                      //   ),
                                      // ],
                                    ),
                              ),
                            ),
                          ],
                        );
                      }),
                )
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(top: 25),
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  _listTileBuilder(
                    context,
                    Icons.home,
                    "Home",
                    () {
                      Navigator.of(context)
                          .pushReplacementNamed(HomeScreen.routeName);
                    },
                  ),
                  _listTileBuilder(
                    context,
                    Icons.account_circle,
                    "My Profile",
                    () {
                      Navigator.of(context).pushNamed(ProfileScreen.routeName);
                    },
                  ),
                  // _listTileBuilder(
                  //   context,
                  //   Icons.history,
                  //   "History and Progress",
                  //   () {
                  //     Navigator.of(context)
                  //         .pushNamed(HistoryAndProgress.routeName);
                  //   },
                  // ),
                  _listTileBuilder(
                    context,
                    Icons.feedback,
                    "Feedback",
                    () {
                      Navigator.of(context).pushNamed(FeedbackScreen.routeName);
                    },
                  ),
                  Expanded(
                    // flex: 100,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      alignment: Alignment.bottomCenter,
                      // color: Colors.red,
                      child: _listTileBuilder(
                        context,
                        Icons.logout,
                        "Logout",
                        () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                                title: const Text(
                                    "Are you sure you want to logout?"),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Provider.of<Auth>(context, listen: false)
                                          .logout(context);
                                    },
                                    child: const Text("Yes"),
                                  ),
                                  FilledButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("No"),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
    // Drawer(
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.only(
    //       topRight: Radius.circular(0),
    //       bottomRight: Radius.circular(0),
    //     )
    //   ),
    //   child: Column(
    //     children: [

    //     ],
    //   ),
    // );
  }

  Material _listTileBuilder(
    BuildContext context,
    IconData iconData,
    String titleText,
    Function() ontap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: ontap,
        splashColor: Colors.white.withOpacity(0.2),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 40),
          leading: Icon(
            iconData,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          title: Text(
            titleText,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

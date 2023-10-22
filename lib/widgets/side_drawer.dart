import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(0),
                )
              ),      
              child: Column(                
                      children: [
                        Expanded(
                          flex: 1,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Opacity(
                                  child: Image.network(
                                    "https://i.pinimg.com/736x/c7/2d/b7/c72db792b13ec2b08cf1101d0307fb23.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                  opacity: 0.3,
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.only(
                                    top: 12,
                                    left: 10,
                                  ),
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          boxShadow: [BoxShadow(
                                            blurRadius: 10,
                                            color: Colors.black.withOpacity(0.3),
                                            offset: const Offset(0, 3),                                        
                                          )],
                                        ),
                                        child: const CircleAvatar(
                                          radius: 40,
                                          backgroundImage: NetworkImage(
                                            "https://i.pinimg.com/736x/20/c0/0f/20c00f0f135c950096a54b7b465e45cc.jpg",
                                            ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        "Full Name",
                                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
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
                                      Text(
                                        "email@gmail.com",
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                                    ],
                                  ),
                                )
                              ],
                            ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(                          
                            margin: const EdgeInsets.only(top:25),
                            height: double.infinity,
                            width: double.infinity,
                            child: Column(
                              children: [
                                _listTileBuilder(
                                  context,
                                  Icons.home,
                                  "Home",
                                  ),
                                _listTileBuilder(
                                  context, 
                                  Icons.account_circle,
                                  "My Profile",
                                  ),
                                _listTileBuilder(
                                  context,
                                  Icons.history,
                                  "History and Progress",
                                  ),
                                _listTileBuilder(
                                  context,
                                  Icons.feedback, 
                                  "Feedback",
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

  Material _listTileBuilder(BuildContext context, IconData iconData, String titleText) {
    return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){},
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
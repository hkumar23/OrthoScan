import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orthoscan2/providers/auth.dart';
import 'package:orthoscan2/screens/feedback_screen.dart';
import 'package:orthoscan2/screens/historyandprogress_screen.dart';
import 'package:orthoscan2/screens/home_screen.dart';
import 'package:orthoscan2/widgets/side_drawer.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile-screen';
  // File? userImage;
  ProfileScreen(
    this.toggleAppTheme,
    this.themeBrightness,
    );
  Brightness themeBrightness;
  void Function() toggleAppTheme;

  final _updateNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currUser=FirebaseAuth.instance.currentUser;
    Color primColor=Theme.of(context).colorScheme.primary;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      drawer: const SideDrawer(),
      // appBar: AppBar(title: const Text("Profile")),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.45,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const NetworkImage("https://cdn.wallpapersafari.com/56/84/YCLrBl.jpg"),
                fit: BoxFit.cover,
                opacity: 0.5,
                colorFilter: ColorFilter.mode(
                  primColor,
                  BlendMode.multiply,)
                )
            ),
          ),
          Column(            
            children: [
              Flexible(
                flex: 1,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("users").doc(currUser!.uid).snapshots(),
                  builder: (context, userSnapshot) {                    
                    final userData=userSnapshot.data;
                    if(userSnapshot.connectionState == ConnectionState.waiting ||
                    userData==null){
                      return const Center(child: CircularProgressIndicator(),);
                    }                    
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),    
                                blurRadius: 15,
                                offset: const Offset(0, 5),                                                    
                              )
                            ]
                          ),
                          child: CircleAvatar(                      
                            radius: 70,
                            backgroundImage: NetworkImage(userData["userImageUrl"]),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          userData["username"],
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onInverseSurface,
                            fontWeight: FontWeight.bold),
                          ),
                        Text(
                          userData["email"],
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onInverseSurface,
                            fontWeight: FontWeight.bold),),
                      ]);
                  }
                ),                
              ),
              Flexible(              
                flex: 2,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 300),                  
                  margin: const EdgeInsets.all(20),
                  child: Card(                    
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          child: SingleChildScrollView(
                            child: Column( 
                                mainAxisSize: MainAxisSize.min,                                       
                                children: [
                                  const SizedBox(height: 20,),
                                  ListTile(
                                    leading: const Icon(Icons.edit),
                                    title: const Text("Edit Name",style: TextStyle(fontWeight: FontWeight.bold),),
                                    trailing: const Icon(Icons.arrow_forward_rounded),
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context){
                                          return AlertDialog(                                           
                                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                            title: Text(
                                              "Choose a New Name",
                                              style: Theme.of(context).textTheme.headlineSmall,
                                              ),
                                            content: TextField(
                                                        controller: _updateNameController,
                                                        decoration: const InputDecoration(border: OutlineInputBorder()),                                              
                                                      ),
                                            actions: [
                                              OutlinedButton(
                                                onPressed: () => Navigator.of(context).pop(),
                                                child: const Text("Close"),
                                                ),
                                              FilledButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore.instance.collection("users").doc(currUser.uid).update({"username":_updateNameController.text.trim()});                                                    
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(context).showSnackBar(                                                      
                                                      SnackBar(
                                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                                        content: const Text("Information Updated")),
                                                    );
                                                  }, 
                                                  child: const Text("Update"),
                                                ),                                              
                                            ],                                         
                                          );
                                        },
                                      );                                      
                                    },
                                  ),       
                                  ListTile(
                                    leading: const Icon(Icons.image),
                                    title: const Text("Change Profile Image",style: TextStyle(fontWeight: FontWeight.bold),),
                                    trailing: const Icon(Icons.arrow_forward_rounded),
                                    onTap: (){},
                                  ),                   
                                  ListTile(
                                    leading: const Icon(Icons.lock),
                                    title: const Text("Change Password",style: TextStyle(fontWeight: FontWeight.bold),),
                                    trailing: const Icon(Icons.arrow_forward_rounded),
                                    onTap: (){
                                      showDialog(
                                        context: context, 
                                        builder: (BuildContext context){
                                          return AlertDialog(
                                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                            title: const Text("Confirm Password Change"),
                                            actions: [
                                              FilledButton(
                                                onPressed: (){
                                                  Provider.of<Auth>(context,listen: false).resetPassword(currUser.email!, context);
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context).showSnackBar(                                                      
                                                      SnackBar(
                                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                                        content: const Text(
                                                          "Password reset email sent successfully",
                                                          // style: TextStyle(fontWeight: FontWeight.bold),
                                                          )),
                                                    );
                                                }, 
                                                child: Text("Yes"),
                                              ),
                                              OutlinedButton(
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("No"),
                                                )
                                            ],
                                          );
                                        },
                                        );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.history),
                                    title: const Text("History and Progress",style: TextStyle(fontWeight: FontWeight.bold),),
                                    trailing: const Icon(Icons.arrow_forward_rounded),
                                    onTap: (){
                                      Navigator.of(context).pushNamed(HistoryAndProgress.routeName);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.home),
                                    title: const Text("Home",style: TextStyle(fontWeight: FontWeight.bold),),
                                    trailing: const Icon(Icons.arrow_forward_rounded),
                                    onTap: () {
                                      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      themeBrightness==Brightness.light ?
                                      Icons.dark_mode:
                                      Icons.light_mode),
                                    title: const Text("Switch Theme",style: TextStyle(fontWeight: FontWeight.bold),),
                                    trailing: const Icon(Icons.arrow_forward),
                                    onTap: toggleAppTheme,
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.feedback),
                                    title: const Text("Feedback",style: TextStyle(fontWeight: FontWeight.bold),),
                                    trailing: const Icon(Icons.arrow_forward_rounded),
                                    onTap: (){
                                      Navigator.of(context).pushNamed(FeedbackScreen.routeName);
                                     },
                                  ),                                             
                                  ListTile(
                                    leading: Icon(Icons.logout),
                                    title: Text("Logout",style: TextStyle(fontWeight: FontWeight.bold),),
                                    trailing: Icon(Icons.arrow_forward_rounded),
                                    iconColor: Colors.redAccent,
                                    textColor: Colors.redAccent,
                                    onTap: (){
                                      showDialog(
                                        context: context, 
                                        builder: (BuildContext context){
                                          return AlertDialog(
                                            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                                          title: const Text("Are you sure you want to logout?"),
                                          actions: [
                                            OutlinedButton(
                                              onPressed: (){
                                                Provider.of<Auth>(context,listen: false).logout(context);    
                                              }, 
                                              child: Text("Yes"),
                                            ),  
                                            FilledButton(
                                              onPressed: () => Navigator.of(context).pop(), 
                                              child: Text("No"),
                                              )
                                          ],
                                        );},
                                        );
                                    },
                                  ),    
                                  SizedBox(height: 20,),                  
                                ],
                              ),
                          ),
                          ),
                    ),
                  ),
            ],
          )
        ],
      ),
    );
  }
}

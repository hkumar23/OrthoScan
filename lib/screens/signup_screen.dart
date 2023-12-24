import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:orthoscan2/providers/auth.dart';
import 'package:orthoscan2/screens/home_screen.dart';
import 'package:orthoscan2/screens/login_screen.dart';
import 'package:orthoscan2/widgets/clip_paths.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup-screen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _passwordController =TextEditingController();
  final _formKey= GlobalKey<FormState>();
  bool isLoading=false;

  final _formData = {
    "email":"",
    "username":"",
  };

  // @override
  // void dispose() {
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  void _submit(BuildContext context) async {
    // print("submitted");
    FocusScope.of(context).unfocus();
    // _passwordController.clear();
    if(!_formKey.currentState!.validate()){
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading=true;
    });
    
    try{
      await Provider.of<Auth>(context, listen: false).authenticate(
        context: context,
        email: _formData["email"]!.trim(), 
        password: _passwordController.text.trim(),
        isSignup: true,
        userData: _formData
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Padding(
          padding: EdgeInsets.all(5),
          child: Text("Account Created"),
        ))
      );
      setState(() {
        isLoading=false;
      });
      // _passwordController.clear();
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      return;
    }catch(err){
      // print(err);
      setState(() {
        isLoading=false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading 
      ? const Center(child: CircularProgressIndicator(),) 
      : Stack(
        children: [
          ClipPath(
            clipper: UpperAuthScreen(),
            child: Container(
              // color: Theme.of(context).colorScheme.primary,
              decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.teal,Colors.indigo],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                    )
              ),
            ),
          ),
          ClipPath(
            clipper: LowerAuthScreen(),
            child: Container(
              // color: Theme.of(context).colorScheme.primary,
              decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.teal,Colors.indigo],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topCenter,
                    )
              ),
            ),
          ),
          Center(
            child: Card(
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(            
                padding:const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        key: const Key("username"),
                        validator: (value){
                          if(value!.isEmpty || value.length<4){
                            return "Please enter atleast 4 characters";
                          }      
                          return null;        
                        },
                        decoration: const InputDecoration(label: Text("Full Name")),
                        keyboardType: TextInputType.name,
                        onSaved: (value){
                          _formData["username"]=value!;
                        },
                      ),
                      const SizedBox(height: 5,),
                      TextFormField(
                        key: const Key("email"),
                        validator: (value){
                          if(value!.isEmpty || !value.contains("@")){
                            return "Please enter a valid Email Address";
                          }      
                          return null;        
                        },
                        decoration: const InputDecoration(label: Text("Email Address")),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value){
                          _formData["email"]=value!;
                        },
                      ),
                      const SizedBox(height: 5,),
                      TextFormField(
                        controller: _passwordController,
                        key: const Key("password"),
                        validator: (value){
                          if(value!.isEmpty || value.length < 8){
                            return "Password must be atleast 8 characters long";
                          }      
                          return null;        
                        },
                        decoration: const InputDecoration(label: Text("Password")),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      const SizedBox(height: 5,),
                      TextFormField(
                        key: const Key("confirm password"),
                        validator: (value){
                          if(value!.isEmpty || value!=_passwordController.text){
                            return "Password Didn't matched!";
                          }      
                          return null;        
                        },
                        decoration: const InputDecoration(label: Text("Confirm Password")),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20,),
                      FilledButton(
                        onPressed: (){
                          _submit(context);
                        }, 
                        child: const Text("Signup"),  
                      ),
                      const SizedBox(height: 5,),
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        }, 
                        child: const Text("I already have an account"),
                      ),
                    ],
                  )
                  ),
              ),
            ),
                    ),
          ),
        ],),
    );
  }
}
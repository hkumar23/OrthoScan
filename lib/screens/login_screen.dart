import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:orthoscan2/providers/auth.dart';
import 'package:orthoscan2/screens/signup_screen.dart';
import 'package:orthoscan2/widgets/clip_paths.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey= GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  
  final _passwordFocusNode=FocusNode();
  final _emailFocusNode=FocusNode();

  @override
  dispose(){
    _emailController.dispose();
    _emailFocusNode.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Map<String,dynamic> _formData={
    "email":"",
    "password":"",
  };

  bool isLoading=false;

  void _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
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
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            content: const Padding(
              padding: EdgeInsets.all(5),
              child: Text("Logged In Successfully"),
          ))
        );
      setState(() {
        isLoading=false;
      });
      return;
    }catch(err){
      debugPrint("Error Occured: $err");
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
        children:[ 
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
            child: Padding(            
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      key:const Key("email"),
                      validator: (value){
                        if(value!.isEmpty || !value.contains("@")){
                          return "Please enter a valid Email Address";
                        }      
                        return null;        
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: (){
                            _emailController.clear();
                            _emailFocusNode.requestFocus();
                          }),
                        label: const Text("Email Address"),
                        ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value){
                        _formData["email"]=value;
                      },
                    ),
                    const SizedBox(height: 5,),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      key: const Key("password"),
                      validator: (value){
                        if(value!.isEmpty || value.length < 8){
                          return "Password must be atleast 8 characters long";
                        }      
                        return null;        
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: (){
                            _passwordController.clear();
                            _passwordFocusNode.requestFocus();
                          }),
                        label: const Text("Password"),
                        ),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      onSaved: (value){
                        _formData["password"]=value;
                      },
                    ),
                    const SizedBox(height: 20,),
                    FilledButton(
                      onPressed: (){
                        _submit(context);
                      }, 
                      child: const Text("Login"),
                    ),
                    const SizedBox(height: 5,),
                    TextButton(
                      onPressed: (){
                        Navigator.pushNamed(context,SignupScreen.routeName);
                      }, 
                      child: const Text("Create new account"),
                    ),
                  ],
                )
                ),
            ),
          ),
          ),
      ],),
    );
  }
}
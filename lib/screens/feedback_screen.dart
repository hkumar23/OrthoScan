import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orthoscan2/providers/auth.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  static const routeName='/feedback-screen';

  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  Map<String,String>? formData;
  bool isLoading=false;

  @override
  void initState() {
    // TODO: implement initState
    
    formData={
      'subject':'',
      'feedback': '',
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'date': '',
    };
    super.initState();
  }

  void _trySubmit() async {
    FocusScope.of(context).unfocus();
    if(!_formKey.currentState!.validate()){
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading=true;
    });

    String tempString="";
    bool errOccured=false;
    formData!['date']=DateTime.now().toIso8601String();

    try{
      await FirebaseFirestore.instance.collection("user_feedbacks").add(formData!);
      tempString="Thanks for your feedback!";
    }
    catch(err){
      errOccured=true;
      tempString="Something went wrong. Please try again later.";
    }
    setState(() {
        isLoading=false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: errOccured 
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.inverseSurface,
          content: Text(tempString,style: const TextStyle(fontWeight: FontWeight.w500),),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Share Your Feedback",
          style: GoogleFonts.robotoCondensed(
            fontWeight: FontWeight.w600,
            ),
          ),
      ),
      body: Container(   
        alignment: Alignment.center,        
        // height: 200,    
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          // margin: const EdgeInsets.all(15),                           
          child: Form(  
            key: _formKey,           
            child: SingleChildScrollView(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                    Container(
                      padding: const EdgeInsets.only(left: 5,bottom: 30),
                      alignment: Alignment.centerLeft,
                      child: 
                          Text(
                            // "We would love to hear from you!"
                            "Tell Us How We're Doing.",
                            style: GoogleFonts.robotoCondensed(    
                              letterSpacing: 0.1,                    
                              fontSize: 55,
                              height: 1.1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    ),
                    Card(
                      elevation: 3,
                      color: Theme.of(context).colorScheme.tertiaryContainer,                                                                 
                        child: TextFormField(   
                          controller: _subjectController,
                          style: GoogleFonts.cabin(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(                                                     
                            prefixIcon: const Icon(Icons.subject),
                            suffixIcon: IconButton(                              
                              icon: const Icon(Icons.cancel_outlined),
                              onPressed: (){
                                  _subjectController.clear();   
                                  FocusScope.of(context).requestFocus();                           
                                },
                              ),                            
                            labelText: "Subject",
                            // hintText: "Feedback Topic",
                            labelStyle: GoogleFonts.oswald(                              
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                            border: const OutlineInputBorder(         
                              // borderSide: BorderSide.none,                     
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Please enter a subject";
                            }
                            if(value.length>80){
                              return "Sujbect should be less than 80 characters";
                            }
                            return null;
                          },
                          onSaved: (value){
                            formData!['subject']=value!;
                          },                                                   
                        ),                      
                      ),  
                    const SizedBox(height: 5,),
                    Card(
                      elevation: 3,
                      color: Theme.of(context).colorScheme.tertiaryContainer,                                                                 
                        child: TextFormField( 
                          controller: _bodyController,                                                    
                          // textAlign: TextAlign.start,                          
                          // textAlignVertical: TextAlignVertical.top,
                          style: GoogleFonts.cabin(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 7,                  
                          decoration: InputDecoration(                              
                            alignLabelWithHint: true,
                            floatingLabelAlignment: FloatingLabelAlignment.start,
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 160),
                              child: Icon(Icons.edit_document)
                              ),                                                   
                            labelText: "Your Feedback",
                            hintText: "Write your feedback here...",
                            labelStyle: GoogleFonts.oswald(                              
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),                            
                            border: const OutlineInputBorder(         
                              // borderSide: BorderSide.none,                     
                              borderRadius: BorderRadius.all(Radius.circular(10)),                              
                            ),
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Please enter your feedback";
                            }
                            if(value.length<20){
                              return "Feedback should be more than 20 characters";
                            }
                            if(value.length>500){
                              return "Feedback should be less than 500 characters";
                            }
                            return null;
                          },
                          onSaved: (value){
                            formData!['feedback']=value!;                          
                          },
                        ),                      
                      ),  
                    const SizedBox(height: 15,),
                    ElevatedButton(                      
                        style: ButtonStyle(                          
                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            )),
                          foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),
                          backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                          shape: MaterialStateProperty.all(                            
                            RoundedRectangleBorder(                              
                              borderRadius: BorderRadius.circular(10),
                            )
                          )
                        
                        ),
                        onPressed: _trySubmit, 
                        child: Text(
                          "Submit",
                          style: GoogleFonts.oswald(                         
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),     
                          ),                        
                    ),      
                ],
              ),
            ),
          ),
        ),
      );
  }
}
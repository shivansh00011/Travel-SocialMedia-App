import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  // String email="";
  // final _formkey = GlobalKey<FormState>();
  
   resetPassword() async{
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Reset Email Has Been Sent")));

      
    } catch (e) {
      
    }

  }
  @override
  

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.only(
                  //  bottomLeft: Radius.circular(200),
                   bottomRight: Radius.circular(200)
                )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Forgot Password?', style: TextStyle(fontSize: 32, ),),
                    Text('Don\'t Worry', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),)
                    
                  ],
                ),
              ),
            ),
             const SizedBox(
              height: 40,
            
            ),
            Padding(padding: 
            const EdgeInsets.only(left: 20, right: 20),
            child: Text('Email', style: TextStyle(fontSize: 18, fontWeight:FontWeight.bold),),
            
            ),
            const SizedBox(height: 10,),
            Padding(padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_2_outlined),
                hintText: 'Enter Your Email'
              ),
            ),
            ),
             const SizedBox(height: 35,),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: InkWell(
                onTap: resetPassword,
                child: Container(
                  height: 60,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 204, 27, 86),
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: Center(
                    child: Text('Send Mail', style: TextStyle(color: Colors.white, fontSize: 19),),
                  ),
                ),
              ),
            ),
          ]
        ))

    );
  }
}